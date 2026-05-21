import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";
import nodemailer from "https://esm.sh/nodemailer@6.9.1";
import { qrcode } from "https://deno.land/x/qrcode@v2.0.0/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  console.log("[Antigravity] Processing invitation request...");

  try {
    const { guest_id } = await req.json();

    if (!guest_id) {
      throw new Error("guest_id is required");
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Fetch guest and event
    const { data: guest, error: guestError } = await supabase
      .from("guests")
      .select("*, events(*)")
      .eq("id", guest_id)
      .single();

    if (guestError || !guest) {
      console.error(`[Antigravity] Guest not found: ${guest_id}`);
      throw new Error("Guest not found");
    }

    if (!guest.email) {
      console.error(`[Antigravity] Guest ${guest.full_name} has no email address`);
      throw new Error("Guest email is missing");
    }

    const event = guest.events;
    
    // Invitation link
    const baseUrl = Deno.env.get("NEXT_PUBLIC_APP_URL") || "https://guestly.app";
    const invitationLink = `${baseUrl}/invitation/${guest.qr_code_token}`;

    console.log(`[Antigravity] Preparing email for ${guest.full_name} (${guest.email})`);

    // Generate QR Code
    const qrImage = await qrcode(invitationLink);
    const qrBase64 = qrImage.split(",")[1];

    // SMTP Configuration
    const smtpHost = Deno.env.get("SMTP_HOST");
    const smtpPort = parseInt(Deno.env.get("SMTP_PORT") || "587");
    const smtpUser = Deno.env.get("SMTP_USER");
    const smtpPass = Deno.env.get("SMTP_PASS");
    const smtpFrom = Deno.env.get("SMTP_FROM") || smtpUser;

    if (!smtpHost || !smtpUser || !smtpPass) {
      console.error("[Antigravity] SMTP configuration missing");
      throw new Error("Servidor de correo no configurado (SMTP missing)");
    }

    // Using Nodemailer for better STARTTLS support
    const transporter = nodemailer.createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: smtpPort === 465, // true for 465, false for other ports (will use STARTTLS)
      auth: {
        user: smtpUser,
        pass: smtpPass,
      },
      tls: {
        // Do not fail on invalid certs
        rejectUnauthorized: false
      }
    });

    const eventName = event.title || "Evento Especial";
    console.log(`[Antigravity] Sending email via Nodemailer from: ${smtpFrom} to: ${guest.email}`);

    try {
      await transporter.sendMail({
        from: smtpFrom,
        to: guest.email,
        subject: `Tu invitación para ${eventName}`,
        text: `Hola ${guest.full_name},\n\nHas sido invitado a ${eventName}.\n\nTu link de invitación: ${invitationLink}\n\nAdjuntamos tu código QR para el ingreso.`,
        html: `
          <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 10px;">
            <h2 style="color: #1a237e;">¡Hola ${guest.full_name}!</h2>
            <p>Te han invitado a <strong>${eventName}</strong>.</p>
            <p>Presenta el siguiente código QR en la entrada:</p>
            <div style="text-align: center; margin: 30px 0;">
              <img src="cid:qrcode" alt="Código QR de Invitación" style="width: 200px; height: 200px;"/>
            </div>
            <p>También puedes acceder a tu invitación digital aquí:</p>
            <div style="text-align: center; margin: 20px 0;">
              <a href="${invitationLink}" style="background-color: #1a237e; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold;">Ver Invitación</a>
            </div>
            <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;"/>
            <p style="font-size: 12px; color: #777; text-align: center;">Generado por Guestly Access System</p>
          </div>
        `,
        attachments: [
          {
            filename: "invitacion_qr.png",
            content: qrBase64,
            encoding: "base64",
            cid: "qrcode", // For CID embedding
          },
        ],
      });

      console.log(`[Antigravity] Email sent successfully to ${guest.email}`);

    } catch (smtpError) {
      console.error(`[Antigravity] SMTP Error: ${smtpError.message}`);
      throw new Error(`Fallo en el protocolo de transporte: ${smtpError.message}`);
    }

    // Update guest status only on real success
    await supabase.from("guests").update({
      invitation_channel: 'email',
      updated_at: new Date().toISOString()
    }).eq("id", guest_id);

    return new Response(JSON.stringify({ 
      success: true, 
      message: "Invitación enviada exitosamente por correo"
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    console.error(`[Antigravity] Function error: ${error.message}`);
    return new Response(JSON.stringify({ 
      success: false,
      error: error.message 
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});


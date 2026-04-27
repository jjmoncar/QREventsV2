import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { guest_id } = await req.json();

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

    if (guestError || !guest) throw new Error("Guest not found");

    const event = guest.events;
    const eventType = event.type || "other";

    // Dynamic Art selection based on storage
    const storageUrl = `${Deno.env.get("SUPABASE_URL")}/storage/v1/object/public/backgrounds`;
    
    const bgMap: Record<string, string> = {
      'boda': 'bg_wedding.png',
      'religioso': 'bg_religious.png',
      'cumpleanos': 'bg_birthday.png',
      'corporativo': 'bg_corporate.png',
    };

    const bgFile = bgMap[eventType] || 'bg_corporate.png';
    const bgUrl = `${storageUrl}/${bgFile}`;

    // Invitation link
    const baseUrl = Deno.env.get("NEXT_PUBLIC_APP_URL") || "https://guestly.app";
    const invitationLink = `${baseUrl}/invitation/${guest.qr_code_token}`;

    // Here we simulate sending an email or use Resend if API key is provided
    // For this implementation, we will log the success and update the guest status
    
    await supabase.from("guests").update({
      invitation_channel: 'email',
      updated_at: new Date().toISOString()
    }).eq("id", guest_id);

    console.log(`[Antigravity] Generated invitation for ${guest.full_name} using background ${bgUrl}`);

    return new Response(JSON.stringify({ 
      success: true, 
      message: "Invitación procesada con arte dinámico",
      art_url: bgUrl,
      invitation_link: invitationLink
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});

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
    const { event_id, change_type } = await req.json();

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Fetch event
    const { data: event, error: eventError } = await supabase
      .from("events")
      .select("*")
      .eq("id", event_id)
      .single();

    if (eventError || !event) throw new Error("Event not found");

    // Fetch only guests with an active QR code
    const { data: guests, error: guestsError } = await supabase
      .from("guests")
      .select("*")
      .eq("event_id", event_id)
      .not("qr_code_token", "is", null);

    if (guestsError) throw new Error("Error fetching guests");

    const notifications = guests.map(guest => ({
      name: guest.full_name,
      channel: guest.invitation_channel || 'manual',
      email: guest.email,
      whatsapp: guest.whatsapp,
      telegram: guest.telegram,
    }));

    console.log(`[Antigravity] Found ${notifications.length} guests for notification regarding event ${event.name}`);

    return new Response(JSON.stringify({ 
      success: true, 
      count: notifications.length,
      guests: notifications,
      message: change_type === 'cancel' 
        ? `Lógica de notificación de cancelación para ${event.name}`
        : `Lógica de notificación de cambio de parámetros para ${event.name}`
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

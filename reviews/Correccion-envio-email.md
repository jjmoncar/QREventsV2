Esta es la séptima corrección técnica para Guestly, enfocada en la fiabilidad del sistema de notificaciones y la integración con el servicio de correo del servidor.

Documento de Actualización de Requerimientos (ERS): Guestly
Estado: Depuración del Servicio de Correo y Validación de Entrega (V2.6)
Proyecto: Guestly (Actualización de sistema existente)
Arquitectura: Antigravity Server (Backend) / SMTP Service

1. Resumen de la Modificación
Se requiere solucionar un fallo crítico en la entrega de invitaciones por correo electrónico. Actualmente, existe una discrepancia entre el estado reportado por la interfaz (éxito) y la ejecución real del envío en el backend, lo que resulta en la no recepción de los códigos QR por parte de los invitados.

2. Corrección de Lógica: Proceso de Envío de Invitaciones (Email)
El sistema debe garantizar que la confirmación de "Envío Exitoso" solo se muestre cuando el servidor de correo haya aceptado y procesado el mensaje correctamente.

Descripción del Problema: Al disparar la opción de envío por correo, la aplicación muestra una alerta de éxito, pero el mensaje no llega al destinatario (ni a la bandeja de entrada ni a spam). Esto indica un posible fallo en la configuración SMTP del servidor Antigravity o en la construcción del paquete MIME que contiene la imagen del QR.

Requerimiento de Corrección:

Validación de SMTP: Revisar y corregir las credenciales y la configuración del host SMTP en el backend de Antigravity para asegurar la salida de correos.

Manejo de Errores Real: El frontend solo debe mostrar el mensaje de éxito si el servidor devuelve un código de estado 200 OK tras una confirmación real del protocolo de transporte.

Construcción del Mensaje: Asegurar que el código QR se adjunte correctamente como imagen (CID) o se incruste de forma que no sea bloqueado por filtros de seguridad de los proveedores de correo (Gmail, Outlook, etc.).

3. Especificaciones Técnicas (Antigravity Server)
Logs de Salida: Implementar un registro (logging) detallado en el servidor para rastrear cada intento de envío y capturar el error exacto devuelto por el servidor de correo (ej. errores de autenticación, rechazo de remitente o cuotas excedidas).

Seguridad: Verificar que el dominio remitente cuente con registros SPF, DKIM y DMARC configurados para evitar que los correos sean descartados silenciosamente por los servidores de destino.

Formato del QR: Al enviar el correo, el servidor debe generar la imagen y asegurarse de que el enlace o archivo adjunto sea procesable por cualquier cliente de correo estándar.

4. Verificación de Éxito
Se considerará corregido cuando:

Se realice una prueba de envío a una dirección real y el correo llegue en menos de 2 minutos.

Si el envío falla por cualquier motivo técnico (ej. falta de internet en el servidor), la aplicación muestre un mensaje de error: "No se pudo enviar el correo, intente más tarde", en lugar de decir que se envió con éxito.

El correo recibido contenga el saludo, la información del evento y la imagen clara del código QR.
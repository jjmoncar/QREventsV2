Esta es la quinta actualización técnica para Guestly, centrada en endurecer las reglas de negocio para el control de acceso y la gestión del ciclo de vida automático de los eventos.

Documento de Actualización de Requerimientos (ERS): Guestly
Estado: Control de Acceso Temporal y Finalización Automática (V2.4)
Proyecto: Guestly (Actualización de sistema existente)
Arquitectura: Antigravity Server / Flutter Mobile

1. Resumen de la Modificación
Se implementa una ventana de tiempo estricta para la validación de invitados. El objetivo es evitar el acceso fuera de la fecha programada y automatizar el cierre de eventos para mantener la integridad de los datos y la seguridad del acceso.

2. Reglas de Validación de Tiempo (Check-in)
El escáner de la aplicación debe validar la fecha y hora actual del dispositivo/servidor contra los campos fecha_hora del evento en la base de datos.  

Apertura de Validación: Solo se permitirá el escaneo de códigos QR si se cumplen ambas condiciones:

La fecha actual es la misma fecha del evento.  

La hora actual está comprendida dentro del rango de 1 hora antes de la hora de inicio pautada.

Mensajes de Error:

Si se intenta escanear en un día previo: "El evento aún no ha comenzado. Fecha programada: [Fecha]".

Si se intenta escanear el mismo día, pero antes de la hora de antelación permitida: "El acceso se habilitará una hora antes del inicio".

3. Finalización Automática del Evento
Para optimizar la gestión del historial, se establece un tiempo de expiración definitivo.  


Cierre por Transcurso de Tiempo: Exactamente 12 horas después de la hora de inicio pautada, el evento debe cambiar su estado a "Finalizado" o "Inactivo" de forma automática.  

Restricción Post-Evento: Una vez transcurrido este periodo de 12 horas, el sistema debe rechazar cualquier intento de escaneo, indicando que el evento ha concluido.

4. Especificaciones Técnicas (Antigravity Server)

Lógica de Negocio (Backend): El servidor Antigravity debe ser el encargado de realizar esta comparación de fechas al recibir la petición de validación del QR para evitar manipulaciones en el reloj del cliente.  


Proceso Automático: Se recomienda un "Cron Job" o un proceso de fondo en Dart que verifique periódicamente la tabla de Eventos y actualice el campo estado de aquellos que hayan superado las 12 horas desde su inicio.  

5. Verificación de Éxito
Se considerará corregido cuando:

Un invitado intente ingresar 2 horas antes del evento y el sistema le deniegue el acceso con el mensaje correspondiente.

El sistema permita el acceso sin problemas 60 minutos antes de la hora pautada.

Al cumplirse las 12 horas desde el inicio del evento, este se mueva automáticamente a la sección de "Historial" en el Dashboard y el escáner deje de procesar sus invitaciones.
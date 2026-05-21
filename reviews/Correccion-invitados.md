Aquí tienes el documento técnico para la octava corrección, enfocado en la gestión de estados de invitación y la consistencia visual en el listado de asistentes de Guestly.

Documento de Actualización de Requerimientos (ERS): Guestly
Estado: Evolución de Estados de Invitado y Consistencia en Listados (V2.8)
Proyecto: Guestly (Actualización de sistema existente)
Arquitectura: Full-Stack Dart/Flutter con Antigravity

1. Resumen de la Modificación
Se requiere una actualización en la lógica de estados de los invitados para reflejar con precisión el ciclo de vida de la invitación (creación, envío y asistencia). Asimismo, se busca estandarizar la visualización de cupos en los listados rápidos para todo tipo de invitaciones.

2. Ciclo de Vida y Estados del Invitado
El campo de estado debe ser dinámico y cambiar según las acciones realizadas en la aplicación:

Estado: Pendiente (Naranja/Amarillo): Es el estado inicial. Indica que el invitado ha sido registrado en la base de datos pero aún no se le ha enviado la invitación formal.

Estado: Invitado (Color a definir, ej. Azul): El estado cambia automáticamente a "Invitado" una vez que el usuario utiliza cualquier método de envío (WhatsApp, Telegram o Email) desde la aplicación.

Estado: Asistió (Verde): El estado cambia a verde únicamente cuando el código QR ha sido escaneado y validado con éxito en la entrada del evento.

3. Flexibilidad en el Envío de Invitaciones
Para garantizar que ningún invitado quede fuera por falta de datos previos:

Acceso Universal al Envío: El botón de "Enviar Invitación" (icono de compartir o avión de papel) debe estar habilitado para todos los invitados, incluso si no tienen registrado un número de teléfono o correo electrónico en la ficha de la aplicación.

Lógica: Al presionar el botón en estos casos, se debe abrir el menú nativo de compartir del dispositivo para que el organizador elija la aplicación de destino manualmente.

4. Visualización en "Lista Rápida de Invitados"
Se requiere consistencia en la información de cupos mostrada en el Dashboard y listados:

Invitaciones Grupales: Mantener el formato actual que muestra el progreso de ingreso (ej. 0/3 personas han ingresado).

Invitaciones Individuales: Todos los invitados individuales deben mostrar ahora el indicador 0/1 debajo de su nombre, indicando que hay una persona pendiente por ingresar. Ningún invitado debe quedar sin este indicador numérico.

5. Especificaciones Técnicas (Antigravity Server & Flutter)
Base de Datos: El campo asistio (booleano) debe expandirse o complementarse con un campo estado_envio para rastrear si la invitación ya salió del sistema.

Frontend (Flutter): Actualizar el widget de la tarjeta del invitado para que el texto de estado y su color de fondo dependan de la nueva lógica de tres niveles (Pendiente -> Invitado -> Asistió).

6. Verificación de Éxito
Se considerará corregido cuando:

Un nuevo invitado aparezca como "Pendiente".

Tras compartir su QR por WhatsApp, su estado cambie visualmente para indicar que ya fue invitado.

Al escanearlo en la puerta, el estado cambie a color verde.

Todos los invitados en la lista rápida, sean individuales o grupos, muestren el contador de personas (ej. 0/1, 0/5).
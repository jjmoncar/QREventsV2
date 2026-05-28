Documento de Actualización de Requerimientos (ERS): Guestly
Estado: Reglas de Capitalización de Texto y Adaptación Dinámica de Formato de Hora (V2.10)

Proyecto: Guestly (Actualización de sistema existente)

Arquitectura: Flutter Mobile (Frontend)

1. Resumen de la Modificación
Se implementan restricciones estricta de formato en los campos de entrada de texto (TextBox / TextField) para garantizar la consistencia visual en los datos guardados. Además, se añade soporte global para detectar y adaptarse automáticamente al formato de hora local del teléfono (12 horas o 24 horas), tanto en la visualización de datos como en los selectores de hora al crear eventos.

2. Reglas de Capitalización en Campos de Texto (TextBox)
Para evitar inconsistencias en la escritura de los usuarios, los componentes de entrada de texto deben aplicar las siguientes configuraciones automáticas:

Regla General (Mayúscula Oracional): En todos los campos de texto de la aplicación donde el usuario vaya a escribir una descripción, título de evento, notas o cualquier texto general, se debe forzar el uso de mayúscula oracional. Esto significa que automáticamente solo la primera letra de la primera palabra se escribirá en mayúscula.

Regla Especial para el Nombre del Invitado (Mayúscula Tipo Título): El campo específico donde se introduce el nombre de los invitados debe configurarse obligatoriamente con mayúscula tipo título (textCapitalization: TextCapitalization.words en Flutter).

Cada palabra ingresada en este campo debe comenzar con mayúscula de forma automática.

Ejemplo: Si el usuario escribe miguel angel herrera silva, la aplicación debe transformarlo en tiempo real o al guardar a: Miguel Angel Herrera Silva (primer nombre, segundo nombre, primer apellido y segundo apellido con su primera letra en mayúscula).

3. Adaptación Dinámica del Formato de Hora (12h / 24h)
La aplicación ya no tendrá un formato de hora fijo; ahora debe leer la configuración nativa del sistema operativo del teléfono móvil y transformar la interfaz de manera reactiva.

Detección del Formato: Al iniciar la app, el frontend de Flutter debe consultar si el dispositivo utiliza el formato de 24 horas utilizando las propiedades del sistema (MediaQuery.of(context).alwaysUse24HourFormat).

Comportamiento en la Interfaz de Usuario (Visualización):

Si el teléfono está en formato de 12 horas: Todas las horas mostradas en la aplicación (en tarjetas de eventos, listas, etc.) deben incluir los sufijos AM o PM según corresponda.

Si el teléfono está en formato de 24 horas: Las horas se mostrarán corrido (de 00:00 a 23:59) y se omitirá por completo el indicador AM/PM.

Comportamiento al Crear un Nuevo Evento (Entrada de Datos):

El componente selector de hora (Time Picker) que se despliega al registrar o especificar la hora de un evento debe adaptarse automáticamente al formato del teléfono.

Si el usuario tiene formato de 12 horas, el selector debe permitir elegir la hora junto con la perilla/botón de AM y PM.

Si el usuario tiene formato de 24 horas, el selector se mostrará directamente con el reloj de 24 horas completo.

4. Especificaciones Técnicas (Frontend)
Usar la propiedad textCapitalization: TextCapitalization.sentences para los campos comunes.

Usar la propiedad textCapitalization: TextCapitalization.words exclusivamente para el campo de nombres.

Utilizar paquetes de formateo como intl (DateFormat) combinados con la detección nativa para asegurar que la conversión de las variables DateTime de la base de datos se muestren en la pantalla respetando la elección del usuario (12h/24h).

5. Verificación de Éxito
Se considerará corregido cuando:

Al escribir el nombre de un invitado, todas las palabras separadas por espacios comiencen automáticamente con mayúscula.

En cualquier otro campo de texto de la app, solo la primera letra del párrafo/oración se ponga en mayúscula.

Si un usuario cambia la configuración de su teléfono de 12 horas a 24 horas, la aplicación cambie inmediatamente la forma en que muestra la hora de sus reuniones y adapte el selector de hora en consecuencia.
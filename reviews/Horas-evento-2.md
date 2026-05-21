Documento de Actualizaci�n de Requerimientos (ERS): Guestly
Estado: Control de Acceso Temporal, Ciclo de Vida y Restricci�n de Interfaz (V2.4)
Proyecto: Guestly (Actualizaci�n de sistema existente)
Arquitectura: Antigravity Server / Flutter Mobile

1. Resumen de la Modificaci�n
Se implementa una ventana de tiempo estricta para la validaci�n de invitados y la visibilidad de las herramientas de control. El objetivo es evitar el acceso fuera de la fecha/hora programada y automatizar el cierre de eventos, gestionando correctamente aquellos que inician un d�a y terminan al d�a siguiente.

2. Reglas de Validaci�n de Tiempo (Check-in)
El sistema debe validar la fecha y hora actual contra los campos fecha_hora del evento registrados en la base de datos.  

Apertura de Validaci�n: Solo se permitir� el escaneo si se cumplen ambas condiciones:

La fecha actual es la misma fecha del evento.  

La hora actual est� comprendida dentro del rango de 1 hora antes de la hora de inicio pautada.

Mensajes de Error:

Si se intenta escanear en un d�a previo: "El evento a�n no ha comenzado. Fecha programada: [Fecha]".

Si se intenta escanear el mismo d�a, pero antes de la hora de antelaci�n permitida: "El acceso se habilitar� una hora antes del inicio".

3. Restricci�n de la Interfaz (Bot�n de Escaneo)
Para evitar intentos de acceso inv�lidos, la interfaz de la aplicaci�n debe adaptarse al tiempo:

Visibilidad Condicional: El bot�n de "Escanear QR" debe permanecer oculto o inactivo en todos los m�dulos de la aplicaci�n si no se est� dentro del rango de tiempo permitido (1 hora antes del inicio hasta 6 horas despu�s del inicio).

Prop�sito: Eliminar la posibilidad de que el organizador intente abrir el esc�ner fuera de las horas operativas del evento.

4. Finalizaci�n Autom�tica y Cambio de D�a
Se establece un periodo de validez de 6 horas para cada evento, permitiendo que el evento concluya el d�a calendario siguiente al que inici�.


Cierre por Transcurso de Tiempo: Exactamente 6 horas despu�s de la hora de inicio pautada, el evento debe marcarse como "Finalizado" autom�ticamente.  

Gesti�n de Transici�n de D�a: El sistema debe calcular la expiraci�n sumando 6 horas a la hora de inicio, sin importar si esto resulta en una fecha distinta (por ejemplo, un evento que inicia a las 10:00 PM de un s�bado y finaliza a las 4:00 AM del domingo).


Restricci�n Post-Evento: Una vez transcurridas las 6 horas, el evento se mueve al historial y no se permitir� ning�n escaneo adicional.  

5. Especificaciones T�cnicas (Antigravity Server)

L�gica de Negocio (Backend): El servidor Antigravity debe realizar la comparaci�n de fechas al recibir peticiones, comparando la fecha_evento con la fecha_actual del servidor para evitar manipulaciones.  


Proceso Autom�tico: Se requiere un proceso de fondo que actualice el campo estado de los eventos bas�ndose en la marca de tiempo de finalizaci�n (Inicio + 6 horas).
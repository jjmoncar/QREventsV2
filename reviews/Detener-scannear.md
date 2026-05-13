Documento de Actualización de Requerimientos (ERS): Guestly
Estado: Optimización de Flujo de Cámara y Control de Ciclo de Vida (V2.2)
Proyecto: Guestly (Actualización de sistema existente)
Arquitectura: Flutter Mobile (Frontend)

1. Resumen de la Modificación
El objetivo es corregir el comportamiento de la cámara durante el proceso de verificación de invitados. Se requiere que el flujo de captura se detenga inmediatamente después de una lectura exitosa para evitar escaneos accidentales y reducir el consumo de recursos mientras el usuario interactúa con los diálogos de confirmación.

2. Corrección de Lógica: Control de Estado de la Cámara
Actualmente, el visor de la cámara permanece activo y procesando imágenes en segundo plano mientras se muestran los modales de selección de cantidad de personas y los mensajes de confirmación parcial.

Descripción del Problema: Al escanear un QR válido para un grupo, la cámara sigue encendida debajo de las ventanas emergentes de "¿Cuántas personas están ingresando?" y del mensaje naranja de "Acceso Parcial".

Requerimiento de Corrección:

Pausa Inmediata: Tan pronto como el escáner detecte y valide un código QR, el flujo de la cámara debe detenerse (pause) o congelarse.

Bloqueo de Escaneo: Durante la interacción con el selector de invitados (ajuste de cantidad) y la visualización del estado de cupos restantes, el sensor no debe procesar nuevos códigos.

Reactivación Controlada: La cámara solo volverá a activarse cuando el usuario presione explícitamente el botón "CONTINUAR ESCANEANDO" en el modal de confirmación final.

3. Especificaciones Técnicas (Flutter Mobile)
Gestión de Controladores: Se debe implementar una llamada al método pauseCamera() del paquete de escaneo utilizado (ej. qr_code_scanner o mobile_scanner) inmediatamente después de disparar la lógica de validación del QR.

Interfaz de Usuario (UX):

Al congelarse la cámara, se puede mostrar la última imagen capturada o un fondo oscuro traslúcido para centrar la atención del organizador en el diálogo de selección de invitados.

El botón de confirmación final debe servir como disparador del método resumeCamera().

4. Verificación de Éxito
Se considerará corregido cuando:

Tras escanear el código de "Pedro Perez", la imagen de la cámara se detenga visualmente mientras se ajusta la cantidad de personas.

Al aparecer el mensaje naranja de "Acceso Parcial", la cámara permanezca inactiva.

El dispositivo no intente leer otros códigos QR cercanos mientras el organizador está gestionando el ingreso actual.

La cámara se reactive suavemente solo después de tocar "Continuar Escaneando".
# Documento de Actualización de Requerimientos (ERS): Guestly

**Estado:** Corrección de Errores y Optimización (V2.0)  
**Arquitectura:** Full-Stack Dart/Flutter con Antigravity

---

## 1. Resumen de la Modificación

El objetivo es estandarizar el mensaje de invitación en el módulo de Gestor de Invitados. Se busca eliminar la redundancia de datos técnicos en el proceso de “Compartir”, asegurando que el invitado reciba una interfaz limpia y centrada exclusivamente en el código QR y la información del evento.

---

## 2. Corrección de Lógica: Módulo de Envío Multicanal

Actualmente, al compartir un pase desde la aplicación, el sistema genera una cadena de texto que incluye una URL del servidor local (`http://localhost:3000/...`). Esta corrección debe aplicarse a todos los métodos de envío disponibles en el menú nativo del dispositivo (WhatsApp, Telegram, Email, SMS, etc.).

### Descripción del Error

El mensaje de invitación concatena automáticamente una URL técnica al final del texto informativo.

### Requerimiento de Corrección

#### Eliminación Global de URL

Se debe suprimir la generación de la dirección:

```txt
http://localhost:3000/invitation/...
```

en cualquier flujo de salida de datos hacia aplicaciones externas.

#### Justificación

El código QR enviado como imagen ya contiene la información necesaria para el control de acceso. El enlace local es inoperante para el invitado y ensucia la estética del mensaje profesional.

#### Estructura del Mensaje (Universal)

El mensaje debe contener únicamente:

- Saludo.
- Nombre del invitado.
- Detalles del evento.
- Imagen del código QR adjunta.

---

## 3. Especificaciones Técnicas (Antigravity & Flutter)

### Lógica de Negocio (Backend)

El servidor continuará gestionando la lógica de validación del QR, pero el endpoint de “invitados” no debe requerir que el frontend procese una URL pública de invitación para el mensaje saliente.

### Integración de Frontend (Flutter)

Se debe modificar el controlador encargado de disparar el método:

```dart
Share.shareFiles(...)
```

(o el paquete de compartición utilizado) para que el parámetro `text` sea filtrado y no incluya la variable de la URL.

Esta limpieza debe ser agnóstica al canal; el mismo texto simplificado se enviará tanto a una aplicación de mensajería como a un cuerpo de correo electrónico.

---

## 4. Verificación de Éxito

Se considerará corregido cuando:

- Al seleccionar “Compartir QR” y elegir Telegram, el mensaje solo muestre el texto de bienvenida y la imagen.
- Al elegir Correo Electrónico, el cuerpo del mensaje no presente enlaces a `localhost`.
- El proceso se repita con éxito en cualquier otra aplicación de destino sin mostrar datos técnicos del servidor.

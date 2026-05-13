# Documento de Actualización de Requerimientos (ERS): Guestly

**Estado:** Reestructuración de Base de Datos y Simplificación de Modelos (V2.1)  
**Proyecto:** Guestly (Actualización de sistema existente)  
**Arquitectura:** MySQL / Antigravity Server / Flutter

---

## 1. Resumen de la Modificación

Esta intervención técnica tiene como objetivo simplificar el modelo de datos del invitado, eliminando campos específicos de redes sociales y flexibilizando la captura de información de contacto para agilizar el registro de asistentes.

---

## 2. Cambios en el Modelo de Datos (MySQL)

Se debe realizar una migración de la tabla `Invitados` tanto en el entorno de desarrollo local como en el servidor de producción:

### Eliminación de Campos

Se deben suprimir permanentemente las columnas:

- `whatsapp`
- `telegram`

### Ajuste de Restricciones

- El campo `correo (email)` pasa a ser Opcional (`Allow NULL`).
- El campo `telefono` pasa a ser Opcional (`Allow NULL`).

### Saneamiento de Datos (Mantenimiento)

Al ejecutar esta actualización, el sistema debe purgar automáticamente cualquier dato de prueba o registros existentes en la tabla de invitados para prevenir conflictos de integridad o errores de desajuste de columnas durante la migración de la base de datos.

---

## 3. Modificaciones en el Frontend (Flutter Mobile)

La interfaz de usuario debe reflejar los cambios estructurales del backend.

### Formulario de Registro (Nuevo Invitado)

- Eliminar los inputs de texto correspondientes a WhatsApp y Telegram.
- Actualizar las validaciones para que el usuario pueda guardar un invitado incluso si deja vacíos los campos de teléfono o correo electrónico.

### Módulo de Edición

Reflejar los mismos cambios del formulario de registro al momento de modificar un invitado existente.

---

## 4. Especificaciones del Servidor (Antigravity Server)

### Controladores CRUD

Se deben actualizar los controladores de Dart que gestionan las peticiones `POST` (crear) y `PUT` (actualizar) para que dejen de esperar o procesar los parámetros eliminados.

### Lógica de Negocio

El sistema ya no debe intentar validar el formato de Telegram o WhatsApp antes de la inserción en la base de datos.

---

## 5. Protocolo de Implementación

1. **Backup:** Realizar respaldo de la estructura de la tabla `Eventos` (que no se modifica).
2. **Limpieza:** Ejecutar un script de limpieza que elimine los registros de la tabla `Invitados`.
3. **Alter Table:** Ejecutar las sentencias `DROP COLUMN` para limpiar la estructura.
4. **Despliegue:** Actualizar simultáneamente el backend (Antigravity) y el frontend (Flutter) para mantener la paridad.

# Documento de Especificación de Requerimientos: Guestly (v1.0)

## 1. Descripción General
*  Guestly es una solución integral de gestión de acceso y control de invitados para eventos.
*  La plataforma permite la creación de eventos, registro de invitados, generación de códigos QR únicos y validación en tiempo real mediante una interfaz móvil moderna, intuitiva y de alto rendimiento.

## 2. Stack Tecnológico
*  Frontend: Flutter 3.x (Multiplataforma: Android, iOS).
*  Backend: Dart (Servidor) con Antigravity Framework integrado con Supabase.
*  Base de Datos: Supabase (PostgreSQL) para el servidor y SQLite para la base de datos local en el teléfono.
*  Comunicación: API REST con autenticación basada en JWT (JSON Web Tokens).
*  Patrón de Diseño: Clean Architecture (Capas de Data, Domain y UI).

## 3. Definición de Datos (Esquema de Base de Datos)

### 3.1 Tabla: users
*  id: UUID (PK) - Identificador único.
*  name: VARCHAR(100) - Nombre completo.
*  email: VARCHAR(100) - Email único (username).
*  password: VARCHAR(255) - Hash de la contraseña.
*  is_verified: BOOLEAN - Estado de verificación de email.
*  role: ENUM - 'admin', 'staff'.

### 3.2 Tabla: events
*  id: UUID (PK) - Identificador único.
*  user_id: UUID (FK) - Creador del evento (Admin).
*  title: VARCHAR(150) - Nombre del evento.
*  type: VARCHAR(50) - Cumpleaños, Boda, Corporativo, etc.
*  date_time: DATETIME - Fecha y hora de inicio.
*  location: TEXT - Dirección o coordenadas.
*  max_guests: INT - Límite de invitados.
*  status: BOOLEAN - Activo/Inactivo (Auto-update post fecha).

### 3.3 Tabla: guests
*  id: UUID (PK) - Identificador único.
*  event_id: UUID (FK) - Evento asociado.
*  name: VARCHAR(100) - Nombre del invitado o Familia.
*  email: VARCHAR(100) (Opcional) - Correo para envío de invitación.
*  whatsapp: VARCHAR(20) (Opcional) - Número para envío por WhatsApp.
*  telegram: VARCHAR(50) (Opcional) - Usuario o número para Telegram.
*  phone: VARCHAR(20) (Opcional) - Teléfono de contacto general.
*  total_guests: INT - Cantidad de personas que cubre la invitación (mínimo 1).
*  guests_checked_in: INT - Contador de personas que ya ingresaron (inicia en 0).
*  qr_code_token: VARCHAR(255) - UUID único para el QR.
*  check_in_time: DATETIME - Registro del primer ingreso (Nulo si no ha asistido).
*  status: ENUM - 'pending', 'checked_in'.

## 4. Especificaciones Funcionales

### 4.1 Módulo de Autenticación
*  Detección de Idioma: Al primer inicio, la app consulta el Locale del sistema. Soporte para: es, en, pt-BR.
*  Temas: Alternancia entre ThemeMode.light (default) y ThemeMode.dark.
*  Verificación: Envío de OTP o link de verificación al correo tras el registro vía Supabase Auth.

### 4.2 Gestión de Eventos (CRUD)
*  Dashboard: Tarjeta principal que muestra una cuenta regresiva (Días/Horas) para el evento más próximo.
*  Validación de Aforo: No permitir registrar más invitados (sumando total_guests) que el max_guests definido.
*  Inactividad Automática: Un proceso en el backend marcará eventos como inactivos 24 horas después de su fecha programada.

### 4.3 Gestión de Registro y Envío de Invitaciones
*  Cada invitación genera un hash único basado en event_id + guest_id + secret_key.
*  Flujo de Envío: Una vez registrado el invitado, el sistema permite elegir el canal según los datos ingresados:
   - WhatsApp/Telegram: Uso de share_plus para adjuntar el QR y un mensaje personalizado si los campos respectivos están llenos.
   - Correo Electrónico: Si se ingresó el email, el sistema permite el envío automático con el QR embebido.

## 5. Diseño de Interfaz (UI/UX)

### 5.1 Estética y Estilo
*  Estilo: Neomorfismo suave o Material Design 3 con bordes redondeados (Radius 20).
*  Colores Modo Claro: Fondo #F8F9FA, Primario #6200EE, Acento #03DAC6.
*  Colores Modo Oscuro: Fondo #121212, Primario #BB86FC, Superficie #1E1E1E.

### 5.2 Vistas Principales
*  Auth Screen: Formulario limpio con tabs para Login/Registro.
*  Home Dashboard: Superior con cuenta regresiva dinámica.
*  Cuerpo: Lista de eventos activos en formato de tarjetas con iconos según el tipo de fiesta.
*  Guest List: Buscador integrado, botón flotante para añadir, y opciones de deslizamiento (swipe).
*  Scanner View: Visor de cámara con overlay de marco cuadrado y botón de linterna.
*  Analytics: Gráfico de dona (PieChart) mostrando Confirmados vs. Ausentes.

## 6. Módulo de Escaneo y Validación
*  Feedback: Respuesta háptica (vibración) y visual.
*  Verde: "Acceso Permitido - [Nombre]".
*  Rojo: "Código Inválido" o "Ya Ingresó".
*  Naranja: "Acceso Parcial" (para cupos restantes en grupos).
*  Sincronización: Uso de SQLite local y sincronización con Supabase.

## 7. Flujo de Invitación Individual
### 7.1 Registro de Invitación Individual
El sistema asigna total_guests = 1. Se completa al menos uno de los campos opcionales de contacto (email, whatsapp o telegram) para proceder al envío del QR.

### 7.2 Validación de Ingreso Individual
*  Al confirmarse el acceso, el QR queda inhabilitado para evitar cualquier reutilización.

## 8. Flujo de Invitación Grupal (Familiar)
### 8.1 Registro de Invitación Grupal
Registro bajo nombre de familia con definición manual de total_guests. El envío se realiza a uno de los contactos registrados del líder del grupo.

### 8.2 Validación de Ingreso Grupal
El Staff ajusta con un selector cuántos integrantes ingresan. El QR permanece activo mientras haya cupos disponibles (guests_checked_in < total_guests).

## 9. Reglas de Negocio y Seguridad
*  El rol Staff tiene acceso limitado. No puede borrar invitados ni ver métricas.
*  Aplicación exclusivamente móvil, optimizada para la cámara.

## 10. Acción Requerida (Instrucciones para Antigravity)
*  Modelos: Generar modelos Dart adaptados a Supabase.
*  Controllers: Crear APIs para login, register, createEvent, addGuest y validateQR.
*  Estado: Implementar Provider o Bloc en Flutter.
*  UI: Asegurar que el escáner solo sea accesible en dispositivos con cámara.

## 11. Configuración del Entorno
*  Database Type: Supabase (PostgreSQL) y SQLite (Local).
*  Proyecto: Conexión vía URL y Anon Key al proyecto guestly_db.
*  Autenticación: Gestión centralizada vía Supabase Auth.

## 12. Definición de API REST (Nivel Producción)

### Autenticación
POST /api/auth/register
POST /api/auth/login
POST /api/auth/verify

### Eventos
GET /api/events
POST /api/events
PUT /api/events/{id}
DELETE /api/events/{id}

### Invitados
POST /api/guests
GET /api/guests/{event_id}

### Validación QR
POST /api/qr/validate

## 13. Estructura de Requests y Responses (JSON)

### Login
{
  "email": "user@test.com",
  "password": "123456"
}

{
  "token": "jwt_token",
  "user": {
    "id": "uuid",
    "role": "admin"
  }
}

### Validar QR
{
  "qr_token": "uuid",
  "scanned_by": "staff_id"
}

{
  "status": "success",
  "message": "Acceso permitido",
  "type": "partial",
  "remaining": 2
}

## 14. Lógica Backend de Validación QR
1. Buscar guest por qr_code_token
2. Si no existe → rechazar
3. Si guests_checked_in >= total_guests → acceso denegado
4. Incrementar guests_checked_in
5. Si llega al máximo → status = checked_in
6. Registrar check_in_time si es el primero

## 15. Reglas Técnicas de Seguridad
- JWT obligatorio en todas las rutas protegidas
- Expiración de token: 24 horas
- Middleware de roles:
  - admin → acceso total
  - staff → acceso restringido

## 16. Índices y Optimización de Base de Datos
CREATE UNIQUE INDEX idx_users_email ON users(email);
CREATE UNIQUE INDEX idx_qr_token ON guests(qr_code_token);
CREATE INDEX idx_events_user_id ON events(user_id);

## 17. Variables de Entorno
SUPABASE_URL=
SUPABASE_ANON_KEY=
JWT_SECRET=

## 18. Flujo Completo del Sistema
Usuario → Login → Crear Evento → Agregar Invitados → Generar QR → Enviar Invitación → Escaneo → Validación → Registro → Estadísticas


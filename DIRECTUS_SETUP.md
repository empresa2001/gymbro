# 🏋️ Configuración de Directus para GYM BRO

Esta guía te llevará paso a paso en la configuración del CMS Directus para el MVP de GYM BRO.

## 📋 Índice

1. [Acceso Inicial](#acceso-inicial)
2. [Creación de Colecciones](#creación-de-colecciones)
3. [Configuración de Roles](#configuración-de-roles)
4. [Permisos por Rol](#permisos-por-rol)
5. [Importación Automática](#importación-automática)

---

## 1. Acceso Inicial

1. Asegúrate de que Docker está corriendo:
   ```bash
   docker-compose up -d
   ```

2. Accede a Directus Admin Panel:
   - URL: http://localhost:8055
   - Email: `admin@gymbro.com`
   - Password: `Admin123!`

---

## 2. Creación de Colecciones

### 📝 Colección: `entrenadores`

**Propósito:** Información detallada de los entrenadores.

1. Ve a **Settings** → **Data Model** → **Create Collection**
2. Nombre: `entrenadores`
3. Campos:

| Campo | Tipo | Opciones |
|-------|------|----------|
| `id` | UUID | Primary Key, Auto-generado |
| `user_id` | Many-to-One Relationship | → `directus_users` |
| `certificado` | String | Opcional |
| `especialidad` | String | Opcional |
| `telefono` | String | Opcional |
| `fecha_registro` | Timestamp | Auto: Created On |

**Relación M2O con `directus_users`:**
- Field: `user_id`
- Related Collection: `directus_users`
- Display Template: `{{first_name}} {{last_name}}`

---

### 👤 Colección: `clientes`

**Propósito:** Información de los clientes/deportistas.

1. Crear colección `clientes`
2. Campos:

| Campo | Tipo | Opciones |
|-------|------|----------|
| `id` | UUID | Primary Key |
| `user_id` | Many-to-One | → `directus_users` |
| `entrenador_asignado` | Many-to-One | → `entrenadores` |
| `fecha_nacimiento` | Date | Opcional |
| `objetivo` | String | Opcional |
| `altura_cm` | Integer | Opcional |
| `fecha_registro` | Timestamp | Auto: Created On |

**Relaciones:**
- `user_id` → `directus_users`
- `entrenador_asignado` → `entrenadores`

---

### 📦 Colección: `planes`

**Propósito:** Tipos de planes de entrenamiento disponibles.

1. Crear colección `planes`
2. Campos:

| Campo | Tipo | Opciones |
|-------|------|----------|
| `id` | UUID | Primary Key |
| `nombre` | String | Requerido |
| `descripcion` | Text | Opcional |
| `duracion_dias` | Integer | Requerido (ej: 30, 90) |
| `precio` | Decimal | Opcional |
| `activo` | Boolean | Default: true |

---

### 📋 Colección: `suscripciones`

**Propósito:** Asignación de planes a clientes.

1. Crear colección `suscripciones`
2. Campos:

| Campo | Tipo | Opciones |
|-------|------|----------|
| `id` | UUID | Primary Key |
| `cliente_id` | Many-to-One | → `clientes`, Requerido |
| `plan_id` | Many-to-One | → `planes`, Requerido |
| `fecha_inicio` | Date | Requerido |
| `fecha_fin` | Date | Calculado o manual |
| `habilitado` | Boolean | Default: true |
| `creado_por` | User Created | Auto |

---

### 🏃 Colección: `sesiones_registro`

**Propósito:** Registro diario de entrenamientos.

1. Crear colección `sesiones_registro`
2. Campos:

| Campo | Tipo | Opciones |
|-------|------|----------|
| `id` | UUID | Primary Key |
| `cliente_id` | Many-to-One | → `clientes`, Requerido |
| `fecha` | Date | Requerido, Default: Today |
| `horas_entrenadas` | Decimal | Requerido (ej: 1.5) |
| `tipo_entrenamiento` | Dropdown | Opciones: Pesas, Cardio, Yoga, Mixto |
| `notas` | Text | Opcional |
| `creado_en` | Timestamp | Auto: Created On |

**Dropdown opciones para `tipo_entrenamiento`:**
```
Pesas
Cardio
Yoga
Funcional
Crossfit
Natación
Mixto
```

---

### 📊 Colección: `metricas_cliente`

**Propósito:** Seguimiento de progreso físico (opcional para MVP).

1. Crear colección `metricas_cliente`
2. Campos:

| Campo | Tipo | Opciones |
|-------|------|----------|
| `id` | UUID | Primary Key |
| `cliente_id` | Many-to-One | → `clientes`, Requerido |
| `fecha` | Date | Requerido |
| `peso_kg` | Decimal | Opcional |
| `porcentaje_grasa` | Decimal | Opcional |
| `masa_muscular_kg` | Decimal | Opcional |
| `circunferencia_cintura_cm` | Integer | Opcional |

---

## 3. Configuración de Roles

### Crear Roles Personalizados

1. Ve a **Settings** → **Access Control** → **Roles**
2. Crea los siguientes roles:

#### 🔑 Rol: `Entrenador`
- **Nombre:** Entrenador
- **Descripción:** Entrenadores que gestionan clientes
- **Admin Access:** No
- **App Access:** Yes

#### 🏃 Rol: `Cliente`
- **Nombre:** Cliente
- **Descripción:** Cliente/Deportista
- **Admin Access:** No
- **App Access:** Yes

> **Nota:** El rol de `Administrator` ya existe por defecto.

---

## 4. Permisos por Rol

### 🔑 Permisos: ADMINISTRATOR

**Acceso completo a todas las colecciones.**

---

### 🏋️ Permisos: ENTRENADOR

#### `entrenadores`
- ✅ **Read:** Own (solo su registro)
- ✅ **Update:** Own
- ❌ Create, Delete

#### `clientes`
- ✅ **Create:** Yes (puede crear clientes)
- ✅ **Read:** Custom
  - Condición: `entrenador_asignado.user_id = $CURRENT_USER`
- ✅ **Update:** Custom (solo sus clientes)
- ❌ Delete

#### `planes`
- ✅ **Read:** All
- ❌ Create, Update, Delete

#### `suscripciones`
- ✅ **Create:** Yes
- ✅ **Read:** Custom
  - Condición: `cliente_id.entrenador_asignado.user_id = $CURRENT_USER`
- ✅ **Update:** Custom (solo de sus clientes)
- ❌ Delete

#### `sesiones_registro`
- ✅ **Read:** Custom
  - Condición: `cliente_id.entrenador_asignado.user_id = $CURRENT_USER`
- ❌ Create, Update, Delete (solo los clientes crean sesiones)

#### `metricas_cliente`
- ✅ **Read:** Custom
  - Condición: `cliente_id.entrenador_asignado.user_id = $CURRENT_USER`
- ❌ Create, Update, Delete

---

### 🏃 Permisos: CLIENTE

#### `clientes`
- ✅ **Read:** Custom
  - Condición: `user_id = $CURRENT_USER`
- ✅ **Update:** Custom (solo su propio registro)
- ❌ Create, Delete

#### `planes`
- ✅ **Read:** All (para ver planes disponibles)
- ❌ Create, Update, Delete

#### `suscripciones`
- ✅ **Read:** Custom
  - Condición: `cliente_id.user_id = $CURRENT_USER`
- ❌ Create, Update, Delete (solo entrenadores asignan)

#### `sesiones_registro`
- ✅ **Create:** Yes
- ✅ **Read:** Custom
  - Condición: `cliente_id.user_id = $CURRENT_USER`
- ✅ **Update:** Custom (solo propias sesiones)
- ✅ **Delete:** Custom (solo propias sesiones)

#### `metricas_cliente`
- ✅ **Create:** Yes
- ✅ **Read:** Custom
  - Condición: `cliente_id.user_id = $CURRENT_USER`
- ✅ **Update:** Custom
- ✅ **Delete:** Custom

#### `entrenadores`
- ✅ **Read:** Custom
  - Condición: Leer solo el entrenador asignado
  - `id = $CURRENT_USER.cliente.entrenador_asignado`
- ❌ Create, Update, Delete

---

## 5. Importación Automática

### Opción A: Importar Schema JSON

Si tienes el archivo `directus-schema.json`:

1. Ve a **Settings** → **Data Model**
2. Click en el botón de menú (⋮) → **Import Schema**
3. Selecciona `directus-schema.json`
4. Confirma la importación

### Opción B: Usar Directus CLI

```bash
# Desde el directorio raíz del proyecto
docker-compose exec directus npx directus schema apply ./directus-schema.json
```

---

## ✅ Verificación

### Paso 1: Crear Usuario de Prueba

1. Ve a **User Directory** → **Create User**
2. Crea un usuario con rol `Entrenador`:
   - Email: `entrenador@test.com`
   - Password: `Test123!`
   - Rol: `Entrenador`
   - Status: Active

3. Crea un registro en la colección `entrenadores`:
   - Relacionar con el usuario creado
   - Llenar campos opcionales

4. Crea un usuario con rol `Cliente`:
   - Email: `cliente@test.com`
   - Password: `Test123!`
   - Rol: `Cliente`

5. Crea un registro en `clientes`:
   - Relacionar con el usuario cliente
   - Asignar el entrenador creado

### Paso 2: Probar Permisos

1. Cierra sesión de admin
2. Inicia sesión como entrenador
3. Verifica que puede:
   - Ver sus clientes
   - Crear nuevos clientes
   - Asignar planes

4. Inicia sesión como cliente
5. Verifica que puede:
   - Ver su información
   - Registrar sesiones
   - Ver su progreso

---

## 🚨 Solución de Problemas

### Error: "No tienes permiso para acceder"
- Verifica que los permisos están configurados correctamente
- Asegúrate de que las condiciones usan `$CURRENT_USER`

### Error: "Relación no encontrada"
- Verifica que todas las colecciones existen
- Confirma que las relaciones están bien configuradas

### Los datos no se muestran
- Verifica que el usuario tiene un registro en `entrenadores` o `clientes`
- Confirma que las relaciones están correctamente asignadas

---

## 🎯 Próximos Pasos

Una vez configurado Directus:

1. ✅ Verifica que todos los roles y permisos funcionan
2. 🚀 Inicia el frontend: `cd frontend && npm run dev`
3. 📱 Prueba la aplicación completa

---

**¿Necesitas ayuda?** Consulta la [documentación oficial de Directus](https://docs.directus.io/).

# 🛠️ Guía: Configurar Schema de Planes IA

Esta guía te ayudará a configurar las nuevas tablas en Directus para los planes generados por IA.

## 📋 Pre-requisitos

1. Docker Desktop debe estar corriendo
2. Directus debe estar accesible en http://localhost:8055
3. Debes tener las credenciales de administrador

## 🚀 Opción 1: Script Automatizado (Recomendado)

### Paso 1: Iniciar Docker y Directus

```powershell
# Navega al directorio del proyecto
cd c:\Users\Franco\Desktop\gym

# Inicia los servicios Docker
docker-compose up -d

# Espera 30 segundos para que Directus inicie completamente
# Verifica que esté corriendo
docker ps
```

### Paso 2: Ejecutar el script de setup

```powershell
# Ejecuta el script que creará las colecciones
node setup-planes-ia-schema.js
```

**Resultado esperado:**
```
🔑 Logging in to Directus...
✅ Logged in successfully

📦 Creating collection: planes_ia...
✅ Collection planes_ia created

📝 Adding fields to planes_ia...
  ✓ Field "cliente_id" created
  ✓ Field "nombre" created
  ...
✅ All fields added to planes_ia

📦 Creating collection: ejercicios_plan_ia...
✅ Collection ejercicios_plan_ia created

📝 Adding fields to ejercicios_plan_ia...
  ✓ Field "plan_ia_id" created
  ...
✅ All fields added to ejercicios_plan_ia

📝 Adding field tipo_plan_preferido to clientes...
✅ Field tipo_plan_preferido added to clientes

🎉 Schema setup completed successfully!
```

---

## 🗄️ Opción 2: SQL Manual (Alternativa)

Si prefieres hacerlo con SQL directamente:

```powershell
# Conecta a PostgreSQL
docker exec -it gymbro_postgres psql -U directus -d directus

# Dentro de psql, ejecuta:
\i /path/to/migrations/create_planes_ia_schema.sql
```

---

## ⚙️ Configurar Permisos (IMPORTANTE)

Después de crear las colecciones, debes configurar los permisos para el rol **Cliente**:

### 1. Accede a Directus Admin
- URL: http://localhost:8055
- Login: admin@gymbro.com / Admin123!

### 2. Navega a Settings → Roles → Cliente

### 3. Configura permisos para `planes_ia`:

| Acción | Permiso | Filtro |
|--------|---------|--------|
| **CREATE** | ✅ Sí | `cliente_id` = `$CURRENT_USER.clientes[0].id` |
| **READ** | ✅ Sí | `cliente_id` = `$CURRENT_USER.clientes[0].id` |
| **UPDATE** | ✅ Sí | `cliente_id` = `$CURRENT_USER.clientes[0].id` |
| **DELETE** | ❌ No | N/A |

**Fields permissions:**
- ✅ All fields: Read
- ✅ Todos menos `id`, `date_created`, `date_updated`, `prompt_usado`: Create/Update

### 4. Configura permisos para `ejercicios_plan_ia`:

| Acción | Permiso | Filtro |
|--------|---------|--------|
| **CREATE** | ❌ No | N/A |
| **READ** | ✅ Sí | `plan_ia_id.cliente_id` = `$CURRENT_USER.clientes[0].id` |
| **UPDATE** | ❌ No | N/A |
| **DELETE** | ❌ No | N/A |

### 5. Actualiza permisos en `clientes`:

Agrega permiso para actualizar el campo `tipo_plan_preferido`:
- ✅ UPDATE: `tipo_plan_preferido` (permitido)

---

## ✅ Verificación

### Verificar en Directus Admin:

1. Ve a **Content** en el menú lateral
2. Deberías ver las nuevas colecciones:
   - `planes_ia` (con ícono de cerebro 🧠)
   - `ejercicios_plan_ia` (con ícono de fitness 🏋️)

3. Click en `planes_ia` → Deberías ver todos los campos configurados

### Verificar con código:

Ejecuta este script de prueba:

```javascript
// test-planes-ia.js
import { createDirectus, rest, authentication, readItems } from '@directus/sdk';

const client = createDirectus('http://localhost:8055')
    .with(authentication())
    .with(rest());

async function test() {
    await client.login('admin@gymbro.com', 'Admin123!');
    
    const collections = await client.request(readItems('directus_collections'));
    const planesIA = collections.find(c => c.collection === 'planes_ia');
    
    console.log('✅ planes_ia exists:', !!planesIA);
}

test();
```

---

## 🐛 Troubleshooting

### Error: "Collection already exists"
- Las colecciones ya fueron creadas anteriormente
- Puedes ignorar este error o eliminar las colecciones desde Directus Admin

### Error: "Cannot connect to Directus"
- Verifica que Docker esté corriendo: `docker ps`
- Verifica que Directus esté accesible: abrir http://localhost:8055 en navegador

### Error: "Unauthorized"
- Verifica las credenciales en el archivo `.env`
- Por defecto: admin@gymbro.com / Admin123!

---

## 📝 Próximos Pasos

Una vez completado el setup:

1. ✅ Las tablas están creadas
2. ⏭️ Continuar con la implementación de los servicios de API
3. ⏭️ Crear componentes de UI para generar planes


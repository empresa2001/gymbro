# 🚀 Deployment a Producción - Planes IA

## 📋 Checklist de Deployment

### 1. Base de Datos (Render PostgreSQL)

- [ ] Conectarse a la base de datos de Render
- [ ] Ejecutar el script SQL de migración
- [ ] Verificar que las tablas se crearon correctamente

### 2. Directus (Render)

- [ ] Acceder a Directus en producción
- [ ] Configurar permisos para rol Cliente (ver guía)
- [ ] Verificar que las colecciones aparecen correctamente

### 3. Frontend (Vercel)

- [ ] Agregar variable de entorno `VITE_GEMINI_API_KEY` en Vercel
- [ ] Push de cambios a Git
- [ ] Vercel desplegará automáticamente
- [ ] Verificar que el build fue exitoso

---

## 🗄️ Paso 1: Ejecutar SQL en Render

### Opción A: Desde Render Dashboard (Recomendado)

1. Ve a tu dashboard de Render: https://dashboard.render.com/
2. Click en tu base de datos PostgreSQL
3. Ve a la pestaña **"Shell"** o **"Connect"**
4. Copia la **External Database URL** (PostgreSQL Connection String)

Debería verse así:
```
postgres://usuario:password@host.render.com/database_name
```

5. Usa un cliente PostgreSQL (pgAdmin, DBeaver, o psql) para conectarte

6. Ejecuta el siguiente SQL:

```sql
-- Copiar contenido completo de: migrations/create_planes_ia_schema.sql
```

### Opción B: Desde Terminal con psql

Si tienes `psql` instalado:

```bash
# Reemplaza con tu connection string de Render
psql "postgres://usuario:password@host.render.com/database_name" -f migrations/create_planes_ia_schema.sql
```

### Opción C: SQL directo en Render Shell

1. En Render Dashboard → Base de Datos → Shell
2. Se abrirá una consola `psql` conectada
3. Copia y pega el contenido de `migrations/create_planes_ia_schema.sql`
4. Presiona Enter

### Verificar que funcionó:

En la consola SQL, ejecuta:
```sql
-- Verificar tablas
\dt planes_ia
\dt ejercicios_plan_ia

-- Verificar campo en clientes
\d clientes
```

Deberías ver las nuevas tablas listadas.

---

## ⚙️ Paso 2: Configurar Directus en Producción

1. Accede a tu Directus de producción (la URL de Render)
2. Inicia sesión como administrador
3. Sigue **exactamente** los mismos pasos de la guía:
   - `CONFIGURAR_PERMISOS_PLANES_IA.md`

**IMPORTANTE**: Los permisos son **críticos** para que funcione en producción.

---

## 🌐 Paso 3: Deployment en Vercel

### 3.1 Agregar Variable de Entorno en Vercel

1. Ve a tu proyecto en Vercel: https://vercel.com/dashboard
2. Click en tu proyecto → **Settings** → **Environment Variables**
3. Agrega:
   - **Name**: `VITE_GEMINI_API_KEY`
   - **Value**: `AIzaSyCtzgBV3njeJ1CcsnfcljmmR9NnBlk9ybo` (tu API key)
   - **Environments**: Selecciona **Production, Preview, Development**
4. Click **Save**

### 3.2 Push a Git

Vercel detectará automáticamente los cambios y desplegará.

**Archivos modificados/creados:**
```
frontend/src/services/AIService.js
frontend/src/api/directus.js
frontend/src/components/PlanTypeSelector.jsx
frontend/src/pages/cliente/AIPlanGenerator.jsx
frontend/src/pages/cliente/ClienteDashboard.jsx
frontend/src/pages/cliente/MyPlanPage.jsx
frontend/src/App.jsx
frontend/.env.example
migrations/create_planes_ia_schema.sql
```

**Archivos que NO debes subir:**
```
frontend/.env (está en .gitignore)
setup-planes-ia-schema.js (opcional, solo para desarrollo)
```

### 3.3 Comandos Git

```bash
cd c:\Users\Franco\Desktop\gym

# Ver cambios
git status

# Agregar todos los cambios
git add .

# Commit
git commit -m "feat: Implementar planes de entrenamiento con IA

- Agregar integración con Google Gemini 2.0 Flash
- Crear colecciones planes_ia y ejercicios_plan_ia
- Implementar generador de planes multi-step
- Agregar selector de tipo de plan en dashboard
- Soportar visualización dual de planes (profesor + IA)
- Agregar campo tipo_plan_preferido a clientes"

# Push (reemplaza 'main' con tu branch si es diferente)
git push origin main
```

---

## ✅ Verificación Post-Deployment

### En Producción (Vercel):

1. Ve a tu app en producción
2. Inicia sesión como Cliente
3. Dashboard debe mostrar "Elegir Tipo de Plan"
4. Click → Debe abrir selector
5. Elige "Plan con IA"
6. Completa formulario de 6 pasos
7. Verifica que el plan se genera

### Verificar en Directus de Producción:

1. Accede como admin
2. Ve a **Content** → `planes_ia`
3. Deberías ver el plan recién creado
4. Check `ejercicios_plan_ia` → deberían estar los ejercicios vinculados

---

## 🐛 Troubleshooting

### Error: "Collection not found"
- ✅ Verifica que las tablas existen en la BD de Render
- ✅ Refresca el cache de Directus (restart del servicio)

### Error: "Permission denied"
- ✅ Configura permisos en Directus de producción
- ✅ Sigue `CONFIGURAR_PERMISOS_PLANES_IA.md` exactamente

### Error: "VITE_GEMINI_API_KEY is undefined"
- ✅ Verifica variable en Vercel Settings
- ✅ Re-deploy en Vercel (puede requerir rebuild)

### Build failed en Vercel
- ✅ Check los logs de build
- ✅ Verifica que no haya errores de TypeScript/ESLint
- ✅ Asegúrate que todas las importaciones son correctas

---

## 📊 Resumen de Acciones

1. **Tú haces**:
   - [ ] Ejecutar SQL en base de datos de Render
   - [ ] Configurar permisos en Directus de producción
   - [ ] Agregar `VITE_GEMINI_API_KEY` en Vercel
   - [ ] Push de código a Git

2. **Vercel hace automáticamente**:
   - [ ] Detecta push
   - [ ] Build del frontend
   - [ ] Deploy a producción
   - [ ] Tu app actualizada estará live

3. **Verificación final**:
   - [ ] Probar generación de plan en producción
   - [ ] Verificar que todo funciona

---

**¿Necesitas ayuda con algún paso específico?**

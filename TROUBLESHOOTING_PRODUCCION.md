# 🐛 Troubleshooting: Error en Producción

## Error Reportado
```json
{
    "errors": [
        {
            "message": "An unexpected error occurred.",
            "extensions": {
                "code": "INTERNAL_SERVER_ERROR"
            }
        }
    ]
}
```

## 🔍 Causas Comunes

### 1. **Permisos No Configurados** (90% de los casos)

Las colecciones `planes_ia` y `ejercicios_plan_ia` fueron creadas, pero el rol "Cliente" no tiene permisos para acceder a ellas.

**Solución Inmediata:**

1. Ve a: https://gym-bro-directus.onrender.com
2. Login: `admin@gymbro.com` / `GymBro2024!`
3. **Settings** → **Access Control** → Rol **"Cliente"**

**Configura permisos para `planes_ia`:**

| Acción | Activado | Filter |
|--------|----------|--------|
| CREATE | ✅ | `{"cliente_id": {"_eq": "$CURRENT_USER.clientes[0].id"}}` |
| READ | ✅ | `{"cliente_id": {"_eq": "$CURRENT_USER.clientes[0].id"}}` |
| UPDATE | ✅ | `{"cliente_id": {"_eq": "$CURRENT_USER.clientes[0].id"}}` |
| DELETE | ❌ | - |

**Fields Permissions (CREATE/UPDATE):**
- ✅ Todos EXCEPTO: `id`, `date_created`, `date_updated`, `prompt_usado`

**Configura permisos para `ejercicios_plan_ia`:**

| Acción | Activado | Filter |
|--------|----------|--------|
| CREATE | ❌ | - |
| READ | ✅ | `{"plan_ia_id": {"cliente_id": {"_eq": "$CURRENT_USER.clientes[0].id"}}}` |
| UPDATE | ❌ | - |
| DELETE | ❌ | - |

**Fields Permissions (READ):**
- ✅ Todos los campos

### 2. **Error en Frontend**

Si el error ocurre al cargar el dashboard o cualquier página:

**Verificar:**
- ¿Las colecciones aparecen en Directus Admin? (Settings → Data Model)
- ¿Los campos se muestran correctamente?
- ¿Hay errores en la consola del navegador? (F12)

### 3. **API Key de Gemini Inválida**

Si el error ocurre al **generar un plan IA**:

**Verificar en Vercel:**
1. Proyecto → Settings → Environment Variables
2. Confirmar que existe: `VITE_GEMINI_API_KEY`
3. Valor: `AIzaSyCtzgBV3njeJ1CcsnfcljmmR9NnBlk9ybo`

**Después de agregar/modificar variables:**
- Hacer re-deploy del proyecto en Vercel

### 4. **Relaciones Rotas**

Si las foreign keys no se crearon correctamente:

**Verificar en Directus Admin:**
1. Settings → Data Model
2. Click en `planes_ia`
3. Verificar que `cliente_id` muestra relación M2O a `clientes`
4. Click en `ejercicios_plan_ia`
5. Verificar que `plan_ia_id` → `planes_ia` y `ejercicio_id` → `ejercicios`

## 📊 Diagnóstico Paso a Paso

### Paso 1: Verificar Colecciones
```
1. Accede a Directus producción
2. Settings → Data Model
3. Busca: planes_ia, ejercicios_plan_ia
4. ¿Aparecen? → SÍ: continúa | NO: re-ejecutar setup script
```

### Paso 2: Verificar Permisos
```
1. Settings → Access Control → Cliente
2. Scroll hasta encontrar planes_ia
3. ¿Tiene algún permiso activado? → NO: configurar permisos
```

### Paso 3: Probar en Admin
```
1. Como admin, ve a Content → planes_ia
2. ¿Puedes ver la colección? → SÍ: problema de permisos
3. Intenta crear un registro de prueba
```

### Paso 4: Verificar Logs
```
1. Ve a Render Dashboard
2. Tu servicio Directus → Logs
3. Busca errores recientes
4. Copia el mensaje completo del error
```

## 🚀 Solución Rápida (5 min)

```bash
# 1. Configurar permisos (manual en Directus Admin)
#    - Ver sección "Permisos No Configurados" arriba

# 2. Si usaste Git para deploy en Vercel:
#    - Verifica que .env esté en .gitignore
#    - Configura variables en Vercel dashboard

# 3. Re-deploy en Vercel (si es necesario)
#    - Vercel dashboard → Deployments → Re-deploy
```

## 📝 Información Necesaria para Diagnóstico

Si el problema persiste, necesito:

1. **¿Dónde ocurrió el error?**
   - [ ] Al cargar el dashboard
   - [ ] Al abrir selector de planes
   - [ ] Al generar plan IA
   - [ ] En otra página

2. **¿Qué muestra la consola del navegador?** (F12 → Console)

3. **¿Logs de Render?** (Render Dashboard → Logs)

4. **¿Network tab?** (F12 → Network → el request que falló)

## ✅ Checklist Post-Fix

- [ ] Permisos configurados en Directus
- [ ] Variables de entorno en Vercel
- [ ] Re-deploy realizado
- [ ] Probar generación de plan en producción
- [ ] Verificar que se guarda en BD
- [ ] Verificar que se muestra en dashboard

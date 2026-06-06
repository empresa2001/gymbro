# 🔑 Cómo Obtener y Configurar tu API Key de Google Gemini

## Paso 1: Obtener la API Key

1. Ve a **Google AI Studio**: https://aistudio.google.com/app/apikey

2. Inicia sesión con tu cuenta de Google

3. Haz clic en **"Get API Key"** o **"Create API Key"**

4. Selecciona un proyecto existente o crea uno nuevo

5. Copia la API key que se genera (empieza con `AIza...`)

## Paso 2: Configurar en el Proyecto

### Frontend (IMPORTANTE)

Abre el archivo `frontend/.env` y agrega:

```env
VITE_GEMINI_API_KEY=TU_API_KEY_AQUÍ
```

**Ejemplo:**
```env
VITE_GEMINI_API_KEY=AIzaSyD7LrBO3bcDmeSFEXXLWCo0b_hfE-AmU3E
```

### ⚠️ Importante:

1. **Reinicia el servidor de desarrollo** después de agregar la key:
   ```bash
   # Detén el servidor (Ctrl+C en la terminal)
   # Luego vuelve a iniciarlo:
   npm run dev
   ```

2. **NO subas el archivo `.env` a Git** (ya está en .gitignore)

3. **Para producción** (Vercel/Netlify):
   - Agrega la variable de entorno en el panel de configuración
   - Nombre: `VITE_GEMINI_API_KEY`
   - Valor: tu API key

## Verificar que Funciona

1. Abre la consola del navegador (F12)
2. Ve a `/cliente/generar-plan-ia`
3. Completa el formulario
4. Si hay error de API key, verás el mensaje en consola

## Troubleshooting

**Error: "API key not valid"**
- ✅ Verifica que copiaste la key completa (sin espacios)
- ✅ Verifica que la variable empiece con `VITE_`
- ✅ Reinicia el servidor `npm run dev`

**Error: "VITE_GEMINI_API_KEY is undefined"**
- ✅ El archivo está en `frontend/.env`, no en la raíz
- ✅ Reinicia el servidor

## Límites Gratuitos

Google Gemini tiene un tier gratuito generoso:
- **60 requests por minuto**
- **1,500 requests por día**
- Suficiente para desarrollo y uso moderado

## Seguridad

⚠️ **NUNCA** expongas tu API key en:
- Código fuente committed a Git
- Consola del navegador (console.log)
- URLs públicas
- Screenshots compartidos

La API key debe estar SOLO en variables de entorno.

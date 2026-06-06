# Guía de Importación a Directus

## 📋 Pre-requisitos

1. **Directus configurado** en Render o local
2. **Colección "ejercicios"** creada en Directus con los siguientes campos:
   - `nombre` (string)
   - `descripcion` (text)
   - `categoria` (string)
   - `nivel_dificultad` (string)
   - `imagen_url` (string)
   - `imagen_url_2` (string)
3. **Credenciales de Directus** en archivo `.env`

## 🚀 Proceso de Importación

### Paso 1: Configurar credenciales en .env

Abre tu archivo `.env` y agrega (o actualiza):

```env
# Directus
DIRECTUS_URL=https://tu-directus.onrender.com
DIRECTUS_EMAIL=admin@ejemplo.com
DIRECTUS_PASSWORD=tu_password_seguro
```

### Paso 2: Preparar mapeo de ejercicios

Este paso descarga la base de datos completa de free-exercise-db y crea un mapeo con nuestros ejercicios traducidos para obtener los IDs correctos de las imágenes:

```bash
node preparar-mapeo.js
```

Esto generará 3 archivos:
- `free-exercise-db-completo.json` - Base de datos completa de la API
- `mapeo-ids-ejercicios.json` - IDs y nombres en inglés
- `mapeo-completo-ejercicios.json` - Mapeo completo con traducciones

### Paso 3: Importar a Directus

```bash
node importar-ejercicios-directus.js
```

El script:
1. Se autentica con Directus
2. Carga los 872 ejercicios traducidos
3. Por cada ejercicio:
   - Obtiene el ID del ejercicio original
   - Genera las URLs de las 2 imágenes de GitHub
   - Crea el registro en Directus
4. Importa en batches de 50 ejercicios con delay de 2s entre batches

## 📊 Estructura de las URLs de Imágenes

Las imágenes se obtienen de GitHub:

```
https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/{ID_EJERCICIO}/0.jpg
https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/{ID_EJERCICIO}/1.jpg
```

Ejemplo:
```
https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Alternate_Incline_Dumbbell_Curl/0.jpg
https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Alternate_Incline_Dumbbell_Curl/1.jpg
```

## ⚠️ Notas Importantes

1. **Tiempo estimado**: ~2-5 minutos para 872 ejercicios
2. **Conexión**: Asegúrate de tener buena conexión a internet
3. **Permisos**: Tu usuario de Directus debe tener permisos de escritura en la colección
4. **Duplicados**: El script no verifica duplicados, asegúrate de tener la colección vacía

## 🔧 Solución de Problemas

### Error de autenticación
```
❌ Error: Unauthorized
```
**Solución**: Verifica DIRECTUS_EMAIL y DIRECTUS_PASSWORD en .env

### Error de colección no encontrada
```
❌ Error accediendo a la colección "ejercicios"
```
**Solución**: Crea la colección "ejercicios" en Directus con los campos mencionados arriba

### Errores durante importación
Los errores individuales se mostrarán en consola pero el script continuará con los demás ejercicios.

## 📈 Progreso

Durante la importación verás:
```
🔄 Importando Batch 1/18 (50 ejercicios)...
   Importados: 10/50
   Importados: 20/50
   ...
   ✅ Batch 1 completado: 50 importados, 0 errores
```

## ✅ Verificación

Después de la importación:
1. Accede a Directus
2. Ve a la colección "ejercicios"
3. Verifica que haya ~872 registros
4. Revisa que las URLs de imágenes funcionen

## 💡 Tips

- **Prueba primero con un subset**: Modifica `BATCH_SIZE` a 10 y comenta el loop de batches para probar con solo 10 ejercicios
- **Monitorea Directus**: Ten abierta la interfaz de Directus para ver los ejercicios aparecer en tiempo real
- **Logs**: El script muestra progreso detallado, úsalo para debugging

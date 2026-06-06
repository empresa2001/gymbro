# Guía de Traducción de Ejercicios con Google Translate API

## 📋 Pre-requisitos

### 1. Obtener API Key de Google Cloud

1. **Crear cuenta de Google Cloud** (si no tienes)
   - Ve a: https://console.cloud.google.com/
   - Google ofrece $300 USD de crédito gratis para nuevas cuentas

2. **Crear un proyecto**
   - En la consola, crea un nuevo proyecto o selecciona uno existente

3. **Habilitar Cloud Translation API**
   - Ve a: https://console.cloud.google.com/apis/library/translate.googleapis.com
   - Haz clic en "Habilitar"

4. **Crear API Key**
   - Ve a: https://console.cloud.google.com/apis/credentials
   - Clic en "Crear credenciales" → "Clave de API"
   - Copia la API Key generada


5. **Configurar en tu proyecto**
   - Abre el archivo `.env` en `c:\Users\Franco\Desktop\gym\`
   - Agrega la línea:
     ```
     GOOGLE_TRANSLATE_API_KEY=tu_api_key_aquí
     ```

6. **Verificar configuración**
   ```bash
   node verificar-config.js
   ```
   Este comando verificará que tu API key funcione correctamente y hará una prueba de traducción.

## 🚀 Proceso de Traducción (4 Batches)


### Paso 1: Traducir Batch 1 (~218 ejercicios)
```bash
node traducir-batch.js 1
```

### Paso 2: Traducir Batch 2 (~218 ejercicios)
```bash
node traducir-batch.js 2
```

### Paso 3: Traducir Batch 3 (~218 ejercicios)
```bash
node traducir-batch.js 3
```

### Paso 4: Traducir Batch 4 (~219 ejercicios)
```bash
node traducir-batch.js 4
```

### Paso 5: Combinar todos los batches
```bash
node combinar-batches.js
```

Esto generará el archivo `ejercicios-completo-es.json` con los 873 ejercicios traducidos.

## 💰 Estimación de Costos

- **Total de caracteres**: ~500,000 (aprox)
- **Costo de Google Translate**: $20 USD por 1M de caracteres
- **Costo estimado total**: ~$0.50 USD
- **Costo por batch**: ~$0.125 USD

## 📁 Archivos Generados

Después de ejecutar los 4 batches:
- `ejercicios-batch-1-es.json` (~218 ejercicios)
- `ejercicios-batch-2-es.json` (~218 ejercicios)
- `ejercicios-batch-3-es.json` (~218 ejercicios)
- `ejercicios-batch-4-es.json` (~219 ejercicios)

Después de combinar:
- `ejercicios-completo-es.json` (873 ejercicios)

## ⚠️ Notas Importantes

1. **Rate Limits**: El script tiene un delay de 1 segundo entre requests para evitar exceder límites
2. **Reintentos**: Si un batch falla, simplemente vuelve a ejecutar ese comando
3. **Backup**: Los batches individuales se mantienen como backup
4. **Validación**: Revisa algunos ejemplos después de cada batch

## 🔄 En caso de error

Si un batch falla a la mitad:
1. El script guardará lo que pudo traducir
2. Puedes volver a ejecutar el mismo comando
3. O puedes revisar el error y ajustar

## ✅ Verificación

Después de cada batch, el script muestra:
- Cantidad de ejercicios traducidos
- 3 ejemplos de traducciones
- Tiempo de ejecución
- Archivo generado

## 🎯 Próximos Pasos

Una vez que tengas `ejercicios-completo-es.json`:
1. Crear script de importación a Directus
2. Agregar URLs de imágenes de GitHub
3. Cargar a tu base de datos en Render

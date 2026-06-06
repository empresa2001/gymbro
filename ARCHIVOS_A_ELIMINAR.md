# 🗑️ Archivos Propuestos para Eliminación

## Scripts JS de Importación/Procesamiento (26 archivos)

Estos scripts se usaron para poblar la base de datos de ejercicios y ya no son necesarios:

### Scripts Numerados (11 archivos):
- `1-agregar-campos-url.js`
- `2-poblar-urls.js`
- `3-corregir-urls-imagenes.js`
- `4-limpiar-descripciones-html.js`
- `5-poblar-urls-segunda-tanda.js`
- `6-eliminar-duplicados.js`
- `7-encontrar-duplicados-reales.js`
- `8-buscar-ejercicios-nuevos.js`
- `9-importar-500-ejercicios.js`
- `10-generar-json-500-ejercicios.js`
- `11-importar-desde-json.js`

### Scripts de Importación (8 archivos):
- `import-ejercicios-200.js`
- `import-ejercicios-ahora.js`
- `import-ejercicios-con-imagenes.js`
- `import-ejercicios-simple.js`
- `import-top50-exercises.js`
- `importar-ejercicios-completos.js`
- `importar-ejercicios-directus.js`
- `import-schema.js`

### Scripts de Procesamiento (12 archivos):
- `actualizar-imagenes.js`
- `agregar-imagenes-ejercicios.js`
- `agregar-urls-imagenes.js`
- `check-permissions.js`
- `combinar-batches.js`
- `crear-json-200-ejercicios.js`
- `generar-500-ejercicios-espanol.js`
- `mejorar-mapeo.js`
- `preparar-mapeo.js`
- `segunda-tanda-50-ejercicios.js`
- `top-50-exercises.js`
- `migrate-exercises.js`
- `migrate-rename-video-to-image2.js`

### Scripts de Traducción/Verificación (6 archivos):
- `traducir-batch.js`
- `traducir-y-actualizar-ejercicios.js`
- `listar-ejercicios-sin-traducir.js`
- `verificar-config.js`
- `verificar-urls-github.js`
- `get-role-ids.js`
- `create-roles.js`

---

## Archivos JSON de Datos (13 archivos)

Estos JSON contienen ejercicios que ya están importados en Directus:

### Archivos de Ejercicios:
- `ejercicios-200-final.json` (119 KB)
- `ejercicios-500-español.json` (22 KB)
- `ejercicios-batch-1-es.json` (55 KB)
- `ejercicios-batch-2-es.json` (57 KB)
- `ejercicios-batch-3-es.json` (57 KB)
- `ejercicios-batch-4-es.json` (57 KB)
- `ejercicios-completo-es.json` (226 KB)
- `ejercicios-completo.json` (237 KB)
- `ejercicios-nuevos-seleccionados.json` (1.4 KB)
- `ejercicios-segunda-tanda.json` (15 KB)
- `ejercicios-top50.json` (11 KB)
- `free-exercise-db-completo.json` (1 MB)

### Archivos de Mapeo:
- `mapeo-completo-ejercicios.json` (326 KB)
- `mapeo-ids-ejercicios.json` (151 KB)
- `mapeo-mejorado-ejercicios.json` (286 KB)

---

## Archivos de Configuración Redundantes (2 archivos)

Ya tienes documentación simplificada en otros archivos MD:

- `directus-schema.json` - Ya tienes `directus-schema-export.yaml`
- `create-collections.mjs` - Ya está configurado Directus

---

## 📊 Resumen

| Categoría | Cantidad | Espacio Aproximado |
|-----------|----------|-------------------|
| Scripts JS | 37 archivos | ~200 KB |
| Archivos JSON | 16 archivos | ~2.5 MB |
| **TOTAL** | **53 archivos** | **~2.7 MB** |

---

## ⚠️ Archivos que SÍ MANTENER

### Esenciales del Proyecto:
- ✅ `package.json` y `package-lock.json`
- ✅ `.env` y `.env.example`
- ✅ `.gitignore`
- ✅ `docker-compose.yml`
- ✅ `README.md`
- ✅ `directus-schema-export.yaml` (schema actual)
- ✅ Todos los archivos `.md` de documentación
- ✅ `fix-suscripciones-db.sql` y `recreate_tables.sql`
- ✅ Carpeta `frontend/` completa
- ✅ Carpeta `node_modules/` (se regenera con npm install)
- ✅ Carpeta `temp_images/` (por si acaso contiene imágenes importantes)

---

## 🚀 Siguiente Paso

¿Quieres que proceda a eliminar los **53 archivos** listados arriba?

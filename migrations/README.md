# Migraciones - Multi-Tenant Architecture

Este directorio contiene los scripts de migración para convertir la aplicación de single-tenant a multi-tenant (múltiples gimnasios).

## 📋 Orden de Ejecución

Las migraciones deben ejecutarse en el siguiente orden:

1. `001_create_gimnasios_table.sql` - Crea la tabla gimnasios
2. `002_add_gimnasio_to_entrenadores.sql` - Agrega gimnasio_id a entrenadores
3. `003_migrate_existing_data.sql` - Migra los datos existentes
4. `004_make_gimnasio_required.sql` - Hace gimnasio_id obligatorio

## 🚀 Cómo Ejecutar las Migraciones

### Opción 1: Desde psql (PostgreSQL CLI)

```bash
# Conectarse a la base de datos
psql -h <host> -U <usuario> -d <database>

# Ejecutar cada migración
\i migrations/001_create_gimnasios_table.sql
\i migrations/002_add_gimnasio_to_entrenadores.sql
\i migrations/003_migrate_existing_data.sql
\i migrations/004_make_gimnasio_required.sql
```

### Opción 2: Desde pgAdmin o DBeaver

1. Abrir cada archivo `.sql` en orden
2. Ejecutar el contenido completo
3. Verificar los mensajes de salida

### Opción 3: Desde Directus SQL Query (NO RECOMENDADO)

Directus no suele permitir ejecutar DDL statements directamente. Usar psql o pgAdmin.

### Opción 4: Script automatizado (Unix/Linux/Mac)

```bash
#!/bin/bash
# run_migrations.sh

DB_HOST="localhost"
DB_USER="directus"
DB_NAME="gym_db"
DB_PASSWORD="tu_password"

export PGPASSWORD=$DB_PASSWORD

echo "Ejecutando migraciones..."

psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/001_create_gimnasios_table.sql
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/002_add_gimnasio_to_entrenadores.sql
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/003_migrate_existing_data.sql
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/004_make_gimnasio_required.sql

echo "Migraciones completadas"
```

### Opción 5: Script automatizado (Windows PowerShell)

```powershell
# run_migrations.ps1

$env:PGPASSWORD = "tu_password"
$DB_HOST = "localhost"
$DB_USER = "directus"
$DB_NAME = "gym_db"

Write-Host "Ejecutando migraciones..."

psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/001_create_gimnasios_table.sql
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/002_add_gimnasio_to_entrenadores.sql
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/003_migrate_existing_data.sql
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f migrations/004_make_gimnasio_required.sql

Write-Host "Migraciones completadas"
```

## ⚠️ Antes de Ejecutar

### 1. Hacer Backup de la Base de Datos

```bash
pg_dump -h <host> -U <usuario> -d <database> -F c -f backup_pre_migration.dump
```

### 2. Verificar el Role ID de Administrator

En el archivo `003_migrate_existing_data.sql`, verifica que el UUID del rol Administrator sea correcto:

```sql
WHERE role = '131bc633-08d9-4754-8527-92d20ad0ed31' -- Verificar este ID
```

Para obtener los role IDs de tu instalación:

```sql
SELECT id, name FROM directus_roles;
```

### 3. Verificar que tienes usuario Administrador

```sql
SELECT id, email, role FROM directus_users WHERE role = '<administrator_role_id>';
```

## 🔍 Verificación Post-Migración

Ejecutar estas queries para verificar que todo funcionó correctamente:

```sql
-- 1. Verificar tabla gimnasios
SELECT * FROM gimnasios;

-- 2. Verificar que todos los entrenadores tienen gimnasio
SELECT COUNT(*) FROM entrenadores WHERE gimnasio_id IS NULL;
-- Debe retornar 0

-- 3. Ver resumen por gimnasio
SELECT 
    g.nombre AS gimnasio,
    COUNT(DISTINCT e.id) AS total_entrenadores,
    COUNT(DISTINCT c.id) AS total_clientes
FROM gimnasios g
LEFT JOIN entrenadores e ON e.gimnasio_id = g.id
LEFT JOIN clientes c ON c.entrenador_asignado = e.id
GROUP BY g.id, g.nombre;

-- 4. Verificar constraints
SELECT 
    con.conname AS constraint_name,
    con.contype AS constraint_type
FROM pg_constraint con
JOIN pg_class rel ON rel.oid = con.conrelid
WHERE rel.relname = 'gimnasios';
```

## 🔄 Rollback (Revertir Cambios)

Si necesitas revertir las migraciones, ejecuta los rollback en **orden inverso**:

```bash
psql -h <host> -U <usuario> -d <database> -f migrations/rollback_004.sql
psql -h <host> -U <usuario> -d <database> -f migrations/rollback_003.sql
psql -h <host> -U <usuario> -d <database> -f migrations/rollback_002.sql
psql -h <host> -U <usuario> -d <database> -f migrations/rollback_001.sql
```

⚠️ **ADVERTENCIA**: Los rollbacks eliminarán TODOS los datos de gimnasios. Hacer backup antes.

## 📊 Estructura de Datos Resultante

Después de las migraciones:

```
gimnasios
├── id (PK)
├── nombre
├── email (unique)
├── user_id (FK → directus_users, unique)
└── ...

entrenadores
├── id (PK)
├── user_id (FK → directus_users)
├── gimnasio_id (FK → gimnasios, NOT NULL) ← NUEVO
└── ...

clientes
├── id (PK)
├── user_id (FK → directus_users)
├── entrenador_asignado (FK → entrenadores)
└── ... (sin cambios directos)
```

## 🎯 Próximos Pasos

Después de ejecutar las migraciones:

1. **Configurar Directus**:
   - Agregar la collection `gimnasios` manualmente o importar schema
   - Configurar las relaciones en la UI de Directus
   - Crear el rol "Gimnasio"

2. **Configurar Permisos**:
   - Super Admin: acceso a TODO
   - Gimnasio: filtrado por `user_id = $CURRENT_USER.id`
   - Entrenador: filtrado por `gimnasio_id = $CURRENT_USER.entrenador.gimnasio_id`

3. **Actualizar Frontend**:
   - Modificar `directus.js` para agregar `gimnasioService`
   - Actualizar `AuthContext` para detectar rol Gimnasio
   - Crear componentes de UI para gestión de gimnasios

## 📝 Notas Importantes

- Las migraciones son **idempotentes** - pueden ejecutarse múltiples veces sin error
- Usar `IF EXISTS` / `IF NOT EXISTS` para permitir re-ejecución
- Los scripts incluyen verificaciones de seguridad
- Los comentarios SQL documentan cada columna
- Los índices mejoran el performance de queries con filtros

## 🆘 Troubleshooting

### Error: "relation gimnasios already exists"

La tabla ya fue creada. Puedes continuar con las siguientes migraciones.

### Error: "column gimnasio_id already exists"

La columna ya fue agregada. Continuar con las siguientes migraciones.

### Error: "No se encontró usuario administrador"

Asegúrate de tener al menos un usuario con rol de Administrator o ajusta el UUID del rol en `003_migrate_existing_data.sql`.

### Error: "Aún hay entrenadores sin gimnasio asignado"

La migración 003 falló o no se ejecutó. Volver a ejecutar `003_migrate_existing_data.sql`.

## 📞 Soporte

Si encuentras problemas durante la migración, revisa:
1. Los logs de PostgreSQL
2. Los mensajes de RAISE NOTICE en las migraciones
3. Las verificaciones post-migración
4. El backup está disponible para restaurar

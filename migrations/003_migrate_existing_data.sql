-- ============================================
-- Migration 003: Migrate existing data
-- ============================================
-- Description: Creates default gimnasio and assigns existing entrenadores
-- Author: System
-- Date: 2025-12-26

DO $$
DECLARE
    admin_user_id UUID;
    admin_email VARCHAR(255);
    new_gimnasio_id INTEGER;
    entrenadores_count INTEGER;
BEGIN
    RAISE NOTICE '=== Iniciando migración de datos ===';
    
    -- Paso 1: Buscar usuario administrador
    -- Busca el primer usuario con rol de Administrator
    SELECT id, email INTO admin_user_id, admin_email
    FROM directus_users 
    WHERE role = 'a3e1b914-5d5f-4339-978b-2319b1452349' -- ID del rol Administrator
    LIMIT 1;
    
    -- Verificar que existe un administrador
    IF admin_user_id IS NULL THEN
        RAISE EXCEPTION 'ERROR: No se encontró ningún usuario con rol de Administrador. 
        Por favor, crear un usuario administrador primero o ajustar el role ID en el script.';
    END IF;
    
    RAISE NOTICE 'Usuario administrador encontrado: % (ID: %)', admin_email, admin_user_id;
    
    -- Paso 2: Verificar si ya existe un gimnasio
    SELECT id INTO new_gimnasio_id
    FROM gimnasios
    LIMIT 1;
    
    IF new_gimnasio_id IS NOT NULL THEN
        RAISE NOTICE 'Ya existe un gimnasio con ID: %. Usando ese gimnasio.', new_gimnasio_id;
    ELSE
        -- Paso 3: Crear gimnasio principal
        INSERT INTO gimnasios (
            nombre, 
            descripcion, 
            direccion,
            email, 
            user_id, 
            activo,
            configuracion
        ) VALUES (
            'Gimnasio Principal',
            'Gimnasio creado automáticamente durante la migración a arquitectura multi-tenant',
            'Dirección por definir',
            admin_email,
            admin_user_id,
            true,
            '{"migrated": true, "migration_date": "2025-12-26"}'::jsonb
        ) RETURNING id INTO new_gimnasio_id;
        
        RAISE NOTICE 'Gimnasio Principal creado con ID: %', new_gimnasio_id;
    END IF;
    
    -- Paso 4: Contar entrenadores sin gimnasio
    SELECT COUNT(*) INTO entrenadores_count
    FROM entrenadores 
    WHERE gimnasio_id IS NULL;
    
    RAISE NOTICE 'Entrenadores sin gimnasio asignado: %', entrenadores_count;
    
    -- Paso 5: Asociar todos los entrenadores existentes al gimnasio principal
    UPDATE entrenadores 
    SET gimnasio_id = new_gimnasio_id
    WHERE gimnasio_id IS NULL;
    
    -- Paso 6: Verificación final
    SELECT COUNT(*) INTO entrenadores_count
    FROM entrenadores 
    WHERE gimnasio_id = new_gimnasio_id;
    
    RAISE NOTICE '=== Migración completada exitosamente ===';
    RAISE NOTICE 'Gimnasio ID: %', new_gimnasio_id;
    RAISE NOTICE 'Total entrenadores asignados: %', entrenadores_count;
    RAISE NOTICE 'Usuario gestor: % (%)', admin_email, admin_user_id;
    
END $$;

-- Verificación post-migración
SELECT 
    g.id,
    g.nombre,
    g.email,
    g.activo,
    COUNT(e.id) AS total_entrenadores
FROM gimnasios g
LEFT JOIN entrenadores e ON e.gimnasio_id = g.id
GROUP BY g.id, g.nombre, g.email, g.activo;

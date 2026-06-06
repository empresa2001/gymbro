-- ============================================
-- Configure Permissions for Multi-Tenant Architecture v2
-- ============================================
-- Description: Sets up all permissions using policy IDs  
-- Author: System
-- Date: 2025-12-26

-- First, let's get the policy IDs
DO $$
DECLARE
    gimnasio_policy_id UUID;
    entrenador_policy_id UUID;
    cliente_policy_id UUID;
BEGIN
    -- Get policy IDs
    SELECT id INTO gimnasio_policy_id FROM directus_policies WHERE name = 'Gimnasio';
    SELECT id INTO entrenador_policy_id FROM directus_policies WHERE name = 'Entrenador';
    SELECT id INTO cliente_policy_id FROM directus_policies WHERE name = 'Cliente';

    RAISE NOTICE 'Gimnasio Policy ID: %', gimnasio_policy_id;
    RAISE NOTICE 'Entrenador Policy ID: %', entrenador_policy_id;
    RAISE NOTICE 'Cliente Policy ID: %', cliente_policy_id;

    -- Clean existing permissions
    DELETE FROM directus_permissions 
    WHERE policy IN (gimnasio_policy_id, entrenador_policy_id, cliente_policy_id);

    RAISE NOTICE 'Old permissions deleted';

    -- ============================================
    -- GIMNASIO PERMISSIONS
    -- ============================================

    -- gimnasios
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'gimnasios', 'read', '{"user_id": {"_eq": "$CURRENT_USER"}}', '*'),
    (gimnasio_policy_id, 'gimnasios', 'update', '{"user_id": {"_eq": "$CURRENT_USER"}}', 'nombre,descripcion,direccion,telefono,logo,configuracion');

    -- entrenadores
    INSERT INTO directus_permissions (policy, collection, action, permissions, presets, fields) VALUES
    (gimnasio_policy_id, 'entrenadores', 'create', NULL, '{"gimnasio_id": "$CURRENT_USER.gimnasio.id"}', '*'),
    (gimnasio_policy_id, 'entrenadores', 'read', '{"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}', NULL, '*'),
    (gimnasio_policy_id, 'entrenadores', 'update', '{"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}', NULL, 'especialidad,descripcion,certificaciones,anos_experiencia'),
    (gimnasio_policy_id, 'entrenadores', 'delete', '{"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}', NULL, NULL);

    -- clientes
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'clientes', 'create', NULL, '*'),
    (gimnasio_policy_id, 'clientes', 'read', '{"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}', '*'),
    (gimnasio_policy_id, 'clientes', 'update', '{"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}', '*'),
    (gimnasio_policy_id, 'clientes', 'delete', '{"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}', NULL);

    -- planes
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (gimnasio_policy_id, 'planes', 'create', '*'),
    (gimnasio_policy_id, 'planes', 'read', '*'),
    (gimnasio_policy_id, 'planes', 'update', '*'),
    (gimnasio_policy_id, 'planes', 'delete', '*');

    -- ejercicios
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (gimnasio_policy_id, 'ejercicios', 'create', '*'),
    (gimnasio_policy_id, 'ejercicios', 'read', '*'),
    (gimnasio_policy_id, 'ejercicios', 'update', '*'),
    (gimnasio_policy_id, 'ejercicios', 'delete', '*');

    -- ejercicios_plan
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (gimnasio_policy_id, 'ejercicios_plan', 'create', '*'),
    (gimnasio_policy_id, 'ejercicios_plan', 'read', '*'),
    (gimnasio_policy_id, 'ejercicios_plan', 'update', '*'),
    (gimnasio_policy_id, 'ejercicios_plan', 'delete', '*');

    -- suscripciones
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'suscripciones', 'create', NULL, '*'),
    (gimnasio_policy_id, 'suscripciones', 'read', '{"cliente_id": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}', '*'),
    (gimnasio_policy_id, 'suscripciones', 'update', '{"cliente_id": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}', '*'),
    (gimnasio_policy_id, 'suscripciones', 'delete', '{"cliente_id": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}', NULL);

    -- directus_users
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'directus_users', 'create', NULL, 'email,password,first_name,last_name,role,status'),
    (gimnasio_policy_id, 'directus_users', 'read', '{"_or": [{"id": {"_eq": "$CURRENT_USER"}}, {"entrenador": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}, {"cliente": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}]}', 'id,email,first_name,last_name,role,status,avatar'),
    (gimnasio_policy_id, 'directus_users', 'update', '{"_or": [{"id": {"_eq": "$CURRENT_USER"}}, {"entrenador": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}, {"cliente": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}]}', 'first_name,last_name,status,avatar');

    -- directus_files
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'directus_files', 'create', NULL, '*'),
    (gimnasio_policy_id, 'directus_files', 'read', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', '*'),
    (gimnasio_policy_id, 'directus_files', 'update', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', '*'),
    (gimnasio_policy_id, 'directus_files', 'delete', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', NULL);

    -- sesiones_registro
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'sesiones_registro', 'read', '{"cliente_id": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}', '*');

    -- metricas_cliente
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (gimnasio_policy_id, 'metricas_cliente', 'read', '{"cliente_id": {"entrenador_asignado": {"gimnasio_id": {"_eq": "$CURRENT_USER.gimnasio.id"}}}}', '*');

    RAISE NOTICE 'Gimnasio permissions configured';

    -- ============================================
    -- ENTRENADOR PERMISSIONS
    -- ============================================

    -- gimnasios (read only)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'gimnasios', 'read', '{"id": {"_eq": "$CURRENT_USER.entrenador.gimnasio_id"}}', 'id,nombre,email,direccion,telefono');

    -- entrenadores (self)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'entrenadores', 'read', '{"user_id": {"_eq": "$CURRENT_USER"}}', '*'),
    (entrenador_policy_id, 'entrenadores', 'update', '{"user_id": {"_eq": "$CURRENT_USER"}}', 'especialidad,descripcion,certificaciones,anos_experiencia');

    -- clientes
    INSERT INTO directus_permissions (policy, collection, action, permissions, presets, fields) VALUES
    (entrenador_policy_id, 'clientes', 'create', NULL, '{"entrenador_asignado": "$CURRENT_USER.entrenador.id"}', '*'),
    (entrenador_policy_id, 'clientes', 'read', '{"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}', NULL, '*'),
    (entrenador_policy_id, 'clientes', 'update', '{"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}', NULL, '*'),
    (entrenador_policy_id, 'clientes', 'delete', '{"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}', NULL, NULL);

    -- planes
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (entrenador_policy_id, 'planes', 'create', '*'),
    (entrenador_policy_id, 'planes', 'read', '*'),
    (entrenador_policy_id, 'planes', 'update', '*'),
    (entrenador_policy_id, 'planes', 'delete', '*');

    -- ejercicios
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (entrenador_policy_id, 'ejercicios', 'create', '*'),
    (entrenador_policy_id, 'ejercicios', 'read', '*'),
    (entrenador_policy_id, 'ejercicios', 'update', '*'),
    (entrenador_policy_id, 'ejercicios', 'delete', '*');

    -- ejercicios_plan
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (entrenador_policy_id, 'ejercicios_plan', 'create', '*'),
    (entrenador_policy_id, 'ejercicios_plan', 'read', '*'),
    (entrenador_policy_id, 'ejercicios_plan', 'update', '*'),
    (entrenador_policy_id, 'ejercicios_plan', 'delete', '*');

    -- suscripciones
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'suscripciones', 'create', NULL, '*'),
    (entrenador_policy_id, 'suscripciones', 'read', '{"cliente_id": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}', '*'),
    (entrenador_policy_id, 'suscripciones', 'update', '{"cliente_id": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}', '*'),
    (entrenador_policy_id, 'suscripciones', 'delete', '{"cliente_id": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}', NULL);

    -- directus_users
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'directus_users', 'create', NULL, 'email,password,first_name,last_name,role,status'),
    (entrenador_policy_id, 'directus_users', 'read', '{"_or": [{"id": {"_eq": "$CURRENT_USER"}}, {"cliente": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}]}', 'id,email,first_name,last_name,role,status,avatar'),
    (entrenador_policy_id, 'directus_users', 'update', '{"_or": [{"id": {"_eq": "$CURRENT_USER"}}, {"cliente": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}]}', 'first_name,last_name,status,avatar');

    -- directus_files
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'directus_files', 'create', NULL, '*'),
    (entrenador_policy_id, 'directus_files', 'read', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', '*'),
    (entrenador_policy_id, 'directus_files', 'update', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', '*'),
    (entrenador_policy_id, 'directus_files', 'delete', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', NULL);

    -- sesiones_registro
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'sesiones_registro', 'read', '{"cliente_id": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}', '*');

    -- metricas_cliente
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (entrenador_policy_id, 'metricas_cliente', 'read', '{"cliente_id": {"entrenador_asignado": {"_eq": "$CURRENT_USER.entrenador.id"}}}', '*');

    RAISE NOTICE 'Entrenador permissions configured';

    -- ============================================
    -- CLIENTE PERMISSIONS
    -- ============================================

    -- gimnasios (read only)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'gimnasios', 'read', '{"id": {"_eq": "$CURRENT_USER.cliente.entrenador_asignado.gimnasio_id"}}', 'id,nombre,email,direccion,telefono');

    -- entrenadores (read only)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'entrenadores', 'read', '{"id": {"_eq": "$CURRENT_USER.cliente.entrenador_asignado"}}', 'id,especialidad,descripcion,user_id');

    -- clientes (self)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'clientes', 'read', '{"user_id": {"_eq": "$CURRENT_USER"}}', '*'),
    (cliente_policy_id, 'clientes', 'update', '{"user_id": {"_eq": "$CURRENT_USER"}}', 'objetivo,fecha_nacimiento,altura_cm,peso_kg');

    -- planes (read assigned)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'planes', 'read', '{"suscripciones": {"cliente_id": {"user_id": {"_eq": "$CURRENT_USER"}}}}', '*');

    -- ejercicios (read all)
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (cliente_policy_id, 'ejercicios', 'read', '*');

    -- ejercicios_plan (read all - for plan details)
    INSERT INTO directus_permissions (policy, collection, action, fields) VALUES
    (cliente_policy_id, 'ejercicios_plan', 'read', '*');

    -- suscripciones (read own)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'suscripciones', 'read', '{"cliente_id": {"user_id": {"_eq": "$CURRENT_USER"}}}', '*');

    -- directus_users (self)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'directus_users', 'read', '{"id": {"_eq": "$CURRENT_USER"}}', 'id,email,first_name,last_name,avatar'),
    (cliente_policy_id, 'directus_users', 'update', '{"id": {"_eq": "$CURRENT_USER"}}', 'first_name,last_name,avatar');

    -- directus_files
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'directus_files', 'create', NULL, '*'),
    (cliente_policy_id, 'directus_files', 'read', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', '*'),
    (cliente_policy_id, 'directus_files', 'update', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', '*'),
    (cliente_policy_id, 'directus_files', 'delete', '{"uploaded_by": {"_eq": "$CURRENT_USER"}}', NULL);

    -- sesiones_registro (CRUD own)
    INSERT INTO directus_permissions (policy, collection, action, permissions, presets, fields) VALUES
    (cliente_policy_id, 'sesiones_registro', 'create', NULL, '{"cliente_id": "$CURRENT_USER.cliente.id"}', '*'),
    (cliente_policy_id, 'sesiones_registro', 'read', '{"cliente_id": {"user_id": {"_eq": "$CURRENT_USER"}}}', NULL, '*'),
    (cliente_policy_id, 'sesiones_registro', 'update', '{"cliente_id": {"user_id": {"_eq": "$CURRENT_USER"}}}', NULL, '*'),
    (cliente_policy_id, 'sesiones_registro', 'delete', '{"cliente_id": {"user_id": {"_eq": "$CURRENT_USER"}}}', NULL, NULL);

    -- metricas_cliente (read own)
    INSERT INTO directus_permissions (policy, collection, action, permissions, fields) VALUES
    (cliente_policy_id, 'metricas_cliente', 'read', '{"cliente_id": {"user_id": {"_eq": "$CURRENT_USER"}}}', '*');

    RAISE NOTICE 'Cliente permissions configured';

END $$;

-- Verification
SELECT 
    p.name AS policy_name,
    COUNT(perm.id) AS total_permissions
FROM directus_policies p
LEFT JOIN directus_permissions perm ON perm.policy = p.id
WHERE p.name IN ('Gimnasio', 'Entrenador', 'Cliente')
GROUP BY p.id, p.name
ORDER BY p.name;

SELECT '✅ All permissions configured successfully!' AS status;

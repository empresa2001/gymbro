-- Script SQL para configurar suscripciones directamente en la base de datos

-- 1. Eliminar metadata de folder/coleccion existente
DELETE FROM directus_collections WHERE collection = 'suscripciones';

-- 2. Insertar configuracion correcta de coleccion
INSERT INTO directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning)
VALUES ('suscripciones', 'assignment', 'Asignacion de planes a clientes', NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

-- 3. Eliminar permisos viejos de suscripciones
DELETE FROM directus_permissions WHERE collection = 'suscripciones';

-- 4. Obtener ID del rol Entrenador
-- Ejecuta esto primero para ver el ID
-- SELECT id, name FROM directus_roles WHERE name = 'Entrenador';

-- 5. Insertar permisos para Entrenador (reemplaza ROLE_ID con el ID real del rol)
-- ID del rol Entrenador: 4192d542-2329-4a72-bbc9-d0ba3d5b2f21

INSERT INTO directus_permissions (role, collection, action, fields, permissions, validation, presets)
VALUES 
    ('4192d542-2329-4a72-bbc9-d0ba3d5b2f21', 'suscripciones', 'create', '*', NULL, NULL, NULL),
    ('4192d542-2329-4a72-bbc9-d0ba3d5b2f21', 'suscripciones', 'read', '*', NULL, NULL, NULL),
    ('4192d542-2329-4a72-bbc9-d0ba3d5b2f21', 'suscripciones', 'update', '*', NULL, NULL, NULL),
    ('4192d542-2329-4a72-bbc9-d0ba3d5b2f21', 'suscripciones', 'delete', '*', NULL, NULL, NULL);

-- Verificar
SELECT * FROM directus_permissions WHERE collection = 'suscripciones';

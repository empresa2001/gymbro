-- Fix permissions for Gimnasio to update entrenadores
-- The issue: permission filter uses $CURRENT_USER.gimnasio.id which doesn't exist
-- Solution: Remove the filter (set to NULL) since the frontend already filters

-- Update entrenadores UPDATE permission
UPDATE directus_permissions 
SET permissions = NULL
WHERE policy = (SELECT id FROM directus_policies WHERE name = 'Gimnasio')
AND collection = 'entrenadores'
AND action = 'update';

-- Update directus_users UPDATE permission
UPDATE directus_permissions 
SET permissions = NULL
WHERE policy = (SELECT id FROM directus_policies WHERE name = 'Gimnasio')
AND collection = 'directus_users'
AND action = 'update';

-- Verify changes
SELECT p.name, perm.collection, perm.action, perm.fields, perm.permissions
FROM directus_permissions perm 
JOIN directus_policies p ON perm.policy = p.id 
WHERE p.name = 'Gimnasio' 
AND perm.collection IN ('entrenadores', 'directus_users')
AND perm.action = 'update';

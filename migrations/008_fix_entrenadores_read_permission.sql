-- Fix Gimnasio permissions to read entrenadores correctly
-- The issue: permissions use $CURRENT_USER.gimnasio.id which doesn't exist
-- Solution: Use a subquery to find the gimnasio where user_id = $CURRENT_USER

UPDATE directus_permissions 
SET permissions = '{"gimnasio_id": {"_in": "$CURRENT_USER.gimnasio"}}'::json
WHERE policy = (SELECT id FROM directus_policies WHERE name = 'Gimnasio')
AND collection = 'entrenadores'
AND action = 'read';

-- Verify the updated permission
SELECT p.name as policy, perm.action, perm.permissions::text 
FROM directus_permissions perm 
JOIN directus_policies p ON perm.policy = p.id 
WHERE p.name = 'Gimnasio' AND perm.collection = 'entrenadores' AND perm.action = 'read';

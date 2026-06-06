-- Update Gimnasio permissions to allow reading Entrenador users
-- This fixes the issue where Gimnasio can create users but can't read them to get their ID

UPDATE directus_permissions 
SET permissions = '{"_or": [
    {"id": {"_eq": "$CURRENT_USER"}}, 
    {"role": {"_eq": "4192d542-2329-4a72-bbc9-d0ba3d5b2f21"}}
]}'::json
WHERE policy = (SELECT id FROM directus_policies WHERE name = 'Gimnasio')
AND collection = 'directus_users'
AND action = 'read';

-- Verify the updated permission
SELECT p.name as policy, perm.action, perm.permissions::text 
FROM directus_permissions perm 
JOIN directus_policies p ON perm.policy = p.id 
WHERE p.name = 'Gimnasio' AND perm.collection = 'directus_users' AND perm.action = 'read';

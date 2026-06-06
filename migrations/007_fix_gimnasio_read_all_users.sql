-- Remove the problematic permission filter for Gimnasio reading users
-- Allow Gimnasio to read ALL users (temporary fix to make trainer creation work)

UPDATE directus_permissions 
SET permissions = NULL
WHERE policy = (SELECT id FROM directus_policies WHERE name = 'Gimnasio')
AND collection = 'directus_users'
AND action = 'read';

-- Verify the updated permission
SELECT p.name as policy, perm.action, perm.permissions::text 
FROM directus_permissions perm 
JOIN directus_policies p ON perm.policy = p.id 
WHERE p.name = 'Gimnasio' AND perm.collection = 'directus_users' AND perm.action = 'read';

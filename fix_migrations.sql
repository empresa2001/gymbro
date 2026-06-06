-- Mark Directus migrations as completed to avoid conflicts
-- These migrations already ran during the backup restore

INSERT INTO directus_migrations (version, name, timestamp) VALUES
('20250118A', 'Add AI Settings', NOW()),
('20250120A', 'Remove Webhooks', NOW()),
('20250121A', 'Add AI Provider Settings', NOW()),
('20250123A', 'Add Revisions Index', NOW()),
('20250124A', 'Add Collaborative Editing', NOW()),
('20250127A', 'Add Deployment', NOW())
ON CONFLICT (version) DO NOTHING;

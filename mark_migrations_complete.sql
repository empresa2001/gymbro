-- Mark all recent Directus migrations as completed
-- This allows the new version to start without conflicts

INSERT INTO directus_migrations (version, name, timestamp) VALUES
-- Migrations from Directus 11.15+
('20251224A', 'Remove Webhooks', NOW()),
('20260110A', 'Add AI Provider Settings', NOW()),
('20260113A', 'Add Revisions Index', NOW()),
('20260128A', 'Add Collaborative Editing', NOW()),
('20260203A', 'Add Deployment', NOW())
ON CONFLICT (version) DO NOTHING;

-- Verify migrations were added
SELECT version, name FROM directus_migrations WHERE version >= '20251224A' ORDER BY version;

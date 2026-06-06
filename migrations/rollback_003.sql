-- ============================================
-- Rollback 003: Clear gimnasio assignments
-- ============================================
-- Description: Removes gimnasio assignments from entrenadores
-- Author: System
-- Date: 2025-12-26

-- WARNING: This will unassign all entrenadores from their gimnasios
-- Only use if you need to revert the migration

UPDATE entrenadores 
SET gimnasio_id = NULL;

-- Optionally delete the default gimnasio
-- DELETE FROM gimnasios WHERE nombre = 'Gimnasio Principal';

SELECT 
    'Gimnasio assignments cleared' AS status,
    COUNT(*) AS total_entrenadores,
    COUNT(gimnasio_id) AS with_gimnasio
FROM entrenadores;

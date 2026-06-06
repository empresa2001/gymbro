-- ============================================
-- Rollback 002: Remove gimnasio_id from entrenadores
-- ============================================
-- Description: Drops the gimnasio_id column and index
-- Author: System
-- Date: 2025-12-26

-- Drop the index first
DROP INDEX IF EXISTS idx_entrenadores_gimnasio_id;

-- Drop the column
ALTER TABLE entrenadores 
DROP COLUMN IF EXISTS gimnasio_id;

SELECT 'Column gimnasio_id removed from entrenadores' AS status;

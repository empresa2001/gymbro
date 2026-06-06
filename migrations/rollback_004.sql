-- ============================================
-- Rollback 004: Make gimnasio_id nullable again
-- ============================================
-- Description: Reverts the NOT NULL constraint on gimnasio_id
-- Author: System
-- Date: 2025-12-26

ALTER TABLE entrenadores 
ALTER COLUMN gimnasio_id DROP NOT NULL;

SELECT 'gimnasio_id is now nullable again' AS status;

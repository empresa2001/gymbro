-- ============================================
-- Rollback 001: Drop gimnasios table
-- ============================================
-- Description: Completely removes the gimnasios table
-- Author: System
-- Date: 2025-12-26

-- WARNING: This will delete ALL gimnasio data
-- Make sure to run rollback_002 first to remove foreign keys

DROP TABLE IF EXISTS gimnasios CASCADE;

SELECT 'Table gimnasios dropped' AS status;

-- ============================================
-- Migration 002: Add gimnasio_id to entrenadores
-- ============================================
-- Description: Adds gimnasio_id foreign key to entrenadores table
-- Author: System
-- Date: 2025-12-26

-- Add gimnasio_id column (nullable initially for data migration)
ALTER TABLE entrenadores 
ADD COLUMN IF NOT EXISTS gimnasio_id INTEGER 
REFERENCES gimnasios(id) ON DELETE CASCADE;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_entrenadores_gimnasio_id ON entrenadores(gimnasio_id);

-- Add comments for documentation
COMMENT ON COLUMN entrenadores.gimnasio_id IS 'Gimnasio al que pertenece este entrenador (requerido)';

-- Verification query
SELECT 
    'Column gimnasio_id added to entrenadores' AS status,
    COUNT(*) AS total_entrenadores,
    COUNT(gimnasio_id) AS with_gimnasio,
    COUNT(*) - COUNT(gimnasio_id) AS without_gimnasio
FROM entrenadores;

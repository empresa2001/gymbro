-- ============================================
-- Migration 004: Make gimnasio_id required
-- ============================================
-- Description: Makes gimnasio_id NOT NULL after data migration
-- Author: System
-- Date: 2025-12-26

-- IMPORTANT: Only run this AFTER migration 003 has completed successfully

DO $$
DECLARE
    orphan_count INTEGER;
BEGIN
    -- Verificar que NO hay entrenadores sin gimnasio
    SELECT COUNT(*) INTO orphan_count
    FROM entrenadores 
    WHERE gimnasio_id IS NULL;
    
    IF orphan_count > 0 THEN
        RAISE EXCEPTION 'ERROR: Aún hay % entrenadores sin gimnasio asignado. 
        Por favor ejecutar la migración 003 primero.', orphan_count;
    END IF;
    
    RAISE NOTICE 'Verificación exitosa: Todos los entrenadores tienen gimnasio asignado';
    
    -- Hacer el campo NOT NULL
    ALTER TABLE entrenadores 
    ALTER COLUMN gimnasio_id SET NOT NULL;
    
    RAISE NOTICE 'Campo gimnasio_id ahora es NOT NULL';
    
END $$;

-- Verificación final
SELECT 
    'gimnasio_id is now required' AS status,
    COUNT(*) AS total_entrenadores,
    COUNT(gimnasio_id) AS with_gimnasio
FROM entrenadores;

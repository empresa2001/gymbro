-- ============================================
-- Migration 001: Create gimnasios table
-- ============================================
-- Description: Creates the main gimnasios table for multi-tenant architecture
-- Author: System
-- Date: 2025-12-26

CREATE TABLE IF NOT EXISTS gimnasios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    direccion TEXT,
    telefono VARCHAR(50),
    email VARCHAR(255) NOT NULL UNIQUE,
    logo UUID REFERENCES directus_files(id) ON DELETE SET NULL,
    user_id UUID NOT NULL REFERENCES directus_users(id) ON DELETE CASCADE,
    activo BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    configuracion JSONB DEFAULT '{}'::jsonb,
    CONSTRAINT unique_user_gimnasio UNIQUE(user_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_gimnasios_user_id ON gimnasios(user_id);
CREATE INDEX idx_gimnasios_activo ON gimnasios(activo);
CREATE INDEX idx_gimnasios_email ON gimnasios(email);

-- Add comments for documentation
COMMENT ON TABLE gimnasios IS 'Gimnasios registrados en la plataforma multi-tenant';
COMMENT ON COLUMN gimnasios.id IS 'Primary key auto-incremental';
COMMENT ON COLUMN gimnasios.nombre IS 'Nombre comercial del gimnasio';
COMMENT ON COLUMN gimnasios.descripcion IS 'Descripción o información del gimnasio';
COMMENT ON COLUMN gimnasios.direccion IS 'Dirección física completa';
COMMENT ON COLUMN gimnasios.telefono IS 'Teléfono de contacto';
COMMENT ON COLUMN gimnasios.email IS 'Email de contacto del gimnasio (único)';
COMMENT ON COLUMN gimnasios.logo IS 'Archivo de logo del gimnasio (FK a directus_files)';
COMMENT ON COLUMN gimnasios.user_id IS 'Usuario de Directus que gestiona este gimnasio (relación 1:1)';
COMMENT ON COLUMN gimnasios.activo IS 'Estado activo/inactivo del gimnasio';
COMMENT ON COLUMN gimnasios.fecha_registro IS 'Fecha y hora de registro del gimnasio';
COMMENT ON COLUMN gimnasios.fecha_actualizacion IS 'Última actualización del registro';
COMMENT ON COLUMN gimnasios.configuracion IS 'JSON para configuraciones personalizadas del gimnasio';

-- Verification query
SELECT 'Table gimnasios created successfully' AS status;

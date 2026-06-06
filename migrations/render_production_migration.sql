-- ============================================
-- MIGRATION: Add AI Training Plans Support
-- Database: PostgreSQL (Render Production)
-- ============================================
-- This script creates the necessary schema for AI-generated training plans
-- Execute this in your Render PostgreSQL database

-- ============================================
-- 1. CREATE TABLE: planes_ia
-- ============================================
CREATE TABLE IF NOT EXISTS planes_ia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id INTEGER NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    objetivo VARCHAR(100),
    nivel_experiencia VARCHAR(50),
    duracion_tipo VARCHAR(50),
    dias_semana INTEGER,
    equipamiento JSONB,
    limitaciones TEXT,
    fecha_generacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    prompt_usado TEXT,
    activo BOOLEAN DEFAULT TRUE,
    date_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_planes_ia_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_planes_ia_cliente ON planes_ia(cliente_id);
CREATE INDEX IF NOT EXISTS idx_planes_ia_activo ON planes_ia(activo);

-- ============================================
-- 2. CREATE TABLE: ejercicios_plan_ia
-- ============================================
CREATE TABLE IF NOT EXISTS ejercicios_plan_ia (
    id SERIAL PRIMARY KEY,
    plan_ia_id UUID NOT NULL,
    ejercicio_id UUID NOT NULL,
    dia INTEGER,
    orden INTEGER NOT NULL,
    series INTEGER,
    repeticiones VARCHAR(50),
    duracion_minutos INTEGER,
    notas TEXT,
    date_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ejercicios_plan_ia_plan FOREIGN KEY (plan_ia_id) REFERENCES planes_ia(id) ON DELETE CASCADE,
    CONSTRAINT fk_ejercicios_plan_ia_ejercicio FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id) ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_ejercicios_plan_ia_plan ON ejercicios_plan_ia(plan_ia_id);
CREATE INDEX IF NOT EXISTS idx_ejercicios_plan_ia_ejercicio ON ejercicios_plan_ia(ejercicio_id);
CREATE INDEX IF NOT EXISTS idx_ejercicios_plan_ia_orden ON ejercicios_plan_ia(plan_ia_id, orden);

-- ============================================
-- 3. ALTER TABLE: Add tipo_plan_preferido to clientes
-- ============================================
ALTER TABLE clientes 
ADD COLUMN IF NOT EXISTS tipo_plan_preferido VARCHAR(50);

-- Add comments for documentation
COMMENT ON TABLE planes_ia IS 'AI-generated training plans for clients';
COMMENT ON TABLE ejercicios_plan_ia IS 'Junction table linking AI plans to exercises';
COMMENT ON COLUMN clientes.tipo_plan_preferido IS 'Client preference: profesor, ia, or ambos';

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these to verify the migration was successful:

-- Check if tables exist:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('planes_ia', 'ejercicios_plan_ia');

-- Check if column was added:
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'clientes' AND column_name = 'tipo_plan_preferido';

-- Show table structure:
-- \d planes_ia
-- \d ejercicios_plan_ia

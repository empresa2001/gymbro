-- =====================================================
-- SCRIPT: Crear colecciones para Planes IA
-- Descripción: Crea las tablas necesarias para planes
--              generados por IA en PostgreSQL/Directus
-- =====================================================

-- 1. Crear tabla planes_ia
CREATE TABLE IF NOT EXISTS planes_ia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id INTEGER NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    objetivo VARCHAR(100),
    nivel_experiencia VARCHAR(50),
    duracion_tipo VARCHAR(50), -- 'diario', 'semanal', 'mensual'
    dias_semana INTEGER,
    equipamiento JSONB, -- Array de equipamiento disponible
    limitaciones TEXT,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    prompt_usado TEXT,
    activo BOOLEAN DEFAULT true,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_planes_ia_cliente 
        FOREIGN KEY (cliente_id) 
        REFERENCES clientes(id) 
        ON DELETE CASCADE
);

-- Índices para mejorar performance
CREATE INDEX idx_planes_ia_cliente ON planes_ia(cliente_id);
CREATE INDEX idx_planes_ia_activo ON planes_ia(activo);

-- 2. Crear tabla ejercicios_plan_ia (junction table)
CREATE TABLE IF NOT EXISTS ejercicios_plan_ia (
    id SERIAL PRIMARY KEY,
    plan_ia_id UUID NOT NULL,
    ejercicio_id UUID NOT NULL,
    dia INTEGER, -- Para planes semanales/mensuales (1-7 o 1-30)
    orden INTEGER NOT NULL,
    series INTEGER,
    repeticiones VARCHAR(50), -- "12-15" o "30 segundos"
    duracion_minutos INTEGER,
    notas TEXT,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_ejercicios_plan_ia_plan 
        FOREIGN KEY (plan_ia_id) 
        REFERENCES planes_ia(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_ejercicios_plan_ia_ejercicio 
        FOREIGN KEY (ejercicio_id) 
        REFERENCES ejercicios(id) 
        ON DELETE CASCADE
);

-- Índices
CREATE INDEX idx_ejercicios_plan_ia_plan ON ejercicios_plan_ia(plan_ia_id);
CREATE INDEX idx_ejercicios_plan_ia_ejercicio ON ejercicios_plan_ia(ejercicio_id);
CREATE INDEX idx_ejercicios_plan_ia_orden ON ejercicios_plan_ia(plan_ia_id, orden);

-- 3. Agregar campo tipo_plan_preferido a clientes
ALTER TABLE clientes 
ADD COLUMN IF NOT EXISTS tipo_plan_preferido VARCHAR(50);

-- Comentarios para documentación
COMMENT ON TABLE planes_ia IS 'Planes de entrenamiento generados por IA';
COMMENT ON TABLE ejercicios_plan_ia IS 'Junction table: Ejercicios de planes IA';
COMMENT ON COLUMN clientes.tipo_plan_preferido IS 'Preferencia del cliente: profesor, ia, ambos';

-- =====================================================
-- Verificación
-- =====================================================
-- Ejecuta esto para verificar que las tablas se crearon:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('planes_ia', 'ejercicios_plan_ia');

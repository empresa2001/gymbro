-- Eliminar tablas en orden correcto (con CASCADE para eliminar dependencias)
DROP TABLE IF EXISTS suscripciones CASCADE;
DROP TABLE IF EXISTS plan_ejercicios CASCADE;
DROP TABLE IF EXISTS planes CASCADE;

-- Crear tabla planes con ID serial (auto-increment integer)
CREATE TABLE planes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    duracion_dias INTEGER NOT NULL DEFAULT 30,
    activo BOOLEAN NOT NULL DEFAULT true,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla plan_ejercicios
CREATE TABLE plan_ejercicios (
    id SERIAL PRIMARY KEY,
    plan_id INTEGER NOT NULL REFERENCES planes(id) ON DELETE CASCADE,
    ejercicio_id UUID,
    nombre VARCHAR(255),
    descripcion TEXT,
    series INTEGER,
    repeticiones INTEGER,
    duracion_minutos INTEGER,
    orden INTEGER,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla suscripciones
CREATE TABLE suscripciones (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    plan_id INTEGER NOT NULL REFERENCES planes(id) ON DELETE CASCADE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    habilitado BOOLEAN NOT NULL DEFAULT true,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_created UUID,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

-- Indices para mejorar performance
CREATE INDEX idx_plan_ejercicios_plan ON plan_ejercicios(plan_id);
CREATE INDEX idx_suscripciones_cliente ON suscripciones(cliente_id);
CREATE INDEX idx_suscripciones_plan ON suscripciones(plan_id);

SELECT 'Tablas creadas exitosamente' AS resultado;

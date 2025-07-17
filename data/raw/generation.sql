-- Crear tabla de indicadores
CREATE TABLE IF NOT EXISTS indicadores (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    frequencia TEXT,
    fuente TEXT
);

-- Crear tabla de series
CREATE TABLE IF NOT EXISTS series (
    id SERIAL PRIMARY KEY,
    indicador_id INTEGER REFERENCES indicator(id),
    unidad TEXT,
    fuente TEXT,
    descripcion TEXT
);

-- Crear tabla de observaciones
CREATE TABLE IF NOT EXISTS observacion (
    tiempo DATE NOT NULL,
    series_id INTEGER REFERENCES series(id),
    valor NUMERIC,
    PRIMARY KEY (time, series_id)
);

-- Convertir observation en hypertable
SELECT create_hypertable('observation', 'time', if_not_exists => TRUE);


alter table series add column unidad  TEXT;
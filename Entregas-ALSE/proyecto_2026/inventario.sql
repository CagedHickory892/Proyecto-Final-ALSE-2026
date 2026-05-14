-- Eliminar tablas si existen (evita conflictos durante el desarrollo)
DROP TABLE IF EXISTS movement_log;
DROP TABLE IF EXISTS components;

-- Habilitar llaves foráneas para SQLite (importante colocar en el código de conexión también)
PRAGMA foreign_keys = ON;

-- Crear tabla principal de componentes con tipos y restricciones mejoradas
CREATE TABLE components (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity >= 0),
    location TEXT,
    purchase_date DATE,
    lote INTEGER CHECK (lote IS NULL OR lote > 0),
    notes TEXT,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de movimientos con tipo de operación y marca de tiempo
CREATE TABLE movement_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    component_id INTEGER NOT NULL,
    change INTEGER NOT NULL,
    operation_type TEXT NOT NULL CHECK(operation_type IN ('ENTRADA', 'SALIDA', 'AJUSTE')),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    -- Campo opcional para auditoría o multiusuario
    user TEXT,
    FOREIGN KEY (component_id) REFERENCES components(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Índices optimizados para consultas frecuentes
CREATE INDEX idx_components_name ON components(name);
CREATE INDEX idx_components_type ON components(type);
CREATE INDEX idx_components_purchase_date ON components(purchase_date);
CREATE INDEX idx_movement_component_id ON movement_log(component_id);
CREATE INDEX idx_movement_timestamp ON movement_log(timestamp);

-- Trigger: Evitar stock negativo antes de registrar movimientos
CREATE TRIGGER prevent_negative_quantity
BEFORE INSERT ON movement_log
BEGIN
    SELECT
        CASE
                WHEN NEW.change < 0 AND
                        (SELECT quantity FROM components WHERE id = NEW.component_id) + NEW.change < 0
                THEN RAISE(ABORT, 'Stock insuficiente')
        END;
END;

-- Trigger: Actualizar cantidad automáticamente después del movimiento
CREATE TRIGGER update_quantity_after_insert
AFTER INSERT ON movement_log
BEGIN
    UPDATE components
    SET quantity = quantity + NEW.change,
        last_update = CURRENT_TIMESTAMP
    WHERE id = NEW.component_id;
END;

-- Opcional: Trigger para actualizar campo last_update al modificar datos básicos
CREATE TRIGGER update_lastupdate_on_components_update
AFTER UPDATE OF name, type, location, purchase_date, lote, notes ON components
BEGIN
    UPDATE components
    SET last_update = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;

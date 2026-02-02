-- Ensure WAL level is logical (Debezium requirement)
-- Note: 'debezium/postgres' image usually configures this, but good to be explicit for learning.
ALTER SYSTEM SET wal_level = logical;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    price DECIMAL(10, 2),
    stock_status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance (optional but good practice)
CREATE INDEX idx_products_category ON products(category);

-- Insert some initial sample data
INSERT INTO products (name, description, category, price, stock_status) VALUES
('iPhone 15 Pro', 'Titanium design, A17 Pro chip, 48MP Main camera.', 'Electronics', 999.99, 'IN_STOCK'),
('MacBook Air M2', 'Supercharged by M2 chip. 13.6-inch Liquid Retina display.', 'Electronics', 1199.00, 'IN_STOCK'),
('The Great Gatsby', 'A novel by F. Scott Fitzgerald.', 'Books', 14.99, 'IN_STOCK'),
('Levis 501 Original', 'Classic straight leg blue jeans.', 'Clothing', 59.50, 'IN_STOCK');

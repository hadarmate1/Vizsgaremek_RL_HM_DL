
USE nexora;

-- TERMÉKEK

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(180) NOT NULL,
    category VARCHAR(100) NOT NULL,
    type VARCHAR(80) DEFAULT 'computer',
    description TEXT,
    price DECIMAL(12, 2) NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PC KONFIGURÁTOR ALKATRÉSZEI

CREATE TABLE IF NOT EXISTS components (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(180) NOT NULL,
    type ENUM(
        'cpu',
        'motherboard',
        'ram',
        'gpu',
        'storage',
        'psu',
        'case'
    ) NOT NULL,
    price DECIMAL(12, 2) NOT NULL DEFAULT 0,
    socket VARCHAR(80),
    ram_type VARCHAR(40),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RENDELÉSEK

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(60) NOT NULL UNIQUE,
    company_name VARCHAR(180),
    status VARCHAR(40) NOT NULL DEFAULT 'Feldolgozás alatt',
    total DECIMAL(14, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RENDELÉSI TÉTELEK

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NULL,
    name VARCHAR(180) NOT NULL,
    type VARCHAR(80),
    quantity INT NOT NULL DEFAULT 1,
    component_ids JSON,
    license_ids JSON,
    unit_price DECIMAL(12, 2) NOT NULL DEFAULT 0,

    FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE SET NULL
);

-- LICENCEK

CREATE TABLE IF NOT EXISTS licenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(180) NOT NULL,
    license_key VARCHAR(255) UNIQUE,
    order_id INT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'Aktív',
    valid_until DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE SET NULL
);

-- ÁRKERESŐ AJÁNLATOK

CREATE TABLE IF NOT EXISTS price_offers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(180) NOT NULL,
    merchant VARCHAR(180) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    url VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FÓRUMTÉMÁK

CREATE TABLE IF NOT EXISTS forum_topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(220) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    author VARCHAR(120) DEFAULT 'NEXORA felhasználó',
    replies INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CÉGES PROFIL

CREATE TABLE IF NOT EXISTS company_profile (
    id INT PRIMARY KEY,
    company_name VARCHAR(180),
    contact_name VARCHAR(180),
    contact_email VARCHAR(180),
    tax_number VARCHAR(80),
    company_address VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- MINTA TERMÉKEK

INSERT INTO products
(name, category, type, description, price, stock)
VALUES
(
    'NEXORA Business Pro 15',
    'Laptop',
    'laptop',
    'Üzleti laptop mindennapi irodai feladatokra.',
    389900,
    24
),
(
    'NEXORA Office Station',
    'Asztali számítógép',
    'desktop',
    'Előre konfigurált üzleti asztali számítógép.',
    329900,
    18
),
(
    'NEXORA Server Rack 2U',
    'Szerver',
    'server',
    'Rack kivitelű szerver vállalati környezethez.',
    1299900,
    5
);

-- MINTA ALKATRÉSZEK

INSERT INTO components
(name, type, price, socket, ram_type, description)
VALUES
('Intel Core i5-14400', 'cpu', 89900, 'LGA1700', NULL,
 '14. generációs Intel processzor'),
('AMD Ryzen 7 7700', 'cpu', 119900, 'AM5', NULL,
 'AMD Ryzen processzor'),
('ASUS PRIME B760M-A', 'motherboard', 59900, 'LGA1700', 'DDR5',
 'Intel LGA1700 alaplap'),
('MSI PRO B650M-A', 'motherboard', 69900, 'AM5', 'DDR5',
 'AMD AM5 alaplap'),
('Kingston Fury 16GB DDR5', 'ram', 18900, NULL, 'DDR5',
 '16 GB DDR5 memória'),
('Kingston Fury 32GB DDR4', 'ram', 27900, NULL, 'DDR4',
 '32 GB DDR4 memória'),
('NVIDIA RTX 4060', 'gpu', 139900, NULL, NULL,
 'Grafikus kártya'),
('Samsung 990 EVO 1TB', 'storage', 32900, NULL, NULL,
 'NVMe SSD'),
('be quiet! System Power 650W', 'psu', 25900, NULL, NULL,
 '650 wattos tápegység'),
('Fractal Design Pop Air', 'case', 32900, NULL, NULL,
 'Számítógépház');

-- MINTA LICENCEK

INSERT INTO licenses
(name, license_key, status, valid_until)
VALUES
('Windows 11 Pro', 'DEMO-WIN-001', 'Aktív', '2027-12-31'),
('Microsoft 365 Business', 'DEMO-M365-001', 'Aktív', '2027-06-30'),
('Windows Server', 'DEMO-SRV-001', 'Lejárt', '2025-01-01');

-- MINTA ÁRAJÁNLATOK

INSERT INTO price_offers
(product_name, merchant, price, url)
VALUES
('Intel Core i5-14400', 'Példa Webáruház', 89900,
 'https://example.com'),
('Kingston Fury 16GB DDR5', 'Példa Webáruház', 18900,
 'https://example.com');

-- MINTA FÓRUMTÉMÁK

INSERT INTO forum_topics
(title, category, description, author, replies)
VALUES
(
    'Milyen laptopot ajánlotok irodai munkára?',
    'Laptop',
    'Nagyobb mennyiségben keresünk megbízható üzleti laptopokat.',
    'Rendszergazda',
    4
),
(
    'DDR5 memória tapasztalatok',
    'Alkatrészek',
    'Milyen DDR5 memóriát használtok céges gépekben?',
    'Hardveres',
    7
);

-- ALAPÉRTELMEZETT CÉGES PROFIL

INSERT INTO company_profile
(
    id,
    company_name,
    contact_name,
    contact_email,
    tax_number,
    company_address
)
VALUES
(
    1,
    'NEXORA Demo Kft.',
    'Teszt Felhasználó',
    'teszt@nexora.hu',
    '12345678-1-42',
    'Budapest'
);

CREATE TABLE IF NOT EXISTS dim_location (
    location_id SERIAL PRIMARY KEY,
    country VARCHAR(255),
    state VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dim_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dim_pet (
    pet_id SERIAL PRIMARY KEY,
    pet_type VARCHAR(255),
    pet_category VARCHAR(255),
    pet_breed VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    age INTEGER,
    email VARCHAR(255) UNIQUE NOT NULL,
    location_id INTEGER REFERENCES dim_location(location_id),
    pet_id INTEGER REFERENCES dim_pet(pet_id),
    pet_name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dim_seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    location_id INTEGER REFERENCES dim_location(location_id)
);

CREATE TABLE IF NOT EXISTS dim_store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255),
    location_address VARCHAR(255),
    location_id INTEGER REFERENCES dim_location(location_id),
    phone VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255),
    contact_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    location_address VARCHAR(255),
    location_id INTEGER REFERENCES dim_location(location_id)
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    category_id INTEGER REFERENCES dim_category(category_id),
    supplier_id INTEGER REFERENCES dim_supplier(supplier_id),
    price REAL,
    weight REAL,
    color VARCHAR(255),
    size VARCHAR(255),
    brand VARCHAR(255),
    material VARCHAR(255),
    description TEXT,
    rating REAL,
    reviews INTEGER,
    release_date DATE,
    expiry_date DATE
);

CREATE TABLE IF NOT EXISTS fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    customer_id INTEGER REFERENCES dim_customer(customer_id),
    seller_id INTEGER REFERENCES dim_seller(seller_id),
    product_id INTEGER REFERENCES dim_product(product_id),
    store_id INTEGER REFERENCES dim_store(store_id),
    quantity INTEGER,
    total_price REAL
);

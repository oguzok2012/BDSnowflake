INSERT INTO dim_location (country, state, city, postal_code)
SELECT customer_country, NULL, NULL, customer_postal_code
    FROM mock_data WHERE customer_country IS NOT NULL
UNION SELECT seller_country, NULL, NULL, seller_postal_code
    FROM mock_data WHERE seller_country IS NOT NULL
UNION SELECT store_country, store_state, store_city, NULL
    FROM mock_data WHERE store_country IS NOT NULL
UNION SELECT supplier_country, NULL, supplier_city, NULL
    FROM mock_data WHERE supplier_country IS NOT NULL;

INSERT INTO dim_category (category_name)
SELECT DISTINCT
    product_category
FROM mock_data
WHERE product_category IS NOT NULL;


INSERT INTO dim_pet (pet_type, pet_category, pet_breed)
SELECT DISTINCT
    customer_pet_type,
    pet_category,
    customer_pet_breed
FROM mock_data
WHERE customer_pet_type IS NOT NULL;


INSERT INTO dim_customer (first_name, last_name, age, email, location_id, pet_id, pet_name)
SELECT DISTINCT ON (m.customer_email)
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    l.location_id,
    p.pet_id,
    m.customer_pet_name
FROM mock_data m
LEFT JOIN dim_location l
       ON m.customer_country    = l.country
      AND m.customer_postal_code = l.postal_code
      AND l.city IS NULL
LEFT JOIN dim_pet p
       ON m.customer_pet_type  = p.pet_type
      AND m.pet_category       = p.pet_category
      AND m.customer_pet_breed = p.pet_breed
WHERE m.customer_email IS NOT NULL
ORDER BY m.customer_email;


INSERT INTO dim_seller (first_name, last_name, email, location_id)
SELECT DISTINCT ON (m.seller_email)
    m.seller_first_name,
    m.seller_last_name,
    m.seller_email,
    l.location_id
FROM mock_data m
LEFT JOIN dim_location l
       ON m.seller_country     = l.country
      AND m.seller_postal_code = l.postal_code
      AND l.city IS NULL
WHERE m.seller_email IS NOT NULL
ORDER BY m.seller_email;


INSERT INTO dim_store (store_name, location_address, location_id, phone, email)
SELECT DISTINCT
    m.store_name,
    m.store_location,
    l.location_id,
    m.store_phone,
    m.store_email
FROM mock_data m
LEFT JOIN dim_location l
       ON m.store_country = l.country
      AND m.store_state   = l.state
      AND m.store_city    = l.city
      AND l.postal_code IS NULL
WHERE m.store_name IS NOT NULL;


INSERT INTO dim_supplier (supplier_name, contact_name, email, phone, location_address, location_id)
SELECT DISTINCT
    m.supplier_name,
    m.supplier_contact,
    m.supplier_email,
    m.supplier_phone,
    m.supplier_address,
    l.location_id
FROM mock_data m
LEFT JOIN dim_location l
       ON m.supplier_country = l.country
      AND m.supplier_city    = l.city
      AND l.state      IS NULL
      AND l.postal_code IS NULL
WHERE m.supplier_name IS NOT NULL;


INSERT INTO dim_product (
    product_name,
    category_id,
    supplier_id,
    price,
    weight,
    color,
    size,
    brand,
    material,
    description,
    rating,
    reviews,
    release_date,
    expiry_date
)
SELECT DISTINCT ON (m.product_name, m.product_brand, m.product_color, m.product_size, m.product_material)
    m.product_name,
    c.category_id,
    s.supplier_id,
    m.product_price,
    m.product_weight,
    m.product_color,
    m.product_size,
    m.product_brand,
    m.product_material,
    m.product_description,
    m.product_rating,
    m.product_reviews,
    TO_DATE(NULLIF(m.product_release_date, ''), 'MM/DD/YYYY'),
    TO_DATE(NULLIF(m.product_expiry_date,  ''), 'MM/DD/YYYY')
FROM mock_data m
LEFT JOIN dim_category c
       ON m.product_category = c.category_name
LEFT JOIN dim_supplier s
       ON m.supplier_name  = s.supplier_name
      AND m.supplier_email = s.email
WHERE m.product_name IS NOT NULL
ORDER BY m.product_name, m.product_brand, m.product_color, m.product_size, m.product_material;


INSERT INTO fact_sales (sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price)
SELECT
    TO_DATE(NULLIF(m.sale_date, ''), 'MM/DD/YYYY'),
    c.customer_id,
    sl.seller_id,
    p.product_id,
    st.store_id,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
LEFT JOIN dim_customer c
       ON m.customer_email = c.email
LEFT JOIN dim_seller sl
       ON m.seller_email = sl.email
LEFT JOIN dim_product p
       ON m.product_name     = p.product_name
      AND m.product_brand    = p.brand
      AND m.product_color    = p.color
      AND m.product_size     = p.size
      AND m.product_material = p.material
LEFT JOIN dim_store st
       ON m.store_name  = st.store_name
      AND m.store_email = st.email;

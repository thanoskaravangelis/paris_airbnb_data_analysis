-- Populate neighbourhood and host tables first 
INSERT INTO neighbourhood (n_id, name)
SELECT id, name
FROM arrondissement_map;

-- Use distinct to keep only unique host_id values from cleaned_listings data
INSERT INTO host (host_id, host_city_listings_count)
SELECT DISTINCT host_id, calculated_host_listings_count 
FROM cleaned_listings GROUP BY host_id;

-- Populate listing table from cleaned_listings data table joined with the neighbourhood table for the correct ids
INSERT INTO listing (id, host_id_fk, n_id_fk, price, first_review_year, minimum_nights, number_of_reviews_ltm)
SELECT id, host_id, neighbourhood.n_id, price, first_review_year, minimum_nights, number_of_reviews_ltm
FROM cleaned_listings 
JOIN neighbourhood
WHERE neighbourhood_cleansed = neighbourhood.name;

--- Question 4
--What is the average price per night for a listing in Paris? 
SELECT AVG(price) as average_price_per_night
FROM listing;

--What is the average price per night in each arrondissement? 
SELECT neighbourhood.n_id, neighbourhood.name, AVG(price) as average_price_per_night_per_neighbourhood
FROM listing 
JOIN neighbourhood on neighbourhood.n_id =listing.n_id_fk
GROUP BY neighbourhood.n_id
ORDER BY average_price_per_night_per_neighbourhood DESC;

--What is the average price per night of listings owned by single-listing hosts and by multi-listing hosts?
-- just the average price for all listings
SELECT
    host_category, AVG(price) OVER (PARTITION BY host_category) AS average_price_per_night
FROM (
    SELECT
        host_id_fk, price, host_city_listings_count,
        CASE
            WHEN host.host_city_listings_count = 1 THEN 'Single-listing Hosts'
			WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN '2-3 listing Hosts'
			WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN '4-9 listing Hosts'
			ELSE '10+ listing Hosts'
        END AS host_category
    FROM listing 
	JOIN host on host.host_id = listing.host_id_fk
) AS HostCategory
GROUP BY host_category
ORDER BY average_price_per_night DESC;

-- Average price per category of hosts per arrondissement
SELECT name, n_id, hosts_group, average_arrondissement_price_for_category
FROM(
	SELECT
		CASE
				WHEN host.host_city_listings_count = 1 THEN 'Single-listing Hosts'
				WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN '2-3 listing Hosts'
				WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN '4-9 listing Hosts'
				ELSE 'Multi-listing Hosts'
			END AS hosts_group, 
	neighbourhood.name, neighbourhood.n_id, ROUND(AVG(price),2) AS average_arrondissement_price_for_category
	FROM  host
	JOIN (
		SELECT host_id_fk, COUNT(*) AS num_listings, n_id_fk, price
		FROM listing
		GROUP BY host_id_fk
	) AS l ON host.host_id = l.host_id_fk
	JOIN neighbourhood ON neighbourhood.n_id = l.n_id_fk
	GROUP BY hosts_group, neighbourhood.name
	ORDER BY hosts_group
) AS ranked_listings_per_price
GROUP BY name, hosts_group
ORDER BY n_id ASC, average_arrondissement_price_for_category DESC;



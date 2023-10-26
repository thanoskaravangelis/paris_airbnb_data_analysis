--- Question 6
--What is the average yearly profit of hosts per category of hosts?

SELECT hosts_group, CAST(AVG( number_of_reviews_ltm*2*length_of_stay*price) AS INTEGER) as average_yearly_income, COUNT(*) as number_of_listings
FROM (
  SELECT
        CASE
            WHEN l.minimum_nights < 4.7 THEN 4.7
            ELSE l.minimum_nights
        END AS length_of_stay, 
		CASE 
            WHEN host.host_city_listings_count = 1 THEN 'Single-listing Hosts'
            WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN '2-3 listing Hosts'
            WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN '4-9 listing Hosts'
            ELSE '10+ listing Hosts'
        END AS hosts_group, number_of_reviews_ltm, price
	FROM listing AS l 
	JOIN host on host.host_id = l.host_id_fk
	WHERE l.number_of_reviews_ltm*2*length_of_stay < 365
) as reservations
WHERE number_of_reviews_ltm > 0
GROUP BY hosts_group
ORDER BY  average_yearly_income DESC;

--What is the average yearly profit of listings in each arrondissement? 
SELECT ROW_NUMBER() OVER (ORDER BY AVG(number_of_reviews_ltm*2*length_of_stay*price) DESC ) as ranking, n_id, name, CAST(AVG( number_of_reviews_ltm*2*length_of_stay*price) AS INTEGER) as average_yearly_income, COUNT(*) as number_of_listings
FROM (
  SELECT
        CASE
            WHEN l.minimum_nights < 4.7 THEN 4.7
            ELSE l.minimum_nights
        END AS length_of_stay, number_of_reviews_ltm, n_id, name, price
	FROM listing AS l 
	JOIN neighbourhood AS n ON n_id = n_id_fk
	JOIN host ON host.host_id = l.host_id_fk
	WHERE l.number_of_reviews_ltm*2*length_of_stay < 365
) as reservations
WHERE number_of_reviews_ltm > 0
GROUP BY name
ORDER BY  ranking;

-- What is the average yearly profit of listings in each arrondissement per host category? 

SELECT n_id, name, hosts_group, CAST(AVG( number_of_reviews_ltm*2*length_of_stay*price) AS INTEGER) as average_yearly_income, COUNT(*) as number_of_listings
FROM (
  SELECT
		CASE
				WHEN host.host_city_listings_count = 1 THEN 'Single-listing Hosts'
				WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN '2-3 listing Hosts'
				WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN '4-9 listing Hosts'
				ELSE 'Multi-listing Hosts'
		END AS hosts_group, 
        CASE
            WHEN l.minimum_nights < 4.7 THEN 4.7
            ELSE l.minimum_nights
        END AS length_of_stay, number_of_reviews_ltm, n_id, name, price
	FROM listing AS l 
	JOIN neighbourhood AS n ON n_id = n_id_fk
	JOIN host ON host.host_id = l.host_id_fk
	WHERE l.number_of_reviews_ltm*2*length_of_stay < 365
) as reservations
WHERE number_of_reviews_ltm > 0
GROUP BY name, hosts_group
ORDER BY  n_id;
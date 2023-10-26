--- Question 5
--What is the average number of booked nights per listing in Paris? 
-- Active listings - one review in the last 12 months

SELECT ROUND(AVG( number_of_reviews_ltm*2*length_of_stay),2) as average_booked_nights, COUNT(number_of_reviews_ltm) as number_of_listings
FROM ( 
  SELECT
        CASE
            WHEN l.minimum_nights < 4.7 THEN 4.7
            ELSE l.minimum_nights
        END AS length_of_stay, number_of_reviews_ltm
	FROM listing AS l 
	WHERE l.number_of_reviews_ltm*2*length_of_stay < 365
) as reservations
WHERE number_of_reviews_ltm > 0;

--What is the average number of booked nights for listings owned by single-listing hosts and by multi-listing hosts?

SELECT hosts_group, ROUND(AVG( number_of_reviews_ltm*2*length_of_stay),2) as average_booked_nights, COUNT(*) as number_of_listings
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
        END AS hosts_group, number_of_reviews_ltm
	FROM listing AS l 
	JOIN host on host.host_id = l.host_id_fk
	WHERE l.number_of_reviews_ltm*2*length_of_stay < 365
) as reservations
WHERE number_of_reviews_ltm > 0
GROUP BY hosts_group
ORDER BY  average_booked_nights DESC

--What is the ranking of neighbourhoods based on average number of booked nights? 

SELECT ROW_NUMBER() OVER (ORDER BY AVG(number_of_reviews_ltm*2*length_of_stay) DESC ) as ranking, n_id, name, ROUND(AVG( number_of_reviews_ltm*2*length_of_stay),2) as average_booked_nights, COUNT(*) as number_of_listings
FROM (
  SELECT
        CASE
            WHEN l.minimum_nights < 4.7 THEN 4.7
            ELSE l.minimum_nights
        END AS length_of_stay, number_of_reviews_ltm, n_id, name
	FROM listing AS l 
	JOIN neighbourhood AS n ON n_id = n_id_fk
	WHERE l.number_of_reviews_ltm*2*length_of_stay < 365
) as reservations
WHERE number_of_reviews_ltm > 0
GROUP BY name
ORDER BY  ranking
--- Question 3
--Listings per neighbourhood
SELECT neighbourhood.name, neighbourhood.n_id, COUNT(*) as occurences
FROM listing 
JOIN neighbourhood ON n_id = n_id_fk
GROUP BY neighbourhood.name
ORDER BY occurences DESC;

-- How are the listings spread across the arrondissements of Paris per host category?
SELECT
    ROW_NUMBER() OVER (PARTITION BY hosts_cat ORDER BY total_listings DESC) AS neighbourhood_rank,
    hosts_group, name, n_id, total_listings, number_of_hosts
FROM (
    SELECT
	    CASE -- just for the proper numbering of the hosts_groups
				WHEN host.host_city_listings_count = 1 THEN 1
				WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN 2
				WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN 3
				ELSE 4
		END AS hosts_cat,
        CASE 
            WHEN host.host_city_listings_count = 1 THEN 'Single-listing Hosts'
            WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN '2-3 listing Hosts'
            WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN '4-9 listing Hosts'
            ELSE '10+ listing Hosts'
        END AS hosts_group, neighbourhood.name, neighbourhood.n_id, 
		SUM(l.num_listings) AS total_listings, COUNT(*) AS number_of_hosts
    FROM host
    JOIN (
        SELECT host_id_fk, COUNT(*) AS num_listings, n_id_fk, price FROM listing GROUP BY host_id_fk
    ) AS l ON host.host_id = l.host_id_fk
    JOIN neighbourhood ON neighbourhood.n_id = l.n_id_fk
    GROUP BY hosts_group, neighbourhood.name
) AS grouped_per_neighbourhood
ORDER BY hosts_cat;

--- Question 2
-- Check how many listings hosts have and how many listings are in each category 

SELECT
    CASE  -- for the grouping of hosts in categories per number of listings owned
			WHEN host.host_city_listings_count = 1 THEN 'Single-listing Hosts'
			WHEN host.host_city_listings_count BETWEEN 2 AND 3 THEN '2-3 listing Hosts'
			WHEN host.host_city_listings_count BETWEEN 4 AND 9 THEN '4-9 listing Hosts'
			ELSE '10+ listing Hosts'
		END AS  hosts_group, COUNT(*) AS number_of_hosts,  SUM(l.num_listings) AS total_listings, 
	ROUND(SUM(num_listings) * 100.0 / SUM(SUM(num_listings)) OVER (), 2) || '%' AS percentage_of_listings,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) || '%' AS percentage_of_hosts
FROM  host
JOIN (
    SELECT host_id_fk, COUNT(*) AS num_listings
    FROM listing
    GROUP BY host_id_fk
) AS l
ON host.host_id = l.host_id_fk
GROUP BY hosts_group
ORDER BY number_of_hosts DESC;


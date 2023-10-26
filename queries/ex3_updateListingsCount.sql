-- find which host_ids have an issue with calculated_host_listings_count after data cleaning
SELECT host_id, calculated_host_listings_count, COUNT(*) AS occurrences, calculated_host_listings_count - COUNT(*) as diff
FROM cleaned_listings
GROUP BY host_id, calculated_host_listings_count
HAVING COUNT(*) <> calculated_host_listings_count;
-- this returns some rows, if we re-run it after the update, no rows are returned so the issue is fixed

--- update rows appropriately to have the correct calculated_host_listings_count
UPDATE cleaned_listings
SET calculated_host_listings_count = calculated_host_listings_count - 1
WHERE host_id IN (
    SELECT host_id
	FROM cleaned_listings
	GROUP BY host_id, calculated_host_listings_count
	HAVING COUNT(*) <> calculated_host_listings_count
);
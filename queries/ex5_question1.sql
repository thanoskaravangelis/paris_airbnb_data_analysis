--- Question 1
--A. If we want to count how many listings were introduced each year and calculate the average price of the listings introduced only in that year
SELECT first_review_year, COUNT(*) AS new_listings, AVG(price) as average_price
FROM listing
GROUP BY first_review_year
ORDER BY first_review_year;

--B. If we want to calculate the average price of the listings introduced up to that year
SELECT
   first_review_year,
   (
        SELECT COUNT(*)
        FROM listing AS sub
        WHERE sub.first_review_year <= main.first_review_year
    ) AS number_of_listings,
    (
        SELECT AVG(price)
        FROM listing AS sub
        WHERE sub.first_review_year <= main.first_review_year
    ) AS cumulative_avg_price_$
FROM listing AS main
GROUP BY first_review_year
ORDER BY first_review_year;

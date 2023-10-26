-- Split the date into separate columns (day, month, year)
ALTER TABLE cleaned_listings
ADD COLUMN first_review_day INTEGER;
ALTER TABLE cleaned_listings
ADD COLUMN first_review_month INTEGER;
ALTER TABLE cleaned_listings
ADD COLUMN first_review_year INTEGER;

-- Update the new columns with values from the original date column
UPDATE cleaned_listings
SET
  first_review_year = CAST(substr(first_review, 1, 4) AS INTEGER),
  first_review_month = CAST(substr(first_review, 6,7) AS INTEGER),
  first_review_day = CAST(substr(first_review, 9,10) AS INTEGER);

-- Drop the original date column
ALTER TABLE cleaned_listings
DROP COLUMN first_review;
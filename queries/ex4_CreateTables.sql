-- Create the tables with the proper order
CREATE TABLE host (
	host_id  INTEGER PRIMARY KEY,
	host_city_listings_count INTEGER
);

CREATE TABLE neighbourhood (
	n_id INTEGER PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE listing (
	id TEXT PRIMARY KEY,
	host_id_fk INTEGER NOT NULL,
	n_id_fk INTEGER NOT NULL,
	price REAL,
	first_review_year INTEGER,
	minimum_nights INTEGER,
	number_of_reviews_ltm INTEGER,
	FOREIGN KEY (host_id_fk)
			REFERENCES host (host_id)
	FOREIGN KEY (n_id_fk)
			REFERENCES neighbourhood (n_id)
);


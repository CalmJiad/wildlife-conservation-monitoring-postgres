-- Active: 1748170685337@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db

CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
)

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50)
)

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(50) NOT NULL,
    notes VARCHAR(100)
)

INSERT INTO rangers(name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range')

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

SELECT * FROM rangers;
SELECT * FROM sightings;

-- Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers(name, region) VALUES
('Derek Fox', 'Coastal Plains')

--Count unique species ever sighted.
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- Find all sightings where the location includes "Pass".
SELECT * FROM sightings
    WHERE location ILIKE '%pass%';

-- List each ranger's name and their total number of sightings.
SELECT
    r.name, COUNT(sightings.ranger_id) AS total_sightings
FROM
    rangers AS r
JOIN 
    sightings 
ON 
    r.ranger_id = sightings.ranger_id
GROUP BY 
    r.name
ORDER BY
    r.name ASC;

--List species that have never been sighted.
SELECT s.common_name
FROM species s
WHERE s.species_id NOT IN (
    SELECT species_id FROM sightings
);

-- Show the most recent 2 sightings
SELECT
    s.common_name,
    si.sighting_time,
    r.name
FROM
    sightings si
JOIN
    species s ON si.species_id = s.species_id
JOIN
    rangers r ON si.ranger_id = r.ranger_id
ORDER BY
    si.sighting_time DESC
LIMIT 2;

-- Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    EXTRACT(YEAR FROM discovery_date) < 1800

SELECT * FROM species

-- Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
CREATE VIEW sightings_with_day_time AS
SELECT
  sighting_id,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) <= 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;

SELECT * FROM sightings_with_day_time

-- Delete rangers who have never sighted any species
SELECT * FROM rangers

DELETE FROM rangers
WHERE
    rangers.ranger_id NOT IN(
        SELECT ranger_id FROM sightings
    )

SELECT * FROM rangers












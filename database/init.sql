-- 1. CONTINENTS TABLE
CREATE TABLE continents (
                            id SERIAL PRIMARY KEY,
                            name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. COUNTRIES TABLE
-- Each country belongs to ONE continent
CREATE TABLE countries (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100) NOT NULL UNIQUE,
                           continent_id INT NOT NULL,
                           population BIGINT NOT NULL DEFAULT 0,
                           area_km2 DECIMAL(12, 2) NOT NULL,       -- area in square kilometers
                           CONSTRAINT fk_continent
                               FOREIGN KEY (continent_id) REFERENCES continents(id)
                                   ON DELETE RESTRICT
);


-- 3. PEOPLE TABLE
CREATE TABLE people (
                        id SERIAL PRIMARY KEY,
                        first_name VARCHAR(100) NOT NULL,
                        last_name VARCHAR(100) NOT NULL
);

-- 4. PERSON_CITIZENSHIP (Junction table — many-to-many)
-- One person can belong to multiple countries
CREATE TABLE person_citizenship (
                                    person_id INT NOT NULL,
                                    country_id INT NOT NULL,
                                    PRIMARY KEY (person_id, country_id),
                                    CONSTRAINT fk_person
                                        FOREIGN KEY (person_id) REFERENCES people(id)
                                            ON DELETE CASCADE,
                                    CONSTRAINT fk_country
                                        FOREIGN KEY (country_id) REFERENCES countries(id)
                                            ON DELETE CASCADE
);

--Write SQL queries to find the following data about countries:--
--1. Country with the biggest population (id and name of the country)
Select id,name from countries order by population Desc LIMIT 1;

--2. Top 10 countries with the lowest population density (names of the countries)
select name from countries order by (population/area_km2) Limit (10);

--3. Countries with population density higher than average
select name from countries where(population/area_km2) >
                                (select avg(countries.population/countries.area_km2) from countries);

-- 4. Country with the longest name (show all if tie)
SELECT name
FROM countries
WHERE LENGTH(name) = (
    SELECT MAX(LENGTH(name))
    FROM countries
);

-- 5. All countries with name containing letter "F", sorted alphabetically
SELECT name
FROM countries
WHERE name ILIKE '%f%'
ORDER BY name ASC;

-- 6. Country with population closest to the average population
SELECT id, name, population
FROM countries
ORDER BY ABS(population - (SELECT AVG(population) FROM countries)) ASC
    LIMIT 1;

--Section 2 — Countries & Continents Queries
-- 1. Count of countries for each continent
SELECT co.name AS continent, COUNT(c.id) AS country_count
FROM continents co
         LEFT JOIN countries c ON c.continent_id = co.id
GROUP BY co.name
ORDER BY country_count DESC;

-- 2. Total area for each continent, sorted biggest to smallest
SELECT co.name AS continent, SUM(c.area_km2) AS total_area
FROM continents co
         JOIN countries c ON c.continent_id = co.id
GROUP BY co.name
ORDER BY total_area DESC;

-- 3. Average population density per continent
SELECT co.name AS continent,
       ROUND(AVG(c.population / c.area_km2), 2) AS avg_density
FROM continents co
         JOIN countries c ON c.continent_id = co.id
GROUP BY co.name
ORDER BY avg_density DESC;

-- 4. For each continent, find country with the smallest area
SELECT co.name AS continent, c.name AS country, c.area_km2
FROM countries c
         JOIN continents co ON co.id = c.continent_id
WHERE c.area_km2 = (
    SELECT MIN(c2.area_km2)
    FROM countries c2
    WHERE c2.continent_id = c.continent_id
)
ORDER BY co.name;

-- 5. Continents where average country population is less than 20 million
SELECT co.name AS continent,
       ROUND(AVG(c.population), 0) AS avg_population
FROM continents co
         JOIN countries c ON c.continent_id = co.id
GROUP BY co.name
HAVING AVG(c.population) < 20000000
ORDER BY avg_population ASC;


--Section 3 — People Queries
-- 1. Person with the biggest number of citizenships
SELECT p.id, p.first_name, p.last_name, COUNT(pc.country_id) AS citizenship_count
FROM people p
         JOIN person_citizenship pc ON pc.person_id = p.id
GROUP BY p.id, p.first_name, p.last_name
ORDER BY citizenship_count DESC
    LIMIT 1;

-- 2. All people who have no citizenship
SELECT p.id, p.first_name, p.last_name
FROM people p
         LEFT JOIN person_citizenship pc ON pc.person_id = p.id
WHERE pc.country_id IS NULL;

-- 3. Country with the least people in People table
SELECT c.id, c.name, COUNT(pc.person_id) AS people_count
FROM countries c
         JOIN person_citizenship pc ON pc.country_id = c.id
GROUP BY c.id, c.name
ORDER BY people_count ASC
    LIMIT 1;

-- 4. Continent with the most people in People table
SELECT co.name AS continent, COUNT(pc.person_id) AS people_count
FROM continents co
         JOIN countries c ON c.continent_id = co.id
         JOIN person_citizenship pc ON pc.country_id = c.id
GROUP BY co.name
ORDER BY people_count DESC
    LIMIT 1;

-- 5. Pairs of people with the same first name (print 2 ids and the name)
SELECT p1.id AS person1_id, p2.id AS person2_id, p1.first_name AS name
FROM people p1
         JOIN people p2 ON p1.first_name = p2.first_name
    AND p1.id < p2.id
ORDER BY p1.first_name;
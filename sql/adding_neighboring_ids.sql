-- This query selects the metadata of 2021 and adds two new attributes:
-- close_meta20_id: metadata.id of the closest station in 2020
-- close_meta19_id: metadata.id of the closest station in 2019
--
-- Uncomment the follwoing two lines to persist this query as a VIEW
-- DROP VIEW IF EXISTS meta21;
-- CREATE VIEW meta21 AS
-- From here, it's only a single SQL statement
WITH meta21 AS (
	SELECT *, 
	(SELECT id FROM metadata ly WHERE term_id=9 ORDER BY st_distance(m.location, ly.location) ASC LIMIT 1) as close_meta20_id,
	(SELECT id FROM metadata ly WHERE term_id=7 ORDER BY st_distance(m.location, ly.location) ASC LIMIT 1) as close_meta19_id
	FROM metadata m
	WHERE term_id=11 AND sensor_id=1
	)
-- This is your main SELECT. You can adapt and add joins etc.
SELECT * 
FROM meta21

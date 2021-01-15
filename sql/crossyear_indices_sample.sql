-- This script is further enhancing shift_data_series.sql
-- In adds a measurement_index to the 'normalized' temperature values
-- and calculates two indices based on this data.
-- 
--
DROP VIEW IF EXISTS data_norm;
CREATE VIEW data_norm AS
-- From here, it's only a single SQL statement
SELECT
	row_number() OVER (PARTITION BY meta_id, variable_id ORDER BY tstamp ASC) as measurement_index,
	*,
	value - avg(value) OVER (PARTITION BY meta_id, variable_id) AS norm,
	avg(value) OVER (PARTITION BY meta_id, variable_id) AS group_avg	
FROM data;

-- HERE we run a different query that can now calculate all, or a part of the needed indices
-- before you just copy & paste this as a solution, make sure you understand the assumptions
-- underlying my code.
WITH indices AS (  
	SELECT 
		meta21.id, 								-- get the id, i.e. for joins
		avg(d.value) AS "mean",					-- just the mean
		corr(d.norm, d20.norm) AS "Tcorr1Y"		-- my solution of the Tcoo1Y index, adjust it as needed
	FROM data_norm d							-- we select from data_norm, not metadata!							
	JOIN meta21 on meta21.id = d.meta_id		-- see adding_neighboring_ids.sql
	JOIN metadata m20 on meta21.close_meta20_id=m20.id
	-- please be sure you understand the implications of the following line, 
	-- if you use the query like this, you need to explain what you did in the SQL report.
	JOIN data_norm d20 on m20.id=d20.meta_id AND d.measurement_index=d20.measurement_index
	GROUP BY meta21.id
)
 -- by splitting this into a WITH and a SELECT from the WITH, we can organize the code
 -- a bit better. WITH xxx AS () SELECT * FROM xx; is still a single statement!
SELECT * FROM indices
JOIN metadata on indices.id=metadata.id

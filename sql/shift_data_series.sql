-- This query demonstrates how a partition can be used to calculate new 
-- attributes based on just a part of the underlying data.
-- This view does only the shift to 0, not the scaling by variance. 
-- You can add more attributes if you want to do that as well. 
-- It adds two new attributes:
-- norma: This is the deviation to the time series mean value
-- group_avg: This is the time series average, can be used to validate
--
-- Uncomment the follwoing two lines to persist this query as a VIEW
-- DROP VIEW IF EXISTS data_norm;
-- CREATE VIEW data_norm AS
-- From here, it's only a single SQL statement
SELECT 
	*,
	value - avg(value) OVER (PARTITION BY meta_id, variable_id) AS norm,
	avg(value) OVER (PARTITION BY meta_id, variable_id) AS group_avg	
FROM data;

-- You can now i.e. aggreate the norm values. they should be very close to 0
-- SELECT meta_id, abs(avg(norm)) < 0.001 AS is_valid  
-- FROM data_norm
-- GROUP BY meta_id

SELECT 
	m.device_id,
	avg(value) as mean,
	min(value) as min,
	max(value) as max
FROM data d
JOIN metadata m ON m.id=d.meta_id
WHERE 
	variable_id=1 AND
	date_part('day', tstamp)=24 AND date_part('month', tstamp)=12
GROUP BY m.device_id

-- Template for creating the final view
DROP VIEW IF EXISTS temperature_indices;
CREATE VIEW temperature_indices AS
    SELECT * FROM metadata;
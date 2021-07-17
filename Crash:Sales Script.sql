-- Import data

SELECT *
FROM NHTSA_Crash_Data_csv

SELECT *
FROM Car_Sales_Data_csv csd


-- Separate Make & Model from 'Model' column in Sales Data

SELECT UPPER(SUBSTRING(Model, 1, LOCATE(' ', Model) -1)) AS VehicleMake, UPPER(SUBSTRING(Model, LOCATE(' ', Model) + 1, LENGTH(Model))) as VehicleModel
FROM Car_Sales_Data_csv csd


-- Adding Separated values to Table

ALTER TABLE Car_Sales_Data_csv
ADD VehicleMake varchar(255)

UPDATE Car_Sales_Data_csv
SET VehicleMake = UPPER(SUBSTRING(Model, 1, LOCATE(' ', Model) -1))
WHERE VehicleMake <> ''


ALTER TABLE Car_Sales_Data_csv
ADD VehicleModel varchar(255)

UPDATE Car_Sales_Data_csv
SET VehicleModel = UPPER(SUBSTRING(Model, LOCATE(' ', Model) + 1, LENGTH(Model)))
WHERE VehicleModel <> ''


-- Remove original Model column

ALTER TABLE Car_Sales_Data_csv
DROP COLUMN Model


-- Join Crash Data & Sales Data on Vehicle Make & Model

SELECT *
FROM Car_Sales_Data_csv
INNER JOIN NHTSA_Crash_Data_csv ncdc
ON ncdc.VehicleMake = Car_Sales_Data_csv.VehicleMake
AND ncdc.VehicleModel = Car_Sales_Data_csv.VehicleModel
WHERE ncdc.VehicleModel <> '' AND (ncdc.`Max.CrushDistance_mm_` > 0 AND ncdc.`Max.CrushDistance_mm_` < 5000) 
ORDER BY Car_Sales_Data_csv.YTD DESC


-- Remove NULL Vales (Non-production vehicles) from Crash Data

Select *
FROM NHTSA_Crash_Data_csv
WHERE ModelYear >= 1 AND (`Max.CrushDistance_mm_` > 0 AND `Max.CrushDistance_mm_` < 5000)








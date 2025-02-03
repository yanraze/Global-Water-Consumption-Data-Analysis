-- Water Consumption by Country (2020)

--Rename Columns
/*
EXEC sp_rename 'WaterConsumptionbyCountry.WaterConsumption_AnnualWaterWithdrawal_billionm3_2020', 'TOTAL_WATER_WITHDRAWAL_(BILLION M3)', 'COLUMN';
EXEC sp_rename 'WaterConsumptionbyCountry.WaterConsumption_AnnualFreshwaterWithdrawal_billionm3_2020', 'TOTAL_FRESHWATER_WITHDRAWAL_(BILLION M3)', 'COLUMN';
EXEC sp_rename 'WaterConsumptionbyCountry.WaterConsumption_AnnualWaterWithdrawalPerCapita_m3_2020', 'TOTAL_WATER_WITHDRAWAL_PER_CAPITA_(M3)', 'COLUMN';
EXEC sp_rename 'WaterConsumptionbyCountry.WaterConsumption_PctOfWithdrawalUsedbyAgriculture_Pct_2020', '%_OF_TOTAL WITHDRAWAL_USED_BY_AGRICULTURE', 'COLUMN';
EXEC sp_rename 'WaterConsumptionbyCountry.WaterConsumption_PctOfWithdrawalUsedbyIndustry_Pct_2020', '%_OF_TOTAL_WITHDRAWAL_USED_BY_INDUSTRY', 'COLUMN';
EXEC sp_rename 'WaterConsumptionbyCountry.WaterConsumption_PctOfWithdrawalUsedbyMunicipalities_Pct_2020', '%_OF_TOTAL_WITHDRAWAL_USED_BY_MUNICIPALITIES', 'COLUMN';
GO
*/

--Transform NULL values to 0
/*
UPDATE WaterConsumptionbyCountry
SET 
    [TOTAL_WATER_WITHDRAWAL_(BILLION M3)] = COALESCE([TOTAL_WATER_WITHDRAWAL_(BILLION M3)], 0),
	[TOTAL_FRESHWATER_WITHDRAWAL_(BILLION M3)] = COALESCE([TOTAL_FRESHWATER_WITHDRAWAL_(BILLION M3)], 0),
	[TOTAL_WATER_WITHDRAWAL_PER_CAPITA_(M3)] = COALESCE([TOTAL_WATER_WITHDRAWAL_PER_CAPITA_(M3)], 0),
	[%_OF_TOTAL WITHDRAWAL_USED_BY_AGRICULTURE] = COALESCE([%_OF_TOTAL WITHDRAWAL_USED_BY_AGRICULTURE], 0),
	[%_OF_TOTAL_WITHDRAWAL_USED_BY_INDUSTRY] = COALESCE([%_OF_TOTAL_WITHDRAWAL_USED_BY_INDUSTRY], 0),
	[%_OF_TOTAL_WITHDRAWAL_USED_BY_MUNICIPALITIES] = COALESCE([%_OF_TOTAL_WITHDRAWAL_USED_BY_MUNICIPALITIES], 0)
*/

--Total World Water Consumption
SELECT SUM([TOTAL_WATER_WITHDRAWAL_(BILLION M3)]) AS [Total_World_Water_Consumption_(BILLION M3)]
FROM DAProject..WaterConsumptionbyCountry

--Total World Freshwater Consumption
SELECT SUM([TOTAL_FRESHWATER_WITHDRAWAL_(BILLION M3)]) AS [Total_World_Freshwater_Consumption_(BILLION M3)]
FROM DAProject..WaterConsumptionbyCountry

--Weighted Average of World's Water Consumption per Capita (m³/person)
SELECT ROUND(SUM(WaterConsumption.TotalWaterWithdrawal) / SUM(WaterConsumption.Estimated_Population), 2) AS WorldAvgWaterPerCapita_m3
FROM (
    SELECT 
        country,
        [TOTAL_WATER_WITHDRAWAL_(BILLION M3)] * 1000000000 AS TotalWaterWithdrawal,
        -- Assuming you have a population column; if not, calculate it as before
        CAST((CAST([TOTAL_WATER_WITHDRAWAL_(BILLION M3)] AS DECIMAL(18,2)) * 1000000000) / NULLIF(CAST([TOTAL_WATER_WITHDRAWAL_PER_CAPITA_(M3)] AS DECIMAL(18,2)), 0) AS BIGINT) AS Estimated_Population
    FROM DAProject..WaterConsumptionbyCountry
) AS WaterConsumption;

--Compute the population
--Water Consumption Per Capita = Total Water Consumption / Total Population
--Population = Total Water Consumption / Water Consumption Per Capita
SELECT country,
       CAST((CAST([TOTAL_WATER_WITHDRAWAL_(BILLION M3)] AS DECIMAL(18,2)) * 1000000000) / NULLIF(CAST([TOTAL_WATER_WITHDRAWAL_PER_CAPITA_(M3)] AS DECIMAL(18,2)), 0) AS BIGINT) AS Estimated_Population
FROM DAProject..WaterConsumptionbyCountry
ORDER BY Estimated_Population DESC;


SELECT *
FROM DAProject..WaterConsumptionbyCountry

-- Top 5 Water Consuming Countries
Select TOP(5)country,  [TOTAL_WATER_WITHDRAWAL_(BILLION M3)]
FROM DAProject..WaterConsumptionbyCountry
Order by  [TOTAL_WATER_WITHDRAWAL_(BILLION M3)] DESC

-- Top 5 Freshwater Consuming Countries
Select TOP(5)country,  [TOTAL_FRESHWATER_WITHDRAWAL_(BILLION M3)]
FROM DAProject..WaterConsumptionbyCountry
Order by  [TOTAL_FRESHWATER_WITHDRAWAL_(BILLION M3)] DESC

--Top 10 Countries with water used in Agriculture
Select TOP(10)country, [%_OF_TOTAL WITHDRAWAL_USED_BY_AGRICULTURE]
FROM DAProject..WaterConsumptionbyCountry
Order by [%_OF_TOTAL WITHDRAWAL_USED_BY_AGRICULTURE] DESC

--TOP 10 Countries with water used in Industry
Select TOP(10)country, [%_OF_TOTAL_WITHDRAWAL_USED_BY_INDUSTRY]
FROM DAProject..WaterConsumptionbyCountry
Order by [%_OF_TOTAL_WITHDRAWAL_USED_BY_INDUSTRY] DESC

--TOP 10 Countries with water used in Municipalities
Select TOP(10)country, [%_OF_TOTAL_WITHDRAWAL_USED_BY_MUNICIPALITIES]
FROM DAProject..WaterConsumptionbyCountry
Order by [%_OF_TOTAL_WITHDRAWAL_USED_BY_MUNICIPALITIES] DESC


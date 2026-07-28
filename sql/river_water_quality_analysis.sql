SELECT *
FROM river_quality;

-----------------------------------------------------------------------------------------------------------------------------

ALTER TABLE river_quality
CHANGE COLUMN
`Electric Conductivity (Î¼S/cm)`
`Electric Conductivity (uS/cm)` DOUBLE;

-----------------------------------------------------------------------------------------------------------------------------

SELECT
    COUNT(*) AS Total_Rivers,
    SUM(CASE WHEN `Overall Score` = 6 THEN 1 ELSE 0 END) AS Excellent_Rivers,
    SUM(CASE WHEN `Overall Score` <= 2 THEN 1 ELSE 0 END) AS Rivers_Needing_Attention,
    ROUND(AVG(`Overall Score`),2) AS Avg_Overall_Score,
    ROUND(AVG(`Biochemical Oxygen Demand (mg/L)`),2) AS Avg_BOD,
    ROUND(AVG(`Dissolved oxygen (mg/L)`),2) AS Avg_DO,
    ROUND(AVG(`Total Dissolved Solids (mg/L)`),2) AS Avg_TDS,
    ROUND(MAX(`Biochemical Oxygen Demand (mg/L)`),2) AS Highest_BOD,
    ROUND(MAX(`Iron(mg/L)`),2) AS Highest_Iron,
    ROUND(MAX(`Electric Conductivity (uS/cm)`),2) AS Highest_EC,
    SUM(CASE
            WHEN `Biochemical Oxygen Demand (mg/L)` > 3
            THEN 1
            ELSE 0
        END) AS BOD_Violations,
    SUM(CASE
            WHEN `Dissolved oxygen (mg/L)` < 5
            THEN 1
            ELSE 0
        END) AS DO_Violations,
    SUM(CASE
            WHEN `Iron(mg/L)` > 0.3
            THEN 1
            ELSE 0
        END) AS Iron_Violations,
    SUM(CASE
            WHEN `Total Dissolved Solids (mg/L)` > 500
            THEN 1
            ELSE 0
        END) AS TDS_Violations
FROM river_quality;

---------------------------------------------------------------------------------------------------------------------------

SELECT
    River,
    ROUND(AVG(`Overall Score`),2) AS Avg_Overall_Score,
    ROUND(AVG(`Biochemical Oxygen Demand (mg/L)`),2) AS Avg_BOD,
    ROUND(AVG(`Dissolved oxygen (mg/L)`),2) AS Avg_DO,
    ROUND(AVG(`Total Dissolved Solids (mg/L)`),2) AS Avg_TDS,
    ROUND(AVG(`Electric Conductivity (uS/cm)`),2) AS Avg_EC,
    ROUND(AVG(`Iron(mg/L)`),2) AS Avg_Iron,
    SUM(
        CASE
            WHEN `Biochemical Oxygen Demand (mg/L)` > 3 THEN 1
            ELSE 0
        END
    ) AS BOD_Violations,
    SUM(
        CASE
            WHEN `Dissolved oxygen (mg/L)` < 5 THEN 1
            ELSE 0
        END
    ) AS DO_Violations,
    SUM(
        CASE
            WHEN `Total Dissolved Solids (mg/L)` > 500 THEN 1
            ELSE 0
        END
    ) AS TDS_Violations,
    SUM(
        CASE
            WHEN `Iron(mg/L)` > 0.3 THEN 1
            ELSE 0
        END
    ) AS Iron_Violations
FROM river_quality
GROUP BY River
ORDER BY Avg_Overall_Score DESC;

-----------------------------------------------------------------------------------------------------------------------------

SELECT
    River,
    `Overall Score`,
    DENSE_RANK() OVER(
        ORDER BY `Overall Score` DESC
    ) AS River_Rank,
    CASE
        WHEN `Biochemical Oxygen Demand (mg/L)` <= 3
        THEN 'Pass'
        ELSE 'Fail'
    END AS BOD_Status,
    CASE
        WHEN `Dissolved oxygen (mg/L)` >= 5
        THEN 'Pass'
        ELSE 'Fail'
    END AS DO_Status,
    CASE
        WHEN `Iron(mg/L)` <= 0.3
        THEN 'Pass'
        ELSE 'Fail'
    END AS Iron_Status,
    CASE
        WHEN `Overall Score` = 6 THEN 'Excellent'
        WHEN `Overall Score` >= 4 THEN 'Good'
        ELSE 'Poor'
    END AS Water_Quality
FROM river_quality
ORDER BY River_Rank;

-----------------------------------------------------------------------------------------------------------------------------

SELECT
    River,
    CASE
        WHEN `Biochemical Oxygen Demand (mg/L)` > 3
        THEN 'Yes'
        ELSE 'No'
    END AS BOD_Violation,
    CASE
        WHEN `Dissolved oxygen (mg/L)` < 5
        THEN 'Yes'
        ELSE 'No'
    END AS DO_Violation,
    CASE
        WHEN `Iron(mg/L)` > 0.3
        THEN 'Yes'
        ELSE 'No'
    END AS Iron_Violation,
    CASE
        WHEN `Total Dissolved Solids (mg/L)` > 500
        THEN 'Yes'
        ELSE 'No'
    END AS TDS_Violation,
    CASE
        WHEN `Electric Conductivity (uS/cm)` > 1500
        THEN 'Yes'
        ELSE 'No'
    END AS EC_Violation
FROM river_quality;

-----------------------------------------------------------------------------------------------------------------------------

SELECT
    River,
    `Overall Score`,
    `Biochemical Oxygen Demand (mg/L)`,
    `Dissolved oxygen (mg/L)`,
    `Iron(mg/L)`,
    DENSE_RANK() OVER(
        ORDER BY `Overall Score` DESC
    ) AS Rank_Position
FROM river_quality
ORDER BY Rank_Position;

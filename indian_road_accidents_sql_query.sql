USE road_accidents_db;
SHOW TABLES;
select * from sample_accidents limit 10;

# 1. Total Accidents by State
select state,count(*) as total_accidents from sample_accidents group by state order by total_accidents ;

#2.Top 5 Cities with Most Accidents
select city, count(*) as most_accidents from sample_accidents group by city order by most_accidents desc limit 5;

#3. Average Risk Score by Weather
select weather, round(avg(risk_score),2) as average_risk_score from sample_accidents group by weather order by average_risk_score;

#4. Total Casualties by Accident Cause
select cause,sum(casualties) as total_casualties from sample_accidents group by cause order by total_casualties;

#5. States Having More Than 200 Accidents
select state, count(*) as accident_count from sample_accidents group by state having accident_count > 200;

#6. Fatal Accident Percentage
select round(sum(case when accident_severity = 'fatal' then 1 else 0 end) *100,2) / count(*) as accident_percentage from sample_accidents;

#7. Peak Hour Analysis
select hour,count(*) as accidents from sample_accidents group by hour order by accidents desc;

#8. Rank States by Accident Count
SELECT state,
       COUNT(*) AS accidents,
       RANK() OVER
       (
           ORDER BY COUNT(*) DESC
       ) AS state_rank
FROM sample_accidents
GROUP BY state;

#9. Dense Rank Cities by Casualties
SELECT city,
       SUM(casualties) AS total_casualties,
       DENSE_RANK() OVER
       (
           ORDER BY SUM(casualties) DESC
       ) AS ranking
FROM sample_accidents
GROUP BY city;

#10. Top Risk State Using CTE
WITH state_risk AS
(
    SELECT state,
           AVG(risk_score) AS avg_risk
    FROM sample_accidents
    GROUP BY state
)

SELECT *
FROM state_risk
ORDER BY avg_risk DESC;

#11. Month-wise Accident Trend
SELECT month,
       COUNT(*) AS accidents
FROM sample_accidents
GROUP BY month
ORDER BY accidents DESC;

#12. Compare Monthly Accidents
WITH monthly_data AS
(
SELECT month,
       COUNT(*) AS accidents
FROM sample_accidents
GROUP BY month
)

SELECT *,
       LAG(accidents)
       OVER(ORDER BY month) AS previous_month
FROM monthly_data;

#13. Forecast Next Month Pattern
WITH monthly_data AS
(
SELECT month,
       COUNT(*) AS accidents
FROM sample_accidents
GROUP BY month
)

SELECT *,
       LEAD(accidents)
       OVER(ORDER BY month) AS next_month
FROM monthly_data;

#14. State Contributing Highest Casualties
SELECT *
FROM
(
    SELECT state,
           SUM(casualties) AS total_casualties
    FROM sample_accidents
    GROUP BY state
) t
WHERE total_casualties =
(
    SELECT MAX(total_casualties)
    FROM
    (
        SELECT state,
               SUM(casualties) AS total_casualties
        FROM sample_accidents
        GROUP BY state
    ) x
);





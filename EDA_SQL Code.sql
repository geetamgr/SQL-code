-- EDA is perform to find trend, patterns and complex queries
USE cleaningdata;

SELECT * FROM layoff_stagging1;
 
SELECT MAX(total_laid_off)
FROM layoff_stagging1;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_stagging1;

SELECT * FROM layoff_stagging1
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT * FROM layoff_stagging1
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ALL TOGETHER SUM OFF TOTAL LAYOFF
-- Amazon has highest layoff with 18150
-- Google, Meta, Salesforce and Microsoft with 12000,11000,10090,10000 likewise

SELECT company, SUM(total_laid_off) SUM
FROM layoff_stagging1
GROUP BY company
ORDER BY 2 DESC
LIMIT 5;

-- Time period of layoff

SELECT MIN(`date`), MAX(`date`)
FROM layoff_stagging;

-- WHICH INDUSTRY HAS TOTAL LAYOFF
-- Customer industry has highest laid off

SELECT industry, SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY industry
ORDER BY 2 DESC;

-- Which counnrty has highest laid off
-- United States has highest layoff with 256559 total_laid_off. India,Netherlands,Sweden and Brazil slimulataneously.

SELECT country, SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY country
ORDER BY 2 DESC;

-- To check which date has highest layoff
-- 2022 has the highest layoff with 160661. 2023,2020,2021 with 125677, 80998 and 15823 respectively.

SELECT `date`, SUM(total_laid_off) AS SUM
FROM layoff_stagging1
GROUP BY `date`
ORDER BY 2 DESC;

SELECT YEAR (`date`), SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY YEAR (`date`)
ORDER BY 2 DESC;

-- to examine the total highest layoff in stage
-- POST-IPO has highest layoff after effect

SELECT stage, SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY stage
ORDER BY 2 DESC;

-- percentage_laid_off is not relevant because dont have total nuber of staff in company

SELECT company, SUM(percentage_laid_off) AS sum
FROM layoff_stagging1
GROUP BY company
ORDER BY 2 DESC;

-- Rolling total layoff

SELECT SUBSTRING(`date`, 6,2 ) AS `month`
FROM layoff_stagging1;

-- check total layoff by month
SELECT SUBSTRING(`date`, 6,2 ) AS date, SUM(total_laid_off) SUM  
FROM layoff_stagging1
GROUP BY date;

-- Check total layoff by year and month 
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) SUM
FROM layoff_stagging1
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;

-- Rolling total to check the total layoff in year all together
-- After rolling total laid we have 2020-03 with 9628 begin layoff and 2020-12 by 80998 total layoff in year.
-- 2022-05 to 2022-08 has lighest layoff
-- from 2020-2023 there is total 383159 layoff in world

WITH total_layoff AS
(
	SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
	FROM layoff_stagging1
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `month`
	ORDER BY 1 ASC
)
SELECT `month`, total_off, SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM total_layoff;

-- check the total layoff as per company

SELECT company, SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

-- Rank which year has highest layoff
-- Examing the highest laid of in year by a company for example amazon has layoff in 2022,2023,2024 we will check which year is highest layoff
-- Partition years and total layoff in that year to check who was the highest to layoff in the year 2022,2023,2024 with the help of DENSE_RANK() on company year

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_stagging1
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year (company, years,total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoff_stagging1
	GROUP BY company, YEAR(`date`)
), company_year_rank AS 
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
-- ORDER BY ranking ASC
)
SELECT * FROM company_year_rank
WHERE ranking<=5;




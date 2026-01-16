USE cleaningdata;

-- DATA CLEANING
-- step 1: create new schema
-- create new table, change data colum into datetime datatype, select next and finish.
-- DATA CLEANING INCLUDES
		 -- REMOVE THE DUPLICATE DATA
		 -- STANDARDIZE THE DATA (CORRECT SPELLING)
		 -- NULL VALUES OR BLANK VALUES
		 -- REMOVE ANY COLUMN OR ROWS
         
         
SELECT * FROM layoffs;

CREATE TABLE layoff_stagging
LIKE layoffs;

INSERT layoff_stagging
SELECT * FROM layoffs;

SELECT * FROM layoff_stagging;

-- to check if the row number is unique
-- filter row number if its unique

SELECT *,
 ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_ofF, percentage_laid_off, `date`) AS row_num
FROM layoff_stagging;

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_ofF, percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_stagging
)
SELECT * FROM duplicate_CTE
WHERE row_num>1;

-- cross check with value if the row is duplicate by putting company = oda
-- keep the real one and delete the duplicate one

SELECT * FROM layoff_stagging
WHERE company = 'Casper';

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_ofF, percentage_laid_off, `date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_stagging
)
DELETE  FROM duplicate_CTE
WHERE row_num > 1;


CREATE TABLE `layoff_stagging1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * FROM layoff_stagging1;

INSERT INTO layoff_stagging1
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoff_stagging;

SELECT * FROM layoff_stagging1
WHERE row_num > 1;

DELETE FROM layoff_stagging1
WHERE row_num > 1;

-- STANDARDDIZING DATA (find issue and fix data)

SELECT DISTINCT (TRIM(company))
FROM layoff_stagging1;

SELECT company, TRIM(company)
FROM layoff_stagging1;

UPDATE layoff_stagging1
SET company = TRIM(company);


SELECT DISTINCT industry
FROM layoff_stagging1
ORDER BY 1 ;

SELECT * FROM layoff_stagging1
WHERE industry LIKE'Crypto%';

UPDATE layoff_stagging1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT * FROM layoff_stagging1;

SELECT DISTINCT location 
FROM layoff_stagging1
ORDER BY 1;


SELECT DISTINCT country 
FROM layoff_stagging1
ORDER BY 1;

SELECT * FROM layoff_stagging1
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING'.' FROM country)
FROM layoff_stagging1
ORDER BY 1;

UPDATE layoff_stagging1
SET country = TRIM(TRAILING'.' FROM country)
WHERE country LIKE 'United States%';

SELECT * FROM layoff_stagging1;

-- To do time series visualization we have to change date into DATE datatype.
-- to change data type use STR_TO_DATE('column','format')


SELECT `date`, STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoff_stagging1;

UPDATE layoff_stagging1
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date` FROM layoff_stagging1;

-- Do alter table on new one not in actual table

ALTER TABLE layoff_stagging1
MODIFY COLUMN `date` DATE;

-- Work with NULL values to remove

SELECT * FROM layoff_stagging1
WHERE total_laid_off IS  NULL
AND percentage_laid_off IS  NULL;

SELECT DISTINCT industry
FROM layoff_stagging1;

SELECT * FROM layoff_stagging1
WHERE industry IS NULL
OR industry = '';

-- check if you can populate data
 
 SELECT * FROM layoff_stagging1 
 WHERE company = 'Airbnb';

SELECT * FROM layoff_stagging1 t1
JOIN layoff_stagging1 t2
  ON t1. company = t2.company
  AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM layoff_stagging1 t1
JOIN layoff_stagging1 t2
  ON t1.company= t2.company
  WHERE(t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;

UPDATE layoff_stagging1
SET industry = NULL
WHERE industry = '';

UPDATE layoff_stagging1 t1
JOIN layoff_stagging1 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * FROM layoff_stagging1
WHERE company LIKE 'Bally%';

-- Delete data if only 100% confident
-- We are unable to populate data in total laid off and percentage laid off because we dont have total laid off

SELECT * FROM layoff_stagging1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoff_stagging1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoff_stagging1;

ALTER TABLE layoff_stagging1
DROP COLUMN row_num;











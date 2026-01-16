# SQL-code
--Data cleaning using SQL CODE

--Perform data cleaning using MYSQL Workbench 
-- Create table layoff_stagging

--DATA cleaning steps follows
     -- Remove Duplicates
     -- Strandardize the data 
     -- Null values or Blank values
     -- Remove any columns or row.
     
1. To remove duplicates
   - at first create an new table where raw data wont be affected.
   - windows function like ROW_NUMBER() is used to find any duplicates row as an data and remove from the table
   - Used  CTEs for easy understanding of code
   - DELETE query is used to remove duplicate, which have row_num 1.
  
2. Standardizing the data
   - Different string function used to correct the spelling of data
   - TRIM() used in company with DISTINCT data
   - LIKE statement been used with % property
   - Country column is change with remove using TRIM(TRAILING '.' FROM country)
   - UPDATE query is used to update the data on table
   - Change `date` datatype into DATE using STR_TO_DATE('column', 'formatlike: %,/%d/%Y')
   - Also ALTER table to MODIFY COLUMN `date` with DATE datatype.

3. Delete Null values and Blank Values
     - Industry column is populate with similar data, with the help of company column where JOIN and WHERE clause is been used
     - In the column like total_laid_off and percentage_laid_off null data are present which cant be populated also range and funds columns are unable to populate in this scenario

4. Remove unnecesay column
    - we have created new column row_num in find duplicate which is drop using ALTER table DROP COLUMN
  
Now, the data is ready to be used to perform EDA in next project.

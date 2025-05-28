-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Create a duplicate table (to preserve raw dataset)
-- 2. Remove Duplicates
-- 3. Standardize the Data
-- 4. Null Values or Blank Values
-- 5. Remove unnecessary rows or columns


-- 1. Create a duplicate table
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- 2. Remove Duplicates
-- partition by every column to ensure accuracy
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;											-- bacK ticks ``, used for date column because date is a key word in MySQL

-- row_num > 1 indicates the duplicate rows 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- confirm that they are actual duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- Create another layoff_staging table to delete the duplicate rows (right click on  table > copy to clipboard > create statement > paste)

CREATE TABLE `layoffs_staging2` (
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


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER () OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Always recommended to write a select statement first to see what you're deleting
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Delete rows with row_num > 1 that indicate duplicate rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- NB: If MySQL is preventing you from deleting or updating rows, go to Preferences > SQL editor > uncheck the Safe Updates. 
-- After unchecking the Safe updates mode, you don't have to restart MySQL;
-- Go to Query on the top left side of your window then select reconnect to server and then run your query.

SELECT *
FROM layoffs_staging2;

-- 3. Standardize the Data (find the issues (unwanted spaces, unwanted characters, etc) in your data and fix them)

SELECT company, TRIM(company)		
FROM layoffs_staging2;					-- Remove unwanted spaces from company column

UPDATE layoffs_staging2				
SET company = TRIM(company);			-- update company column with Trimmed column


SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;						-- ORDER BY 1 means "order the results by the first column in the SELECT statement."

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- update 'Crypto', 'Crypto Currency' and 'CryptoCurrency' as 'Crypto' in industry column
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';			

SELECT DISTINCT(industry)		
FROM layoffs_staging2
ORDER BY 1;						-- View your changes

-- Check location column
SELECT DISTINCT(location)		
FROM layoffs_staging2
ORDER BY 1;							-- All good

-- Check country column
SELECT DISTINCT(country)		
FROM layoffs_staging2
ORDER BY 1;

-- Remove '.' from 'United States.'
SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country)		
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';				-- Update country column for United States

SELECT *
FROM layoffs_staging2;

-- Change the `date` column fromat from text to date 
-- (Column data-type will still be text after this - click on date column on SCHEMAS to check)
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;					-- Follow same date arrangement when writing format


UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modify `date` column data-type from TEXT to DATE 
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;			-- Column data-type will change - click on date column on SCHEMAS to check

SELECT *
FROM layoffs_staging2;

-- 4. Null Values and Blank Values
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NOT NULL;

-- Join the table on itself to get the NULL and NOT NULL outputs side by side 
-- to compare and populate the missing values

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Isolate affected column (industry)
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;						-- Did not update at first

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';								-- Update blank rows with 'null'

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;					-- NULL rows for industry column are populated with corresponding company names

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';			-- This row has no similar row based on company column to populate the industry null value with

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete the null rows for total_laid_off and percentage_laid_off
-- (Be careful when deleting data and be absolutely sure that they are not relevant)
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- 5. Remove unnecessary rows or columns

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;				-- Delete the row_num column

-- Date Format
SELECT `date`,
STR_TO_DATE(`date`, '%Y/%m/%d')
FROM layoffs_staging2;

SELECT `date`, DATE_FORMAT(`date`, '%d-%m-%Y') AS formatted_date
FROM layoffs_staging2;


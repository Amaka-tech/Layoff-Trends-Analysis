-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Maximum total layoffs and percentage layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Company with the most percentage layoffs based on hierarchy of funding 
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;			-- 1 represents 100%

-- Top 5 companies with the most layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC LIMIT 5;

-- The start and end dates of data collected
SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;

-- What industry had the most layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Which country had the most layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- What year had the most layoffs
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT *
FROM layoffs_staging2;

-- Different stages of the Companies when layoffs took place
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling Totals of Layoffs 
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;					-- Extracted the year and month of each date with SUBSTRING func. 
								-- 1 = start position, 7 = end pos. counting from left to right

-- Use CTE for Rolling Total
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;												-- SUM(total_off) OVER(ORDER BY `MONTH`) performs the rolling total by each month
																-- Rolling_Total becomes reference temporary table for CTE

-- Companies with most layoffs with corresponding year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 companies with the highest layoffs per year
-- Use 2 CTEs for ranking

WITH Company_Year (company, years, total_layoffs) AS				-- company, years, total_layoffs are Column aliases for company, YEAR(`date`), SUM(total_laid_off)
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Ranking AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_layoffs DESC) AS company_ranking
FROM Company_Year																					-- Used the first CTE to create the 2nd CTE
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Ranking
WHERE company_ranking <= 5;							-- Queried off of 2nd CTE to filter to Top 5 rankings

-- Average percentage layoffs for each company
SELECT company, ROUND(AVG(percentage_laid_off), 2)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Average percentage layoffs for companies in different stages
SELECT stage, ROUND(AVG(percentage_laid_off), 2)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- Rolling Total Alternative Approach 
-- Use Window function 
SELECT 
	DISTINCT SUBSTRING(date,1,7) as Month, 
    SUM(total_laid_off) OVER(PARTITION BY SUBSTRING(date, 1,7)) as total_layoffs,		-- calculates the total number of layoffs per month.
    SUM(total_laid_off) OVER(ORDER BY SUBSTRING(date, 1,7)) as layoffs_rolling			-- calculates a cumulative (rolling) sum of layoffs, ordered by month.
FROM 
    layoffs_staging2
WHERE 
     SUBSTRING(date,1,7) IS NOT NULL
ORDER BY 1;






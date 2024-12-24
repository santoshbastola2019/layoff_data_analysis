-- Exploratory Data Analysis


-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!


SELECT * 
FROM world_layoffs.layoffs_staging2;

-- EASIER QUERIES
SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Looking at percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of the company laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off=1;

-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

-- Somewhat tougher and mostly using GROUP BY
-- Companies with the biggest single layoff
Select company,totaL_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY 2 DESC
LIMIT 5;
-- now that's just on a single day

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- TOUGHER QUERIES------------------------------------------------------------------------------------------------------------------------------------

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at 

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as month,SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY month
ORDER BY month; 

WITH Rolling_Total AS(
SELECT SUBSTRING(date,1,7) as month,SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY month
ORDER BY month
)
SELECT month,total_laid_off,SUM(total_laid_off) OVER(ORDER BY month) AS rolling_total_layoffs
FROM Rolling_Total
;


-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at 


SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`) ,SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC
;

WITH Company_Year(company,years,total_laid_off) AS(
SELECT company, YEAR(`date`) ,SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company,YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5
;


;



















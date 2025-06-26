-- Топ-5 днів за рівнем ROMI загалом (включаючи Google та Facebook)
WITH combined_data AS (
	SELECT
		ad_date,
		value,
		spend,
		'Facebook' AS ad_source
	FROM public.facebook_ads_basic_daily fabd
	UNION ALL 
	SELECT
		ad_date,
		value,
		spend,
		'Google' AS ad_source
	FROM public.google_ads_basic_daily gabd
)
SELECT
	ad_date,
	ROUND(1.0 * COALESCE(SUM(value), 0) / NULLIF(SUM(spend), 0) * 100, 2) AS romi
	FROM combined_data
	GROUP BY ad_date
	HAVING sum(spend) > 0
	ORDER BY romi DESC
	LIMIT 5;
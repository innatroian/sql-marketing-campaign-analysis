-- Середнє, мінімум і максимум для щоденних витрат по Google та Facebook окремо
WITH facebook_spend AS (
	SELECT 
		ad_date,
		'Facebook Ads' AS media_source,
		ROUND(AVG(spend),2) AS avg_spend,
		MIN(spend) AS min_spend,
		MAX(spend) AS max_spend
	FROM public.facebook_ads_basic_daily fabd 
	GROUP BY 
		ad_date
	)
, facebook_google_spend AS (
	SELECT * 
	FROM facebook_spend
	UNION ALL 
	SELECT 
		ad_date,
		'Google Ads' AS media_source,
		ROUND(AVG(spend),2) AS avg_spend,
		MIN(spend) AS min_spend,
		MAX(spend) AS max_spend
	FROM public.google_ads_basic_daily gabd 
	GROUP BY 
		ad_date
	)
SELECT 
	ad_date, 
	media_source, 
	avg_spend, 
	min_spend, 
	max_spend
FROM facebook_google_spend
ORDER BY 
	ad_date, 
	media_source;
--Назва та тривалість найдовшого безперервного (щоденного) показу adset_name (разом з Google та Facebook).
WITH all_ads_data AS (
	SELECT 
		ad_date, 
		adset_name,
		'Facebook' AS ad_source
	FROM public.facebook_ads_basic_daily AS fabd
	LEFT JOIN public.facebook_adset AS fa 
		ON fa.adset_id = fabd.adset_id
	UNION ALL
	SELECT 
		ad_date, 
		adset_name,
		'Google' AS ad_source
	FROM public.google_ads_basic_daily
)
, ad_set_days AS (
    SELECT DISTINCT
        ad_date,
        adset_name
    FROM all_ads_data
    WHERE ad_date IS NOT NULL 
        AND adset_name IS NOT NULL
)
, ranked_ad_set_days AS ( 
	SELECT 
		adset_name, 
		ad_date, 
		ROW_NUMBER() OVER (PARTITION BY adset_name ORDER BY ad_date) AS rn
	FROM ad_set_days
)
, grouped_data AS ( 
	SELECT 
		adset_name, 
		ad_date, 
		ad_date - INTERVAL '1 day' * rn AS group_date
	FROM ranked_ad_set_days
)
, all_streak AS (
	SELECT 
		adset_name, 
		MIN(ad_date) AS start_date, 
		MAX(ad_date) AS end_date, 
		COUNT(*) AS streak_length
	FROM grouped_data
	GROUP BY 
		adset_name, 
		group_date
)
SELECT 
	adset_name AS "Назва adset",
	start_date AS "Дата початку",
	end_date AS "Дата кінця",
	streak_length AS "Тривалість (днів)"
FROM all_streak
ORDER BY streak_length DESC
LIMIT 1;

--Кампанія, що мала найбільший приріст у охопленні місяць-до місяця
WITH all_ads_data AS (
	SELECT 
		ad_date,
        campaign_name,
        adset_name,
        reach,
        'Facebook' AS ad_source
	FROM public.facebook_ads_basic_daily fabd
	LEFT JOIN facebook_adset fa 
		ON fabd.adset_id = fa.adset_id
	LEFT JOIN public.facebook_campaign fc 
		ON fabd.campaign_id = fc.campaign_id
	UNION ALL 
	SELECT
		ad_date,
        campaign_name,
        adset_name,
        reach,
		'Google' AS ad_source
	FROM public.google_ads_basic_daily gabd
)
, monthly_reach_camp AS (
	SELECT 
		DATE_PART('year', ad_date) || '-' || DATE_PART('month', ad_date) AS ad_month,
		campaign_name,
		COALESCE(SUM(reach), 0) AS monthly_reach
	FROM all_ads_data
	GROUP BY 1, 2
)
SELECT 
	ad_month, 
	campaign_name, 
	monthly_reach,
	monthly_reach - COALESCE(LAG(monthly_reach)
		OVER (PARTITION BY campaign_name ORDER BY ad_month), 0) AS monthly_growth
FROM monthly_reach_camp
ORDER BY monthly_growth DESC
LIMIT 1;

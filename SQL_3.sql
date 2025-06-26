-- Компанія з найвищим рівнем загального тижневого value
WITH all_ads_data AS (
	SELECT
		ad_date,
        campaign_name,
        adset_name,
        value,
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
        value,
		'Google' AS ad_source
	FROM public.google_ads_basic_daily gabd
)
SELECT
	DATE_TRUNC('week', ad_date)::DATE AS week_start,
	campaign_name,
    SUM(value) AS weekly_value
FROM all_ads_data
GROUP BY 1, 2
HAVING SUM(value) > 0
ORDER BY weekly_value DESC 
LIMIT 1;
use mavenfuzzyfactory;

-- A.. ANALYZING TRAFFIC SOURCES
-- #############################################################################################################################################################################################################################################################
 -- finding from where the bulk of our website sessions are coming from.
 
 -- FINDING TOP TRAFFIC SOURCES

select 
	utm_source,
    utm_campaign,
    http_referer,
    count(distinct website_session_id) as sessions
from 
	website_sessions
where created_at < "2012-04-12"
group by utm_source, utm_campaign,http_referer
order by sessions desc;


/*
it seems like I should probably dig into gsearch nonbrand a bit deeper to see what we can do to optimize there, 
but I need to understand if those sessions are driving sales.

so first calculate the conversion rate (CVR) from session to order. Based on what I'm paying for clicks, 
I’ll need a CVR of at least 4% to make the numbers work. 
If we're much lower, we’ll need to reduce bids. If we’re higher, we can increase bids to drive more volume.
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRAFFIC CONVERSION RATES

select 
    count(distinct WS.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    round((count(o.order_id)/count(distinct WS.website_session_id))*100,2) AS SESSION_TO_ORDER_CNV_PERCENT
    from 
	website_sessions ws
    left join 
    orders o 
    on ws.website_session_id = o.website_session_id
where ws.created_at < "2012-04-14" and ws.utm_source = 'gsearch' and utm_campaign = 'nonbrand'
group by utm_source, utm_campaign, http_referer
order by sessions desc;


/*
Hmm, looks like I'm below the 4% threshold I need to make the economics work. 
Based on this analysis, I’ll need to dial down my search bids a bit. I'm over-spending based on the current conversion rate.
*/


/*
Based on conversion rate analysis, we bid down gsearch nonbrand on 2012-04-15. Now pulling gsearch nonbrand trended session volume, by week, 
to see if the bid changes have caused volume to drop at all?
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRAFFIC SOURCE TRENDING


select 
	-- year(created_at) as yr,     # bcz we don't want to see in output
	-- week(created_at) as week,   # bcz we don't want to see in output
    min(date(created_at)) as week_start_date,
	count(distinct website_session_id) as sessions
from 
	website_sessions 
where created_at < "2012-05-10" 
	and utm_source = 'gsearch' 
    and utm_campaign = 'nonbrand'
group by
	year(created_at),
	week(created_at);
    
    
/*
Okay, based on this, it does look like gsearch nonbrand is fairly sensitive to bid changes. 
I want maximum volume, but don’t want to spend more on ads than we can afford.
*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
I was trying to use our site on my mobile device the other day, and the experience was not great. 
So now I'm pulling conversion rates from session to order, by device type. 
If desktop performance is better than on mobile I may be able to bid up for desktop specifically to get more volume?
*/

-- TRAFFIC SOURCE BID OPTIMIZATION


SELECT 
    ws.device_type,
    count(distinct ws.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    (count(distinct o.order_id)/count(distinct ws.website_session_id))*100 as order_to_sessions_ratio
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
where ws.created_at <"2012-05-11"
	and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by 1;


/*
Great! 
I'm going to increase my bids on desktop. When I bid higher, I’ll rank higher in the auctions, so I think insights here should lead to a sales boost.
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
After device-level analysis of conversion rates, I realized desktop was doing well, so I bid my gsearch nonbrand desktop campaigns up on 2012-05-19. 
Now I'm pulling weekly trends for both desktop and mobile so I can see the impact on volume.
I'm using 2012-04-15 until the bid change as a baseline.
*/


-- TRAFFIC SOURCE SEGMENT TRENDING


select 
	-- year(created_at) as yr,
	-- week(created_at) as wk,
    min(date(created_at)) as week_start_date,
    count(distinct case when device_type = "mobile" then website_session_id else null end) as mobile_session,
    count(distinct case when device_type = "desktop" then website_session_id else null end) as desktop_session
from 
	website_sessions
where 
	created_at between "2012-04-15" and "2012-06-09"
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by 
	year(created_at),
	week(created_at);
    
    
    
/*
It looks like mobile has been pretty flat or a little down, but desktop is looking strong thanks to the bid changes made based on my previous conversion analysis. 
So, Things are moving in the right direction!
*/


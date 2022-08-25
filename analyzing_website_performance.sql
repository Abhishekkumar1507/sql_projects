-- B.. ANALYZING WEBSITE PERFORMANCE
-- #############################################################################################################################################################################################################################################################
/*
Now I'm pulling the most-viewed website pages, ranked by session volume.
*/

-- IDENTIFYING TOP WEBSITE PAGES


select pageview_url,
	count(distinct website_session_id) as num_sessions 
from website_pageviews
where created_at < "2012-06-09"
group by pageview_url
order by num_sessions desc;


select pageview_url,
	count(distinct website_pageview_id) as num_sessions 
from website_pageviews
where created_at < "2012-06-09"
group by pageview_url
order by num_sessions desc;


/*
It definitely seems like the homepage, the products page, and the Mr. Fuzzy page get the bulk of our traffic. 
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Now I'm pulling a list of the top entry pages. So that I can confirm where our users are hitting the site. 
So I fetch all entry pages and ranked them on entry volume.
*/

-- IDENTIFYING TOP ENTRY PAGES


select pageview_url,count(pageview_url) as sessions
from website_pageviews
where created_at < "2012-06-12"
group by pageview_url
order by sessions desc;

drop table first_pageviews;

create temporary table first_pageviews
SELECT 
    website_session_id,
    COUNT(website_pageview_id) AS count,
    MIN(website_pageview_id) AS landing_page
FROM
    website_pageviews
where created_at < "2012-06-12"
GROUP BY website_session_id
ORDER BY count DESC;


SELECT 
    wp.pageview_url as landing_page_url,
    COUNT(pageview_url) AS sessions_hitting_this_landing_page
FROM
    first_pageviews fpv
        LEFT JOIN
    website_pageviews wp ON fpv.landing_page = wp.website_pageview_id
GROUP BY wp.pageview_url
ORDER BY sessions_hitting_this_landing_page desc;



/*
Wow, looks like our traffic all comes in through the homepage right now!
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Now I'm checking how that landing page is performing and pulling bounce rates for traffic landing on the homepage.
*/

-- CALCULATING BOUNCE RATES


-- step 1: finding the first website_pageview_id for relevant sessions

drop table first_pageviews;

create temporary table first_pageviews
SELECT 
    website_session_id,
    COUNT(website_session_id) AS total_pages_viewed,
    MIN(website_pageview_id) AS first_website_pageview_id,
    case when COUNT(website_session_id) =1 then "bounce" else null end as bounced_cus,
    case when COUNT(website_session_id) >1 then "cvr" else null end as cvr_cus
FROM
    website_pageviews
    where created_at between "2014-01-01" and "2014-02-01"
GROUP BY website_session_id;


select * from first_pageviews;

-- step 2: identifying the landing page of each session
drop table if exists session_w_landing_page;

create temporary table session_w_landing_page
select fpv.first_website_pageview_id,wp.pageview_url
from first_pageviews fpv 
left join website_pageviews wp 
on fpv.first_website_pageview_id=wp.website_pageview_id;


select * from session_w_landing_page;

-- step 3: counting pageviews for each session, to identify "bounces"
SELECT 
    slp.first_website_pageview_id,
    slp.pageview_url as landing_page,
    fpv.total_pages_viewed
FROM
    session_w_landing_page slp
        JOIN
    first_pageviews fpv ON slp.first_website_pageview_id = fpv.first_website_pageview_id
order by slp.first_website_pageview_id asc;


drop table if exists bounced_session_only;

create temporary table bounced_session_only
SELECT 
    slp.first_website_pageview_id,
    slp.pageview_url as landing_page,
    fpv.total_pages_viewed
FROM
    session_w_landing_page slp
        JOIN
    first_pageviews fpv ON slp.first_website_pageview_id = fpv.first_website_pageview_id
where fpv.total_pages_viewed=1;

select * from bounced_session_only;


select 
	slp.pageview_url as landing_page,
    count(distinct slp.first_website_pageview_id) as sessions,
    count(distinct bso.first_website_pageview_id) as bounced_sessions,
    (count(distinct bso.first_website_pageview_id)/count(distinct slp.first_website_pageview_id))*100 as bounced_percentage,
    (1-(count(distinct bso.first_website_pageview_id)/count(distinct slp.first_website_pageview_id)))*100 as cvr_percentage
from session_w_landing_page slp
left join bounced_session_only bso
on slp.first_website_pageview_id=bso.first_website_pageview_id
group by slp.pageview_url;



drop table pages_viewed_by_sessions;
create temporary table pages_viewed_by_sessions
SELECT 
    website_session_id,
    COUNT(website_pageview_id) AS pages_viewed,
    MIN(website_pageview_id) AS landing_page_website_id
FROM
    website_pageviews
where created_at < "2012-06-14"
GROUP BY website_session_id
ORDER BY pages_viewed DESC;


select * from pages_viewed_by_sessions;


drop table pages_viewed_by_sessions_w_homepage;

create temporary table pages_viewed_by_sessions_w_homepage
select pvbs.*,
		wp.pageview_url 
from pages_viewed_by_sessions pvbs 
	left join website_pageviews wp 
	on pvbs.landing_page_website_id=wp.website_pageview_id 
where wp.pageview_url='/home';


select * from pages_viewed_by_sessions_w_homepage;


-- bounced sessions
drop table bounced_sessions_only;

create temporary table bounced_sessions_only
select pvbswh.*
from pages_viewed_by_sessions_w_homepage pvbswh
where pages_viewed=1;


select * from bounced_sessions_only;

-- step 4: summarizing by counting total sessions and bounced sessions

select 
-- pvbswh.pageview_url as landing_page,
count(distinct pvbswh.website_session_id) as sessions,
count(distinct bso.website_session_id) as bounced_sessions,
(count(bso.website_session_id)/count(pvbswh.website_session_id))*100 as bounce_rate
from pages_viewed_by_sessions_w_homepage pvbswh  
left join bounced_sessions_only bso
on pvbswh.website_session_id=bso.website_session_id
group by pvbswh.pageview_url;


/*
Ouch…almost a 60% bounce rate! That’s pretty high from my experience, especially for paid search, which should be high quality traffic. 
I will put together a custom landing page for search, and set up an experiment to see if the new page does better.
*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Based on bounce rate analysis, I ran a new custom landing page (/lander-1) in a 50/50 test against the homepage (/home) for my gsearch nonbrand traffic. 
And pulling bounce rates for the two groups so that I can evaluate the new page. ensure to just look at the time period where /lander-1 was getting traffic, so that it is a fair comparison.
*/

-- ANALYZING LANDING PAGE TESTS


-- step 1: find out when the new page/lander launched
(select created_at as first_created_at,pageview_url as first_landing_page,website_pageview_id from website_pageviews where pageview_url  = '/lander-1' order by created_at limit 1)
union 
(select created_at as first_created_at,pageview_url as first_landing_page,website_pageview_id from website_pageviews where pageview_url  = '/home' order by created_at limit 1);


-- step2: finding the first website_pageview_id for relevant sessions
drop table first_pageviews;
create temporary table first_pageviews
SELECT 
    wp.website_session_id,
    COUNT(wp.website_pageview_id) AS pages_viewed,
    MIN(wp.website_pageview_id) AS landing_page_website_id
FROM
    website_pageviews wp inner join website_sessions ws
    on wp.website_session_id=ws.website_session_id
where wp.created_at between "2012-06-19" and "2012-07-28"
and ws.utm_source='gsearch' and ws.utm_campaign='nonbrand'
GROUP BY wp.website_session_id
ORDER BY pages_viewed DESC;

select * from first_pageviews;

-- step 3: identifying the landing page of each session
drop table session_w_landing_page;
create temporary table session_w_landing_page
SELECT 
    fpv.*, wp.pageview_url
FROM
    first_pageviews fpv
        LEFT JOIN
    website_pageviews wp ON fpv.landing_page_website_id = wp.website_pageview_id
WHERE
    wp.pageview_url in ('/home','/lander-1');

select * from session_w_landing_page;



SELECT 
    wp.pageview_url as landing_page_url,
    COUNT(wp.pageview_url) AS sessions_hitting_this_landing_page
FROM
    session_w_landing_page slp
        LEFT JOIN
    website_pageviews wp ON slp.landing_page_website_id = wp.website_pageview_id
GROUP BY wp.pageview_url
ORDER BY sessions_hitting_this_landing_page desc;


-- step 4: counting pageviews for each session, to identify "bounces"
drop table bounced_sessions_only;
create temporary table bounced_sessions_only
select slp.*
from session_w_landing_page slp
where pages_viewed=1;


select * from bounced_sessions_only;


-- step 5: summarizing total sessions and bounced sessions, by LP
select
slp.pageview_url as landing_page,
count(distinct slp.website_session_id) as sessions,
count(distinct bso.website_session_id) as bounced_sessions,
(count(bso.website_session_id)/count(slp.website_session_id))*100 as bounce_rate
from session_w_landing_page slp
left join bounced_sessions_only bso
on slp.website_session_id=bso.website_session_id
group by slp.pageview_url;

/*
This is so great. It looks like the custom lander has a lower bounce rate…success! 
I will work to get campaigns updated so that all nonbrand paid traffic is pointing to the new page.
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Now I'm pulling the volume of paid search nonbrand traffic landing on /home and /lander-1, trended weekly since June 1st.
Because I want to confirm the traffic is all routed correctly, and also pulling overall paid search bounce rate trended weekly. 
I want to make sure the lander change has improved the overall picture.
*/

-- LANDING PAGE TREND ANALYSIS

drop table home_and_lander_session_ids;
-- create temporary table home_and_lander_session_ids
select
	wp.website_session_id,
	case when wp.pageview_url = '/home' then wp.website_session_id else null end as home_session,
	case when wp.pageview_url = '/lander-1' then wp.website_session_id else null end as lander_1_session
from website_pageviews wp inner join website_sessions ws 
on wp.website_session_id=ws.website_session_id
where wp.created_at between "2012-06-01" and  "2012-08-31"
and ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
;


select
	min(date(wp.created_at)) as week_start_date,
	-- wp.website_session_id,
	count(distinct case when wp.pageview_url = '/home' then wp.website_session_id else null end) as home_sessions,
	count(distinct case when wp.pageview_url = '/lander-1' then wp.website_session_id else null end) as lander_1_sessions
from website_pageviews wp inner join website_sessions ws 
on wp.website_session_id=ws.website_session_id
where wp.created_at between "2012-06-01" and  "2012-08-31"
and ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
group by year(wp.created_at),
    week(wp.created_at);
    
    
-- step 1: finding the first website_pageview_id for relevant sessions
drop table first_pageviews;
create temporary table first_pageviews
SELECT 
    wp.website_session_id,
    COUNT(wp.website_pageview_id) AS pages_viewed,
    MIN(wp.website_pageview_id) AS landing_page_website_id
FROM
    website_pageviews wp inner join website_sessions ws
    on wp.website_session_id=ws.website_session_id
where wp.created_at between "2012-06-19" and "2012-07-28"
and ws.utm_source='gsearch' and ws.utm_campaign='nonbrand'
GROUP BY wp.website_session_id
ORDER BY pages_viewed DESC;

select * from first_pageviews;


-- step 2: identifying the landing page of each session
-- step 3: counting pageviews for each session, to identify "bounces"
drop table session_w_landing_page;
create temporary table session_w_landing_page
SELECT 
    fpv.*, wp.pageview_url
FROM
    first_pageviews fpv
        LEFT JOIN
    website_pageviews wp ON fpv.landing_page_website_id = wp.website_pageview_id
WHERE
    wp.pageview_url in ('/home','/lander-1');

select * from session_w_landing_page;


-- step 4: summarizing by week (bounce rate,sessions to each lander)
select
	-- year(session_created_at) as yr,
    -- week(session_created_at) as week
    min(date(session_created_at)) as week_start_date,
    -- count(distinct website_session_id) as total_sessions,
    (count(distinct case when count_pageviews=1 then website_session_id else null end)/ count(distinct website_session_id))*100 as bounce_rate,
    count( distinct case when landing_page='/home' then website_session_id else null end) as home_sessions,
    count( distinct case when landing_page='/lander-1' then website_session_id else null end) as lander_sessions
from sessions_w_lander_and_created_at
group by year(session_created_at),week(session_created_at);




/*
This is great! Looks like both pages were getting traffic for a while, and then I fully switched over to the custom lander, as 
intended. And it looks like our overall bounce rate has come down over time…nice!
*/

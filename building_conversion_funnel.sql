-- C.. BUILDING CONVERSION FUNNELS
-- #############################################################################################################################################################################################################################################################

-- BUSINESS CONTEXT
	-- I want to build a mini conversion funnel, from /lander-2 to /cart
    -- I want to know how many people reach each step, and also dropoff rates
    -- I am looking at /lander-2 traffic only and I'm looking at customers who like Mr Fuzzy only.

/*
I want to understand where we lose our gsearch visitors between the new /lander-1 page and placing an order. 
So I'm building a full conversion funnel, analyzing how many customers make it to each step.
Start with /lander-1 and build the funnel all the way to our thank you page. 
*/

-- BUILDING CONVERSION FUNNELS


-- step 1 : select all pageviews for relevant sessions
select 
-- wpv.created_at,
count(distinct ws.website_session_id)
-- wpv.website_pageview_id,
-- wpv.pageview_url
from website_sessions ws
left join website_pageviews wpv
on ws.website_session_id=wpv.website_session_id
where ws.utm_source='gsearch' and ws.utm_campaign='nonbrand' and ws.created_at<'2012-09-05' and ws.created_at>'2012-08-05'
order by ws.website_session_id, wpv.created_at;


-- step 2 : identify each pageview as the specific funnel step

select 
-- ws.created_at,
ws.website_session_id,
-- wpv.website_pageview_id,
wpv.pageview_url,
-- case when pageview_url='home' then 1 else 0 end as home_page,
case when pageview_url='/lander-1' then 1 else 0 end as lander_1_page,
case when pageview_url='/products' then 1 else 0 end as product_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when pageview_url='/billing' then 1 else 0 end as billing_page,
case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions ws
left join website_pageviews wpv
on ws.website_session_id=wpv.website_session_id
where ws.utm_source='gsearch' and ws.utm_campaign='nonbrand' and ws.created_at<'2012-09-05' and ws.created_at>'2012-08-05'
;


-- step 3 :cretae the session-level conversion funnel view

SELECT
	website_session_id,
	-- MAX(home_page) AS home_made_it,
    MAX(lander_1_page) AS lander_1_made_it,
    MAX(product_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
from(
select 
ws.created_at,
ws.website_session_id,
wpv.website_pageview_id,
wpv.pageview_url,
-- case when pageview_url='home' then 1 else 0 end as home_page,
case when pageview_url='/lander-1' then 1 else 0 end as lander_1_page,
case when pageview_url='/products' then 1 else 0 end as product_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when pageview_url='/billing' then 1 else 0 end as billing_page,
case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions ws
left join website_pageviews wpv
on ws.website_session_id=wpv.website_session_id
where ws.utm_source='gsearch' and ws.utm_campaign='nonbrand' and ws.created_at between '2012-08-06' and '2012-09-04'
and wpv.pageview_url in ('/lander-1','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
) as session_and_their_pageviews
group by ws.website_session_id
;

drop table if exists session_and_their_pageviews_flags;

create temporary table session_and_their_pageviews_flags
SELECT
	website_session_id,
    -- MAX(home_page) AS home_made_it,
    MAX(lander_1_page) AS lander_1_made_it,
    MAX(product_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
from(
select 
ws.created_at,
ws.website_session_id,
wpv.website_pageview_id,
wpv.pageview_url,
-- case when pageview_url='home' then 1 else 0 end as home_page,
case when pageview_url='/lander-1' then 1 else 0 end as lander_1_page,
case when pageview_url='/products' then 1 else 0 end as product_page,
case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when pageview_url='/cart' then 1 else 0 end as cart_page,
case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
case when pageview_url='/billing' then 1 else 0 end as billing_page,
case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions ws
left join website_pageviews wpv
on ws.website_session_id=wpv.website_session_id
where ws.utm_source='gsearch' and ws.utm_campaign='nonbrand' and ws.created_at<'2012-09-05' and ws.created_at>'2012-08-05'
) as session_and_their_pageviews
group by ws.website_session_id
;


select * from session_and_their_pageviews_flags;

-- step 4 : aggregate the data to assess funnel performance

select
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it=1 then website_session_id else null end) as to_products,
    count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end) as to_mrfuzzy,
    count(distinct case when cart_made_it=1 then website_session_id else null end) as to_cart,
    count(distinct case when shipping_made_it=1 then website_session_id else null end) as to_shipping,
    count(distinct case when billing_made_it=1 then website_session_id else null end) as to_billing,
    count(distinct case when thankyou_made_it=1 then website_session_id else null end) as to_thankyou
from session_and_their_pageviews_flags;


select
	-- count(distinct website_session_id) as sessions,
    round((count(distinct case when product_made_it=1 then website_session_id else null end) 
    /count(distinct website_session_id))*100,2) as lander_clickthrough_rate,
    round((count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end) 
    /count(distinct case when product_made_it=1 then website_session_id else null end))*100,2) as product_clickthrough_rate,
    round((count(distinct case when cart_made_it=1 then website_session_id else null end) 
    /count(distinct case when mrfuzzy_made_it=1 then website_session_id else null end))*100,2) as mrfuzzy_clickthrough_rate,
    round((count(distinct case when shipping_made_it=1 then website_session_id else null end) 
    /count(distinct case when cart_made_it=1 then website_session_id else null end))*100,2) as cart_clickthrough_rate,
    round((count(distinct case when billing_made_it=1 then website_session_id else null end) 
    /count(distinct case when shipping_made_it=1 then website_session_id else null end))*100,2) as shipping_clickthrough_rate,
    round((count(distinct case when thankyou_made_it=1 then website_session_id else null end) 
    /count(distinct case when billing_made_it=1 then website_session_id else null end))*100,2) as mrfuzzy_clickthrough_rate
from session_and_their_pageviews_flags;


/*
Looks like we should focus on the lander, Mr. Fuzzy page, and the billing page, which have the lowest click rates. 
I have some ideas for the billing page that I think will make customers more comfortable entering their credit card info. 
So now I’ll test a new page and then I'll analyze performance.
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Now I'm looking and see whether /billing-2 is doing any better than the original /billing page. 
I'm wondering what % of sessions on those pages end up placing an order and also I ran this test for all traffic, not just for our search visitors.
*/

-- ANALYZING CONVERSION FUNNEL TESTS

-- finding the first time '/billing-2' was seen
select * from website_pageviews where pageview_url='/billing-2' order by created_at limit 1;
-- first_pageview_id=53550  and created_at ='2012-09-10'


select 
	billing_version_seen,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    (count(distinct order_id)/count(distinct website_session_id))*100 as billing_to_order_rt
from(
select 
wpv.pageview_url as billing_version_seen,
wpv.website_session_id,
orders.order_id
from website_pageviews wpv
left join orders
on wpv.website_session_id=orders.website_session_id
where wpv.website_pageview_id>=53550 
and wpv.created_at<'2012-11-10' and wpv.pageview_url in ('/billing','/billing-2')) as billing_sessions_with_orders
group by billing_version_seen;



/*
This is so good to see! Looks like the new version of the billing page is doing a much better job converting customers…yes!! 
I will get Engineering to roll this out to all of our customers right away.
*/
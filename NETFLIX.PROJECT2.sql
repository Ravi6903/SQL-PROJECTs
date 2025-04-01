--------------------------NETFLIX PROJECT--
---QUESTION 1 , COUNT NUMBER OF MOVIES / TV SHOWS
--sol 
select 
  type, 
  count(*) total 
from 
  netflix 
group by 
  type;
  
---- Question 2 Find the most common rating for movies and tv shows
select 
  type, 
  rating, 
  total_rating 
from 
  (
    select 
      type, 
      rating, 
      count(rating) as total_rating, 
      rank() over(
        partition by type 
        order by 
          count(rating) desc
      ) 
    from 
      netflix 
    group by 
      rating, 
      type
  ) as T1 
where 
  rank = 1;
---------Question 3  list all movies released in a specific year ( e.g 2020)
--solution 
select 
  title, 
  release_year 
from 
  netflix 
where 
  type = 'Movie' 
  and release_year = 2020;
--------Question find the top  country with tho most content on Netflix 
----solution 
select 
  unnest(
    string_to_array(country, ',')
  ) as country, 
  count(show_id) as total_content 
from 
  netflix 
group by 
  country 
order by 
  total_content desc 
limit 
  (5);
------Question  indentify the longest movie 
------solution
select 
  title, 
  cast(
    regexp_replace(duration, '[^0-9]', '', 'g') as INT
  ) as duration 
from 
  netflix 
where 
  type = 'Movie' 
  and duration is not null 
order by 
  duration desc 
limit 
  5;
-------------Question  find content added is last five years
----solution
select 
  * 
from 
  netflix 
where 
  to_date(date_added, 'Month DD , YYYY')>= current_date - INTERVAL '5years' 
order by 
  date_added desc;
-----Question find all the movies/ tv shows by riector 'Rajiv Chilaka'
select 
  title, 
  director 
from 
  netflix 
where 
  director Ilike '%Rajiv Chilaka%';
-----question : lsit all tv shows with more than 5 seasons
select 
  title, 
  cast(
    regexp_replace(duration, '[^0-9]', '', 'g') as INT
  ) as duration 
from 
  netflix 
where 
  type = 'TV Show' 
  and duration > '5 Seasons' 
order by 
  duration;
----- question find the number of content in each genre 
---solution
select 
  unnest(
    string_to_array(listed_in, ',')
  ) as genre, 
  count(show_id) as total_content 
from 
  netflix 
group by 
  genre 
order by 
  total_content desc;
----question find each year and the aversge number of content released in india on netflix, 
----return top 5 year with average content release
---solution 
select 
  extract(
    YEAR 
    from 
      to_date(date_added, 'Month DD,YYYY')
  ) as year, 
  count(*) as total, 
  round(
    count(*):: numeric /(
      select 
        count(*) 
      from 
        netflix 
      where 
        country Ilike 'India'
    ):: numeric * 100, 
    2
  ) as avg_content_per_year 
from 
  netflix 
where 
  country Ilike 'India' 
group by 
  year;
--------Question Listed all the movies that are documentries
------solution
select 
  * 
from 
  netflix 
where 
  listed_in Ilike '%documentaries%';
-------- question find all the content without director
select 
  * 
from 
  netflix 
where 
  director is NULL;
------------in houw many movies does salman khan appeared  in last 10 years
---solution
select 
  * 
from 
  netflix 
where 
  to_date(date_added, 'Month DD , YYYY')>= current_date - INTERVAL '10years' 
  and casts Ilike '%Salman Khan%' 
order by 
  date_added desc;
-----top 10 actors who have appeared in most no of movies 
-----solution 
select 
  unnest(
    string_to_array(casts, ',')
  ) as actors, 
  count(*) as total_content 
from 
  netflix 
where 
  country Ilike '%india' 
group by 
  1 
order by 
  2 desc;
-----------categorize the content based on the presence of keywords 'kill' and violence in the description field .
----label content these 'bad'and all other content as 'good'. count how many items fall into each other.
---solution
update 
  netflix 
set 
  good_or_bad = case when description Ilike '%kill%' 
  or description Ilike '%violence%' then 'BAD' else 'GOOD' END;
select 
  * 
from 
  netflix -------------------END OF THE PROJECT ______________

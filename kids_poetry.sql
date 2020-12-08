-- 1a.

SELECT g.name, count(g.id)
  FROM (author a JOIN grade g ON a.grade_id = g.id)
  group by g.name

-- 1b.

SELECT gd.name, count(a.gender_id) as author_gender_count
  FROM (author a JOIN gender gd ON a.gender_id = gd.id)
  where gd.name = 'Male' or gd.name = 'Female'
  group by gd.name, gd.id, a.gender_id	

-- 1c. trends across grades
-- typically there are more female poets

SELECT gd.name as gender,  g.name as grade, count(a.gender_id) as gender_grade
  FROM (author a JOIN gender gd ON a.gender_id = gd.id)
  JOIN grade g ON a.grade_id = g.id
  WHERE gd.name = 'Male'
  OR gd.name = 'Female'
  GROUP BY gd.name, gd.id, a.gender_id, g.name
  ORDER BY g.name DESC

-- 2. do children write about love or death more

SELECT title, count(title), avg(char_count)
FROM poem
  WHERE title LIKE '%love%' or title LIKE '%death%' or title LIKE 'die%' or title LIKE '%dead%'
  GROUP BY char_count, title
  
select count(id) as poem_count, avg(char_count) as avg_char,
case when lower(text) like '%death%' then 'death' else 'love' end

FROM lower(text) like '%death%' or lower(text) like '%love%'
 group by case when lower(text) like '%death%' then 'death'
 		else 'love' end;

-- 3. Do longer or shorter poems have more emotional intensity
-- it's about the same. most of the poems are below 50%, regardless of long or short

SELECT count(intensity_percent) as intensity_count, intensity_percent as intensity
-- , po.char_count, pe.poem_id, pe.intensity_percent, pe.emotion_id, e.name as emotion
  FROM (poem po JOIN poem_emotion pe ON po.id = pe.poem_id)
  JOIN emotion e ON pe.emotion_id = e.id
--   WHERE char_count <= 100 and intensity_percent <=50
--   WHERE char_count between 100 and 200 and intensity_percent <=50
--   WHERE char_count between 200 and 300 and intensity_percent <=50
  WHERE char_count >300 and intensity_percent <=50
  group by pe.intensity_percent
--   po.char_count, pe.poem_id, pe.intensity_percent, pe.emotion_id, e.name
  ORDER BY intensity_percent DESC

-- 3a.1 return emotions by average intensity and character count
-- 3a.2 Which emotion is associated the longest poems on average?
-- 3a.3 Which emotion has the shortest?

SELECT avg(intensity_percent) as intensity, avg(char_count) as char_count, e.name as emotions
  FROM (poem po JOIN poem_emotion pe ON po.id = pe.poem_id)
  JOIN emotion e ON pe.emotion_id = e.id
--   WHERE char_count >300 and intensity_percent <=50
  group by  e.name, pe.intensity_percent, po.char_count
  order by char_count desc

-- 4a. 

SELECT gr.name as grade, e.name as emotions, pe.intensity_percent as intensity
  FROM (author au JOIN grade gr ON au.grade_id = gr.id)
  JOIN poem po ON au.id = po.author_id
  JOIN poem_emotion pe ON po.id = pe.emotion_id
  JOIN emotion e ON pe.emotion_id = e.id
--   WHERE au.id = '1' and e.name = 'Anger'
--   WHERE au.id = '5' and e.name = 'Anger'
  group by pe.intensity_percent
  po.char_count, pe.poem_id, pe.intensity_percent, pe.emotion_id, e.name
  ORDER BY gr.name asc

-- 5.

select au.name, count(au.name), gr.name
-- pe.emotion_id
FROM (author au JOIN grade gr ON au.grade_id = gr.id)
  JOIN poem po ON au.id = po.author_id
  JOIN poem_emotion pe ON po.id = pe.emotion_id
--   JOIN emotion e ON pe.emotion_id = e.id
where au.name = 'emily'
group by au.name, gr.name
-- , pe.emotion_id
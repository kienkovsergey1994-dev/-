SELECT * FROM project2.`данные об аудитории`;
alter table project2.`данные об аудитории`
rename column `п»їdate` to Data;

select  count(distinct user_id) as MAU from `данные об аудитории`;

select avg(DAU) from (select Data, count(distinct user_id) as DAU from `данные об аудитории`
group by Data) t;

with nov_1 as (select distinct user_id from `данные об аудитории`
where day(Data) = 01 and month(Data) = 11),

nov_2 as (select distinct user_id from `данные об аудитории`
where  Data = '2023-11-02')

SELECT
    SUM(
        CASE
            WHEN nov_2.user_id IS NOT NULL THEN 1
            ELSE 0
        END
    ) / COUNT(*) * 100 AS retention
FROM nov_1
LEFT JOIN nov_2
    ON nov_1.user_id = nov_2.user_id;
    
with activ as (select count(distinct user_id) as act_us from `данные об аудитории`
where view_adverts > 0),

all_u as (select count(distinct user_id) as users from `данные об аудитории`)

select (act_us/users*100) as convers from activ
cross join all_u;

with views as (select sum(view_adverts) as ads from `данные об аудитории`),

users as (select count(distinct user_id) as all_u from `данные об аудитории`)

select (ads/all_u) as avgv from views
cross join users;










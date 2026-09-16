with activ_user as 
	(select ID_client, count(distinct month(date_new_date)) as month_actv from transactions_info
where date_new_date between '2015-06-01' and '2016-06-01'
group by ID_client
having month_actv = '12')

select month(t.date_new_date) as 'Месяц', t.ID_client, round(avg(t.Sum_payment),2) as 'Средний чек', count(t.Id_check) as 'Все операции', 
round(sum(t.Sum_payment),2) as 'Средняя сумма покупок' from transactions_info t
join activ_user au
on au.ID_client = t.ID_client
where t.date_new_date between '2015-06-01' and '2016-06-01'
group by month(t.date_new_date), t.ID_client;

DESCRIBE transactions_info;

ALTER TABLE transactions_info
ADD COLUMN date_new_date DATE;

UPDATE transactions_info
SET date_new_date = STR_TO_DATE(date_new, '%d/%m/%Y');
----------------------------------------------------------------------

# 2. средняя сумма чека в месяц;
#среднее количество операций в месяц;
#среднее количество клиентов, которые совершали операции;
#долю от общего количества операций за год и долю в месяц от общей суммы операций;
#вывести % соотношение M/F/NA в каждом месяце с их долей затрат;


with checks as (
select Id_check, month(date_new_date) as month, sum(Sum_payment) as check_all from transactions_info
group by month(date_new_date), Id_check)

select month, round(avg(check_all),2) as 'Средняя сумма чека' from checks
group by month;


with operation as (
select count(distinct Id_check) as all_check, month(date_new_date) as month from transactions_info
group by month(date_new_date))

select month, round(avg(all_check),0) as 'Среднее кол-во операций' from operation
group by month;

with oper_clients as (
select count(distinct c.Id_client) as all_clients, month(date_new_date) as Month from customer_info c
join transactions_info t
on t.ID_client = c.Id_client
group by  Month)

select avg(all_clients) as 'Среднее кол-во клиентов' from oper_clients;

# долю от общего количества операций за год и долю в месяц от общей суммы операций;

with check_year as (
select count(distinct Id_check) as check_m, month(date_new_date) as Month, sum(Sum_payment) as sumttl  from transactions_info
where date_new_date between '2015-06-01' and '2016-06-01'
group by Month)

select round(check_m /sum(check_m)over()*100,2) as 'Доля', Month, round(sumttl/sum(sumttl)over()*100,2) as 'Доля от общей суммы' from check_year;

# вывести % соотношение M/F/NA в каждом месяце с их долей затрат;

with all_u as (
select count(distinct c.Id_client) as cnt_gen, Gender, sum(t.Sum_payment) as all_amount, month(date_new_date) as Month from customer_info c
join transactions_info t
on c.Id_client = t.ID_client
group by Gender, Month)

select  cnt_gen/sum(cnt_gen)over(PARTITION BY Month)*100 as 'Соотношение', all_amount/sum(all_amount)over(PARTITION BY Month)*100 as 'Доля затрат', Gender, Month from all_u;
------------------------------------------------------------------------------------------------------------------------
# возрастные группы клиентов с шагом 10 лет и отдельно клиентов, у которых нет данной информации, 
# с параметрами сумма и количество операций за весь период, и поквартально - средние показатели и %.

with df as ( select
case 
	when Age < 10 Then '1'
    when Age < 20 Then '2'
    when Age < 30 Then '3'
    when Age < 40 Then '4'
    when Age < 50 Then '5'
    when Age < 60 Then '6'
    when Age < 70 Then '7'
    when Age < 80 Then '8'
    when Age < 90 Then '9'
	else 'NA'
end as age_gr, round(sum(t.Sum_payment),2) as Summa, count(distinct t.Id_check) as all_oper, quarter(t.date_new_date) as Quartal,
year(t.date_new_date) as Year
from customer_info c
join transactions_info t
on t.ID_client = c.Id_client
group by age_gr, quarter(t.date_new_date), year(t.date_new_date))

select round(avg(Summa)over(partition by age_gr),2) as 'Средняя сумма', 
round(avg(all_oper)over(partition by age_gr),2) as 'Среднее кол-во операций', round(Summa/sum(Summa)over(partition by Year, Quartal)*100,2) as 'Доля',
age_gr, Quartal, Summa as 'Общая сумма', all_oper as 'Все операции', Year from df








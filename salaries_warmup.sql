use employees;

select max(salary)
from salaries s
where to_date>NOW() and salary not in (select max(salary) from salaries
	where to_date>now())
;

select min(salary)
from 
(select salary from salaries
where to_date>now()
order by salary desc
limit 2) m;

select e.first_name, e.last_name, s.salary
from employees e
join salaries s on e.emp_no=s.emp_no where s.to_date>now()
order by s.salary desc
limit 1, 1;

select * from
(select e.first_name, e.last_name, s.salary
from employees e
join salaries s on e.emp_no=s.emp_no where s.to_date>now()
order by s.salary desc
limit 2) m
order by m.salary
limit 1
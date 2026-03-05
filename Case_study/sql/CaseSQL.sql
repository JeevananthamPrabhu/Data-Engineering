
--Table Creation

--Department Table

create table Departments(
dept_id int primary key,
dept_name varchar(50) not null
);

--Location Table

create table Locations(
location_id int primary key,
location_name varchar(50) not null
);

--Job_roles Table

create table Job_Roles(
role_id int primary key,
role_name varchar(50) not null,
min_salary decimal(10,2),
max_salary decimal(10,2)
);

--Employees Table

create table Employees(
emp_id int primary key,
emp_name varchar(100) not null,
gender varchar(10),
dept_id int,
role_id int,
location_id int,
join_date Date,
status varchar(20) default 'Active',
foreign key (dept_id) references Departments(dept_id),
foreign key (role_id) references Job_Roles(role_id),
foreign key (location_id) references Locations(location_id)
);

--Salary Table

create table Salaries(
salary_id int primary key,
emp_id int,
salary decimal(10,2),
effective_date date,
foreign key (emp_id) references Employees(emp_id)
);

--Performance Table

create table Performance_Reviews(
review_id int primary key,
emp_id int,
review_year int,
rating decimal(2,1) check (rating between 1 and 5),
foreign key (emp_id) references EMployees(emp_id)
);


bulk insert departments
from 'C:\departments.csv' 
with (
    fieldterminator = ',',
    rowterminator = '\n', 
    firstrow = 1, 
    batchsize = 25 
);

bulk insert locations
from 'C:\locations.csv'
with (
    fieldterminator = ',',
    rowterminator = '\n', 
    firstrow = 1, 
    batchsize = 25 
);

bulk insert job_roles
from 'C:\job_roles.csv' 
with (
    fieldterminator = ',', 
    rowterminator = '\n',
    firstrow = 1,
    batchsize = 25 
);


bulk insert employees
from 'C:\employees.csv' 
with (
    fieldterminator = ',',
    rowterminator = '\n', 
    firstrow = 1, 
    batchsize = 100
);

bulk insert salaries
from 'C:\salaries.csv'
with (
    fieldterminator = ',',
    rowterminator = '\n', 
    firstrow = 1, 
    batchsize = 100
);

bulk insert performance_reviews
from 'C:\performance.csv' 
with (
    fieldterminator = ',', 
    rowterminator = '\n',
    firstrow = 1,
    batchsize = 100
);

select * from departments;
select * from locations;
select * from job_roles;
select * from employees;
select * from salaries;
select * from performance_reviews;

--Performancs Analytics
--Top 10 high-performing employees
--Average rating per department
--Employees eligible for promotion (rating>4 and 2+years)
--Performance trend over years

select top 10 e.emp_id,emp_name,rating from Employees e
join Performance_Reviews p on e.emp_id=p.emp_id
order by rating desc;

select d.dept_id,d.dept_name,cast(avg(rating)as decimal(10,1)) as average_rating from Employees e 
inner join Departments d on e.dept_id=d.dept_id
inner join Performance_Reviews p on e.emp_id=p.emp_id 
group by d.dept_id,d.dept_name;

select e.emp_id,e.emp_name,year(CURRENT_TIMESTAMP)-year(join_date) as experience,rating from Employees e
join Performance_Reviews p on e.emp_id=p.emp_id
where rating>4 and year(CURRENT_TIMESTAMP)-year(join_date)>=2;

select p.review_year as review_year,avg(p.rating) as avg_yearly_rating
from Performance_Reviews p
group by p.review_year order by review_year;

--salary Analytics
--Salary distribution per department
--Highest & lowest salary per role
--Salary vs performance correlation
--Employees below department average salary

select d.dept_name,count(s.salary) as total_employees,min(s.salary) as min_salary,
max(s.salary) as max_salary,avg(s.salary) as avg_salary,sum(s.salary) as total_salary
from Employees e
join Departments d on e.dept_id = d.dept_id
join Salaries s on e.emp_id = s.emp_id
group by d.dept_name;

select j.role_id,j.role_name,min(s.salary) as lowest_salary, max(s.salary) as highest_salary from Employees e
join Salaries s on e.emp_id = s.emp_id
join Job_Roles j on e.role_id=j.role_id
group by j.role_id,j.role_name;

select ( ( count(*)*sum(salary*rating) - sum(salary)*sum(rating) ) / 
sqrt( (count(salary)*sum(salary*salary)-(sum(salary)*sum(salary)))*
(count(rating)*sum(rating*rating)-(sum(rating)*sum(rating))) ) )
as salary_performance_correlation
from Salaries s join Performance_Reviews p on s.emp_id=p.emp_id;

select e.emp_id,e.emp_name,s.salary from Employees e
join Salaries s on e.emp_id=s.emp_id
join (select e.dept_id,avg(s.salary) as avg_sal from Employees e
join Salaries s on e.emp_id=s.emp_id group by e.dept_id) dept_avg on e.dept_id=dept_avg.dept_id
where s.salary<dept_avg.avg_sal;

--Department Growth
--Hiring trend per year
--Headcount growth by department
--Attrition rate by department

select year(join_date) as hire_year,count(emp_id) as no_of_employees 
from Employees group by year(join_date);

select d.dept_id,d.dept_name,count(emp_id) as head_count from Employees e
join Departments d on e.dept_id=d.dept_id
group by d.dept_id,d.dept_name;

--Strategic Insights
--Employees overdue for promotion
--High salary but low performance case
--Most stable department(lowest attrition)
--Attendance vs performance analysis
--Location-wise salary comparison
--Gender diversity ration
--Median salary calculation
--Employees with multiple promotions
--Identify leadership pipeline candidates

select e.emp_id,e.emp_name,year(CURRENT_TIMESTAMP)-year(join_date) as experience,rating from Employees e
join Performance_Reviews p on e.emp_id=p.emp_id
where rating>4.5 and year(CURRENT_TIMESTAMP)-year(join_date)>5;

select e.emp_id,e.emp_name,s.salary,p.rating from Employees e
join Salaries s on e.emp_id=s.emp_id
join Performance_Reviews p on p.emp_id=e.emp_id
join (select e.dept_id,avg(s.salary) as avg_sal from Employees e
join Salaries s on e.emp_id=s.emp_id group by e.dept_id) dept_avg on e.dept_id=dept_avg.dept_id
where s.salary>dept_avg.avg_sal and p.rating<3.5;

select gender,count(emp_id) as no_of_employees from Employees group by gender;

select l.location_id,l.location_name,min(s.salary) as min_salary,max(s.salary) as max_salary,
avg(s.salary) as avg_salary,sum(s.salary) as total_salary from Employees e
join Locations l on e.location_id=l.location_id
join Salaries s on e.emp_id=s.emp_id
group by l.location_id,l.location_name;

select distinct percentile_cont(0.5) within group (order by salary) 
over() as median_salary from Salaries;

select e.emp_id,e.emp_name,p.rating,
year(CURRENT_TIMESTAMP)-year(e.join_date) as
experience from Employees e
join Performance_Reviews p on e.emp_id=p.emp_id
where p.rating>4.5 order by p.rating desc,experience desc;
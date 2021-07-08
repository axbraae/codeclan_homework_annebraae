--MVP
--Q1
--Are there any pay_details records lacking both a local_account_no and iban number?

SELECT 
	COUNT(*)
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL;

--no

--Q2
-- Get a table of employees first_name, last_name and country,
-- ordered alphabetically first by country and then by last_name (put any NULLs last).

SELECT 
	first_name,
	last_name,
	country
FROM employees 
ORDER BY 
	country NULLS LAST,
	last_name NULLS LAST;

--Q3
--Find the details of the top ten highest paid employees in the corporation.

SELECT
	*
FROM employees
ORDER BY salary DESC
LIMIT 10;


--Q4
--Find the first_name, last_name and salary of the lowest paid employee in Hungary.

SELECT 
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC 
LIMIT 1;

--Q5
--Find all the details of any employees with a ‘yahoo’ email address?

SELECT 
	*
FROM employees
WHERE email ILIKE ('%yahoo%');

--Q6
--Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT 
	COUNT(id)
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;

--Q7
--Obtain a table showing department, fte_hours and the number of employees in each department 
--who work each fte_hours pattern. 
--Order the table alphabetically by department, and then in ascending order of fte_hours.

SELECT 
	department,
	fte_hours,
	COUNT(id) AS num_employees_dept
FROM employees 
GROUP BY
	department,
	fte_hours
ORDER BY
	department ASC NULLS LAST,
	fte_hours ASC NULLS LAST
	
--Q8
--Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status 
--in the corporation pension scheme.
	
SELECT
	pension_enrol,
	COUNT(id)
FROM employees
GROUP BY pension_enrol;

--Q9
--What is the maximum salary among those employees in the ‘Engineering’ department 
--who work 1.0 full-time equivalent hours (fte_hours)?

SELECT 
	MAX(salary)
FROM employees 
WHERE fte_hours = 1 AND department = 'Engineering';

--Q10
--Get a table of country, number of employees in that country, 
--and the average salary of employees in that country 
--for any countries in which more than 30 employees are based. 
--Order the table by average salary descending.

SELECT
	country,
	COUNT(id) AS num_employees_in_country,
	AVG(salary) AS avg_salary_per_country
FROM employees 
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY AVG(salary) DESC NULLS LAST;

--Q11
--Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), 
--salary, and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.

SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours*salary AS effective_yearly_salary
FROM employees;

--Q12
--Find the first name and last name of all employees who lack a local_tax_code.

SELECT 
	e.first_name,
	e.last_name
FROM employees AS e LEFT JOIN pay_details AS p 
	ON e.pay_detail_id = p.id 
WHERE local_tax_code IS NULL;


--Q13
--The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
--where charge_cost depends upon the team to which the employee belongs. 
--Get a table showing expected_profit for each employee.

SELECT
	(48 * 35 * CAST(t.charge_cost AS INTEGER) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t 
	ON e.team_id = t.id;

--Q14
--Obtain a table showing any departments in which there are two or more employees lacking a stored first name. 
--Order the table in descending order of the number of employees lacking a first name, 
--and then in alphabetical order by department.

SELECT 
	department,
	COUNT(id) AS num_employees_no_first_name
FROM employees
WHERE first_name IS NULL
GROUP BY department
ORDER BY 
	COUNT(id) DESC NULLS LAST,
	department ASC NULLS LAST;

--Q15
--[Bit Tougher] Return a table of those employee first_names shared by more than one employee, 
-- together with a count of the number of times each first_name occurs. 
-- Omit employees without a stored first_name from the table. 
-- Order the table descending by count, and then alphabetically by first_name.

SELECT 
	first_name,
	COUNT(id) AS num_times_name_found
FROM employees 
WHERE first_name IS NOT NULL
GROUP BY first_name 
HAVING COUNT(id) > 1
ORDER BY COUNT(id) DESC,
first_name ASC;

--Q16
--Find the proportion of employees in each department who are grade 1.

SELECT
	department,
	CAST(COUNT(id) AS REAL) AS grade_1,
	SUM(CAST(grade = 1 AS INTEGER))/CAST(COUNT(id) AS REAL) AS proportion_of_grade_1
FROM employees
GROUP BY department;

-- I tried to use a ROUND in front of the SUM(CAST...) line to return a decimal to 2 digits
-- but this didn't work... Is there a way to return a rounded value here?

-- EXTENSION ------------------------------------------------
--Q17
--Get a list of the id, first_name, last_name, department, salary and fte_hours of employees 
--in the largest department. 
--Add two extra columns showing the ratio of each employee’s salary 
--to that department’s average salary, 
--and each employee’s fte_hours to that department’s average fte_hours.


WITH large_dept_details(department, avg_salary, avg_fte_hours) AS(
SELECT 
	department,
	AVG(salary) AS avg_salary,
	AVG(fte_hours) AS avg_fte_hours
FROM employees
GROUP BY department
ORDER BY department DESC NULLS LAST 
LIMIT 1
)
SELECT
	e.id,
	e.first_name,
	e.last_name,
	e.department,
	e.salary,
	e.fte_hours,
	e.salary/ldd.avg_salary AS ratio_salary_to_dept_salary,
	e.fte_hours/ldd.avg_fte_hours AS ratio_fte_hours_to_dept_hours
FROM employees AS e LEFT JOIN large_dept_details AS ldd 
	ON e.department = ldd.department
WHERE e.department = ldd.department;

--Q17 EXTENSION
-- how to deal with ties
	
WITH large_dept_details(department, avg_salary, avg_fte_hours) AS(
SELECT 
	department,
	AVG(salary) AS avg_salary,
	AVG(fte_hours) AS avg_fte_hours
FROM employees
GROUP BY department
ORDER BY department DESC NULLS LAST 
LIMIT 1
--FETCH FIRST 1 ROWS WITH TIES -- trying to add this but it does not work.
)
SELECT
	e.id,
	e.first_name,
	e.last_name,
	e.department,
	e.salary,
	e.fte_hours,
	e.salary/ldd.avg_salary AS ratio_salary_to_dept_salary,
	e.fte_hours/ldd.avg_fte_hours AS ratio_fte_hours_to_dept_hours
FROM employees AS e LEFT JOIN large_dept_details AS ldd 
	ON e.department = ldd.department
WHERE e.department = ldd.department;	

--Q18
 /* Have a look again at your table for MVP question 8. 
 * It will likely contain a blank cell for the row relating to employees with ‘unknown’ pension enrollment status. 
 * This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar. 
 * Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), or a CASE statement?*/

SELECT
	CASE WHEN (CAST(pension_enrol AS VARCHAR)) IS NULL 
		 THEN 'unknown'
	ELSE CAST(pension_enrol AS VARCHAR) END,
	COUNT(id)
FROM employees
GROUP BY pension_enrol;

--Q19

SELECT 
	e.first_name, e.last_name, e.email, e.start_date 
FROM employees AS e INNER JOIN employees_committees AS ec 
	ON e.id = ec.employee_id INNER JOIN committees AS c 
	ON ec.committee_id =c.id
WHERE c.name = 'Equality and Diversity'
ORDER BY start_date ASC NULLS LAST;

--Q20
SELECT
	CASE 
	WHEN e.salary IS NULL THEN 'none'
	WHEN e.salary <40000 THEN 'low'
	WHEN e.salary >= 40000 THEN 'high'
	END AS salary_class,
	e.first_name, e.last_name, e.email, e.start_date 
FROM employees AS e INNER JOIN employees_committees AS ec 
GROUP BY salary_class

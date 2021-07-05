/* MVP */
/* Q1 */
/*Find all the employees who work in the ‘Human Resources’ department.*/

SELECT *
FROM employees 
WHERE department = 'Human Resources';

/* MVP */
/* Q2 */
/*Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.*/

SELECT first_name, last_name, country
FROM employees 
WHERE department = 'Legal';

/* MVP */
/* Q3 */
/* Count the number of employees based in Portugal. */

SELECT 
COUNT(*) AS portugal_employees
FROM employees 
WHERE country = 'Portugal';

/* MVP */
/* Q4 */
/* Count the number of employees based in either Portugal or Spain. */

SELECT 
COUNT(*) AS employees_port_spain
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';

/*Count the number of pay_details records lacking a local_account_no.*/

SELECT 
COUNT (*) AS pay_details_no_acc
FROM pay_details 
WHERE local_account_no IS NULL;

/*Are there any pay_details records lacking both a local_account_no and iban number?*/

SELECT 
COUNT(*) AS missing_acc_iban
FROM pay_details 
WHERE local_account_no IS NULL
AND iban IS NULL;

/*No. */

/*MVP*/
/*Q7*/
/*Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).*/

SELECT first_name, last_name 
FROM employees 
ORDER BY last_name ASC NULLS LAST;

/*Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).*/

SELECT first_name, last_name, country
FROM employees 
ORDER BY country ASC NULLS LAST,
last_name ASC NULLS LAST;

/*Find the details of the top ten highest paid employees in the corporation.*/

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;


/*Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/

SELECT *
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

/*How many employees have a first_name beginning with ‘F’?*/
/*Q11*/

SELECT
COUNT(*) AS employees_F
FROM employees 
WHERE first_name LIKE 'F%';

/*Q12*/
/*Find all the details of any employees with a ‘yahoo’ email address?*/

SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';

/*Q13*/
/*Count the number of pension enrolled employees not based in either France or Germany.*/

SELECT 
COUNT(*) AS french_german_pension_enrolled
FROM employees 
WHERE country != 'France' OR country != 'Germany'
AND pension_enrol = TRUE;

/*Q14*/
/*What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?*/

SELECT 
MAX(salary) AS max_salary_eng_fte
FROM employees 
WHERE department = 'Engineering'
AND fte_hours = 1;

/*Q15*/
/*Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, 
 * and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.*/

SELECT 
first_name,
last_name,
fte_hours,
salary,
CONCAT(fte_hours*salary) AS effective_yearly_salary
FROM employees 
WHERE first_name IS NOT NULL and last_name IS NOT NULL;

/*Question 16.
The corporation wants to make name badges for a forthcoming conference. 
Return a column badge_label showing employees’ first_name and last_name joined together with their department in the following style: 
‘Bob Smith - Legal’. Restrict output to only those employees with stored first_name, last_name and department.
*/

SELECT
CONCAT(first_name,' ', last_name, ' - ', department) AS badge_label
FROM employees 
WHERE first_name IS NOT NULL
AND last_name IS NOT NULL 
AND department IS NOT NULL;

/*
Question 17.
One of the conference organisers thinks it would be nice to add the year of the employees’ start_date to the badge_label to celebrate long-standing colleagues, 
in the following style ‘Bob Smith - Legal (joined 1998)’. Further restrict output to only those employees with a stored start_date.

[If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal (joined July 1998)’]

Hints*/

SELECT EXTRACT(YEAR FROM start_date) AS start_year
FROM employees

SELECT 
CONCAT(first_name, EXTRACT(YEAR FROM start_date))
FROM employees;


SELECT 
CONCAT(first_name,' ', last_name, ' - ', department, ' joined (', EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees 
WHERE first_name IS NOT NULL
AND last_name IS NOT NULL 
AND department IS NOT NULL;



/*
Question 18.
Return the first_name, last_name and salary of all employees together with a new column called salary_class with a value 'low' where salary is less than 40,000 and value 'high' where salary is greater than or equal to 40,000.
 */*/
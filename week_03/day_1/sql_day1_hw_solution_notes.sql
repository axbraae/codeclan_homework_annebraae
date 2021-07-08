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

/*answer has the below. They give the same result*/
SELECT 
COUNT(id) AS portugal_employees
FROM employees 
WHERE country = 'Portugal';

/* MVP */
/* Q4 */
/* Count the number of employees based in either Portugal or Spain. */

SELECT 
COUNT(*) AS employees_port_spain
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';


/*answer has the below. They give the same result*/
SELECT 
COUNT(id) AS employees_port_spain
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';

/* MVP */
/* Q5 */
/*Count the number of pay_details records lacking a local_account_no.*/

SELECT 
COUNT (*) AS pay_details_no_acc
FROM pay_details 
WHERE local_account_no IS NULL;


/*answer has the below. They give the same result*/
SELECT 
  COUNT(id) AS num_pay_details_no_local_acct
FROM pay_details
WHERE local_account_no IS NULL


/* MVP */
/* Q6 */
/*Are there any pay_details records lacking both a local_account_no and iban number?*/

SELECT 
COUNT(*) AS missing_acc_iban
FROM pay_details 
WHERE local_account_no IS NULL
AND iban IS NULL;

/*Ans: No. */

/*MVP*/
/*Q7*/
/*Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).*/

SELECT first_name, last_name 
FROM employees 
ORDER BY last_name ASC NULLS LAST;

/* MVP */
/* Q8 */
/*Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).*/

SELECT first_name, last_name, country
FROM employees 
ORDER BY country ASC NULLS LAST,
last_name ASC NULLS LAST;

/* MVP */
/* Q9 */
/*Find the details of the top ten highest paid employees in the corporation.*/

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;

/* MVP */
/* Q10 */
/*Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/

SELECT *
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

/* MVP */
/* Q11 */
/*How many employees have a first_name beginning with ‘F’?*/

SELECT
COUNT(*) AS employees_F
FROM employees 
WHERE first_name LIKE 'F%';

/* MVP */
/*Q12*/
/*Find all the details of any employees with a ‘yahoo’ email address?*/

SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';

/* MVP */
/*Q13*/
/*Count the number of pension enrolled employees not based in either France or Germany.*/

SELECT 
COUNT(*) AS french_german_pension_enrolled
FROM employees 
WHERE country != 'France' OR country != 'Germany'
AND pension_enrol = TRUE;

/* MVP */
/*Q14*/
/*What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?*/

SELECT 
MAX(salary) AS max_salary_eng_fte
FROM employees 
WHERE department = 'Engineering'
AND fte_hours = 1;

/* MVP */
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

/*When use CONCAT returns a character vector not a number! You can just put fte_hours*salary AS effective_yearly_salary to retain the class structure.
 * Should NOT remove the IS NOT NULL because this is not asked for here.*/

/* Extension */
/*Q16
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

/* Extension */
/*
Q17
One of the conference organisers thinks it would be nice to add the year of the employees’ start_date to the badge_label to celebrate long-standing colleagues, 
in the following style ‘Bob Smith - Legal (joined 1998)’. Further restrict output to only those employees with a stored start_date.*/

SELECT 
CONCAT(first_name,' ', last_name, ' - ', department, ' (joined ', EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees 
WHERE first_name IS NOT NULL
AND last_name IS NOT NULL 
AND department IS NOT NULL;

/*[If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal (joined July 1998)’]*/
/*I tried, but the below 'works' but the spacing is weird.*/
SELECT  
CONCAT(first_name,' ', last_name, ' - ', department, ' (joined ', 
	TO_CHAR(start_date, 'FMMonth'), ' ',
	EXTRACT(YEAR FROM start_date), ')') 
	AS badge_label
FROM employees 
WHERE first_name IS NOT NULL
AND last_name IS NOT NULL 
AND department IS NOT NULL;

/*The secret is the FMMonth which removes the spaces from around the month*/

/* Extension */
/*
Q 18.
Return the first_name, last_name and salary of all employees together with a new column called salary_class with a value 'low' where salary 
is less than 40,000 and value 'high' where salary is greater than or equal to 40,000.
 */
 
SELECT  
first_name,
last_name,
salary,
CASE 
	WHEN salary < 40000 THEN 'low'
	WHEN salary >= 40000 THEN 'high'
END AS salary_class
FROM employees 
WHERE first_name IS NOT NULL
AND last_name IS NOT NULL 
AND salary IS NOT NULL;

/*I threw away the NULL salary. Better to retain this information with the else statement as in the solution*/

SELECT 
  first_name, 
  last_name, 
  CASE 
    WHEN salary < 40000 THEN 'low'
    WHEN salary IS NULL THEN NULL
    ELSE 'high' 
  END AS salary_class
FROM employees

/*OR like so*/

SELECT  
first_name,
last_name,
salary,
CASE 
	WHEN salary < 40000 THEN 'low'
	WHEN salary >= 40000 THEN 'high'
	ELSE NULL
END AS salary_class
FROM employees 
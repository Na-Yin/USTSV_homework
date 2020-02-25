-- LinkedIn interview questions

-- Table:
-- Employee -- employee_id, name, job_title, level_sk, dept_sk, manager_id, location_sk, salary, start_date, tenu_date
-- Level -- level_sk, level_name
-- Department -- dept_sk, dept_name
-- Location -- location_sk, city, state, country

-- 1. Select the employee in each department with the highest salary in the us include employee name, department name, and salary in output
SELECT e.name, d.dept_name, MAX(e.salary) FROM employee e
LEFT JOIN department d
ON e.dept_sk = d.dept_sk
LEFT JOIN location l 
ON e.location_sk = l.location_sk
WHERE country = 'US'
GROUP BY d.dept_name;

-- 2. Same as above, top 5
SELECT A.name, A.dept_name, A.salary FROM
(SELECT *, DENSE_RANK() OVER (PARTITION BY e.dept_sk ORDER BY e.salary DESC) AS salary_rank FROM employee e
LEFT JOIN location l 
ON e.location_sk = l.location_sk
WHERE country = 'US' AND salary_rank <= 5) A
LEFT JOIN department d
ON a.dept_sk = d.dept_sk;

-- 3. Create a table in database with information from all tables for department of BizOPS
CREATE TABLE ALL_INFO_BioOPS SELECT * FROM
(SELECT E.*, Le.level_name, D.dept_name, Lo.city, Lo.state, Lo.country FROM employee e 
LEFT JOIN level l 
ON e.level_sk = Le.level_sk
LEFT JOIN department d 
ON e.dept_sk = d.dept_sk
LEFT JOIN location Lo 
ON e.location_sk = Lo.location_sk
WHERE d.dept_name = 'BizOPS') A;

-- 4. Pull a list of mangers and their direct reports in the output
SELECT employee_id, manager_id FROM employee e1
JOIN employee e2
ON e1.employee_id = e2.manager_id;

-- 5. Find the number of employees that started at the company each quarter
SELECT COUNT(DISTINCT employee_id) FROM employee
GROUP BY QUARTER(start_date);

-- 6. Find the average tenure (how many days the person worked here) of all employee by level. If an employee is still at the company tenu_date is null, use today's date to calculate tenure.
SELECT AVG(DATEDIFF(CASE WHEN tenu_date IS NULL THEN CURDATE() ELSE tenu_date END, start_date)) FROM employee
GROUP BY level_sk;

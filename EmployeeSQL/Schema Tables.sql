-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- CREATE TABLES for six csv files

-- Create Employees Table
-- An employee can work only one department, however, they are some exceptions at times
-- One to many
CREATE TABLE employees (
    emp_no INT  NOT NULL ,
    emp_title_id VARCHAR(100)  NOT NULL ,
    birth_date DATE  NOT NULL ,
    first_name VARCHAR(50)  NOT NULL ,
    last_name VARCHAR(50)  NOT NULL ,
    sex VARCHAR(1)  NOT NULL ,
    hire_date DATE  NOT NULL ,
    PRIMARY KEY (
        emp_no
    )
);

-- Create Departments Table
-- There will always be more than one department
CREATE TABLE departments (
    dept_no VARCHAR(10)  NOT NULL ,
    dept_name VARCHAR(50)  NOT NULL ,
    PRIMARY KEY (
        dept_no
    )
);

-- Create Department Employee Table
-- One department can have many employees this is a one to many relationship, therefore, requires 2 PK
CREATE TABLE dept_emp (
    emp_no INT  NOT NULL ,
    dept_no VARCHAR  NOT NULL ,
    PRIMARY KEY (
        emp_no,dept_no
    )
);

-- Create Department Manager Table
-- Managers can have more than one employee so this would be a one to many relationship
CREATE TABLE dept_manager (
    dept_no VARCHAR  NOT NULL ,
    emp_no INT  NOT NULL ,
    PRIMARY KEY (
        dept_no,emp_no
    )
);
-- Create title table
-- Title Table
CREATE TABLE title (
    title_id VARCHAR  NOT NULL ,
    title VARCHAR(100)  NOT NULL ,
    PRIMARY KEY (
        title_id
    )
);

-- Create Salary Table
-- One to One 
CREATE TABLE salaries (
    emp_no INT  NOT NULL ,
    salary Float  NOT NULL ,
    PRIMARY KEY (
        emp_no
    )
);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES title (title_id);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

-- Run to get Department Numbers for Sales and Developement 
SELECT * FROM departments
-- Run to get managers employee number
SELECT * FROM title

-- SELECT employees.emp_no 
-- FROM employees
-- LEFT JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
-- INNER JOIN salaries ON salaries.emp_no = dept_emp.emp_no
-- JOIN dept_manager ON dept_manager.emp_no = dept_emp.emp_no

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary
-- Join employee and salaries tables together
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
JOIN salaries as s ON e.emp_no = s.emp_no LIMIT (5);

-- 2. List first name, last name, and hire date for employees who were hired in 1986. 
SELECT e.first_name AS employee_first_name, e.last_name AS employee_last_name, e.hire_date AS employee_hire_date
FROM employees as e
WHERE DATE_PART('year',hire_date) = 1986 LIMIT (5);

-- 3. List the manager of each department with the following information: department number, department name,
-- the manager's employee number, last name, first name.
-- Join all three tables
SELECT dm.dept_no, d.dept_name, dm.emp_no AS manager_employee_number, e.last_name AS manager_last_name, e.first_name AS manager_first_name
FROM dept_manager as dm
JOIN departments as d ON dm.dept_no = d.dept_no
JOIN employees as e ON dm.emp_no = e.emp_no;

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
-- Join all three tables 
SELECT e.emp_no AS employee_number, e.last_name AS employee_last_name, e.first_name AS employee_first_name, d.dept_name
FROM employees as e JOIN dept_emp ON e.emp_no = dept_emp.emp_no
JOIN departments as d ON dept_emp.dept_no = d.dept_no LIMIT(10);

-- 5. List first name, last name, and sex for employees whose 
-- first name is "Hercules" and last names begin with "B."
SELECT e.first_name AS employee_first_name_start_with_Hercules, e.last_name AS employee_last_name_start_with_B, e.sex
FROM employees as e
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department,including their employee number, 
-- last name, first name, and department name.
SELECT e.emp_no, e.last_name AS employee_last_name, e.first_name AS employee_first_name, d.dept_name AS sales_dept
FROM employees as e
JOIN dept_emp ON e.emp_no = dept_emp.emp_no JOIN departments as d ON dept_emp.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' LIMIT (5);

-- 7. List all employees in the Sales and Development departments, including their employee number,
-- last name, first name, and department name.
SELECT e.emp_no AS employee_number, e.last_name AS employee_last_name, e.first_name AS employee_first_name, d.dept_name
FROM employees as e
LEFT JOIN dept_emp ON e.emp_no = dept_emp.emp_no
INNER JOIN departments as d ON d.dept_no = dept_emp.dept_no
WHERE d.dept_no = 'd007' or d.dept_no = 'd005' LIMIT(10);

-- 8. In descending order, list the frequency count of employee last names, i.e.,
-- how many employees share each last name.
SELECT last_name AS e_last_name, COUNT(last_name) AS "count_of_employees_who_share_last_name"
FROM employees as e
GROUP BY last_name
ORDER BY "count_of_employees_who_share_last_name" DESC LIMIT(10);


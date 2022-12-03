-----------------------------------
-----------------------------------
-- ORACLE DATABASE SQL - 1Z0-071 --
-----------------------------------
-----------------------------------


-----------------------------------
-- USING BASIC SELECT STATEMENTS --
-----------------------------------

-- Use a basic SELECT statement to retreive all records from a table
SELECT * FROM Employees;

-- Select only desired columns
SELECT Employee_ID, First_Name, Last_Name
FROM Employees
WHERE Hire_Date >= '08-01-01' -- 1st January 2008
ORDER BY Hire_Date Desc;

-- Statement with the calculation of 500x12 first (equals 600),
-- then adds 6000 to the salary

SELECT Employee_ID, First_Name, Last_Name, Salary, (Salary + 500) * 12
FROM Employees;

-- Literal characters can aslso begit the select list
SELECT 'Employee: ' || First_Name || ', ' || Last_Name || ' - Salary: ' || Salary AS "Payment"
FROM Employees;

-- Find all employees with salary between and order from the highest
SELECT * FROM Employees
WHERE Salary >= 10000 AND SALARY <= 20000 -- Alternative BETWEEN 10000 AND 20000
ORDER BY Salary DESC;

-------------------------------------
-- Data Definintion Language (DDL) --
-------------------------------------

-- Creating Customer table
CREATE TABLE Customers(
	cust_id NUMBER(4),
	fn VARCHAR(25),
	ln VARCHAR(25),
	street VARCHAR(30),
	city VARCHAR(25),
	state_prov CHAR(2),
	create_date Date
);

-- Creating a table with subquery
CREATE TABLE Finance_Department
AS
SELECT employee_id, ln, (salary*12) AS "Annual Salary"
FROM Employees
WHERE department_id = 100;
COMMIT;

-------------------------------------
----- (3) MANIPULATING DATA ---------
-------------------------------------

-- Insert a null
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (350, 'Test Dep', null, 1700)

-- Inserting special values
INSERT INTO EMPLOYEES(EMPLOYEE_ID, FN, LN, EMIAL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISION_PCT, MANAGER_ID,DEPARTMENT_ID)
VALUES((250, 'Test', 'Employee', 'TEMPLOYEE', '123.456.789', SYSDATE, 'AC_MGR,10000, .25, 101, 110

-- Updating a value
UPDATE DEPARTMENTS
SET DEPARTMENT_NAME = 'Research and Development'
WHERE DEPARTMENT_ID = 350;

-- Delete all records from the table
DELETE FROM DEPARTMENTS;

-- Undo the delete opeartion
ROLLBACK;

-- Commit the delete operation
COMMIT;

-- Using a SAVEPOINT
SELECT * FROM DEPARTMENTS;

-- Insert a new record
INSERT INTO DEPARTMENTS VALUES(360, 'Quality Control', null, null);

-- Create a savepoint to 'protect' the new record
SAVEPOINT after_insert;

-- Delete an existing record
DLETE FROM DEPARTMENTS
WHERE DEPARTMENT_ID = 350;

-- Discard the delete opearation without discarding the earlier insert opeartion
ROLLBACK TO after_insert;

-----------------------------------------
--- (4) Restricting and Sorting Data ----
-----------------------------------------

-- Using character strings and dates in a WHERE clause
-- Both are enclosed in single quotes, characters are case-sensitive and dates
-- are format sensitive
SELECt job_id, department_id
FROM EMPLOYEES
WHERE last_name = 'Whalen';

-- If uncertain about the date fromat, select without the WHERE cluase to verify
SELECT last_name, job_id, hire_date
FROM EMPLOYEES
WHERE hire_date = '07-05-21';

-- Using the BETWEEN... AND... comparison operators in a WHERE cluase
SELECT last_name, salary
FROM EMPLOYEES
WHERE salary BETWEEN 3000 and 5000; WHERE salary >=3000 AND salary <=5000

-- Using the IN() comparison operator, each value must still be placed in single quotes for characters
SELECT last_name, job_id, department_id
FROM EMPLOYEES
WHERE last_name IN('Austin', 'King', 'Ernst');

-- Using the IS NULL logical operator to search for nulls
SELECT last_name, job_id, manager_id
FROM EMPLOYEES
WHERE manager_id IS NULL;

-- Using the AND logical operator requires that ALL conditions be met
-- AND conditions will almost always result in fewer records returned
SELECT first_name, last_name, job_id
FROM EMPLOYEES
WHERE first_name = 'Steven' AND last_name = 'King';

-- Using the OR logical operator requires that ANY (one or more) conditions be met
-- OR conditionswill almost always result in more records returned
SELECT first_name, last_name, job_id
FROM EMPLOYEES
WHERE first_name = 'Steven' OR job_id = 'ST_CLERK';

--------------------------------------------------------
-- (5) Using single-row functions to customize output --
--------------------------------------------------------

-- Working with character manipulation functions
SELECT last_name, CONCAT('Job category: ',job_id) AS "Job"
FROM EMPLOYEES
WHERE SUBSTR(job_id,4) = 'REP';

SELECT CONCAT(first_name, last_name) AS "Name",
LENGTH(last_name) AS "Length of last name",
INSTR(last_name, 'a') AS "Contains an 'a' at position:" -- This reports where an "a" is found in the last name (rembmer case-sensitive!)
FROM EMPLOYEES
WHERE SUBSTR(last_name, -1,1) = 'n'; -- Reads as "where the last character of the last name is 'n';

-- Using nested functions
SELECT UPPER(CONCAT(SUBSTR(first_name, 1, 3))) AS "Username"
FROM EMPLOYEES;

-- Working with the numeric ROUND and TRUNC functions
SELECT salary/2.7,2)
FROM EMPLOYEES;

SELECT ROUND(salary/2.7,2)
FROM EMPLOYEES;

SELECT TRUNC(slary/2.7,2)
FROM EMPLOYEES;

-- Use a calculation to determine how long an employee has been working
SELECT last_name, (sysdate-hire_Date) AS "length employed"
FROM EMPLOYEES;

-- Divide by desired valued to produce more meaningful results
SELECT last_name, ROUND(sysdate-hire_Date)/365) AS "Years employed"
FROM EMPLOYEES;

---------------------------------------------------------
-- (6) Using conversion functions and conditional expr --
---------------------------------------------------------

-- View the salary in its native format
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM EMPLOYEES;

-- Using the TO_CHAR function to format a numeric value as characters
SELECT EMPLOYEE_ID, LAST_NAME, TO_CHAR((SALARY*12), '$999,999.00') AS "Salary"
FORM EMPLOYEES;

-- Available numeric formatting options:
-- 9: Represents any digits 0-9
-- 0: Forces a zero
-- $: Places a dollar sign into the value
-- L: Places a local currency symbol into the value
-- .(period): Places a decimal into the value
-- ,(comma): Places a comma separator into value

-- Select the data in its native format
SELECT Last_Name, Salary, Commision_pct
FROM EMPLOYEES;

-- Using the NVL function to change the NULL to an actual value
SELECT Last_Name, Salary, NVL(Commision_pct, ) AS "Commision %"
FROM EMPLOYEES;

-- Using NVL2, to convert to different values depending on whether a null appears
SELECT Last_Name, Salary, Commision_pct, NVL2(Commision_pct, 'Salary + Comm', 'Salary Only') AS "Income Type"
FROM EMPLOYEES;

-- Using a CASE statement to produce multiple new salaries based on their current position
SELECT last_name AS "Employee", job_id, salary,
	CASE job_id
		WHEN 'IT_PROG' THEN 1.10 * salary
		WHEN 'ST_CLERK' THEN 1.15 * salary
		WHEN 'SA_REP' THEN 1.20 * salary
		ELSE salary
	END
	AS "Revised Salary"
FROM EMPLOYEES;

--------------------------------------------------------
-- (7) Reporting aggregated data using the group func --
--------------------------------------------------------

--Using the SUM and AVG group functions

SELECT SUM(salary) AS "Sum of Rep Salaries", AVG(salary) AS "Average Rep Salary"
FROM EMPLOYEES
WHERE job_id LIKE '%REP%';

--Using teh COUNT and COUNT(DISTINCT) group functions

--COUNT with a column or expression specified does not reutrn nulls but deos include duplicates
SELECT COUNT(commision_pct) AS "Number of Employees Earning Commision"
FROM EMPLOYEES;

SELECT COUNT(location_id) AS "Total Number od Departments in all Locations"
FROM DEPARTMENTS;

SELECT COUNT(DISTINCT lcoation_id) AS "Number of Locations with Departments"
FROM DEPARTMENTS;

--Using the GROUP BY clause to break down group functions by other columns

--Returns a total for EACH department, representing the total cost of all salaries witin that department
SELECT department_id, SUM(salary) AS "Total Salary per Department"
FROM EMPLOYEES
GROUP BY deparment_id
ORDER BY "Total Salary per Department" DESC

--Restricting the rows returned by the group functions with a HAVING clause
--A WHERE clause cannot reference the group function column

SELECT department_id, SUM(salary) AS "Total Salary per Department"
FROM EMPLOYEES
GROUP BY department_id
HAVING SUM(salary) >= 25000
ORDER BY "Total Salary per Department" DESC;

--------------------------------------------------
-- (8) Displaying data form multiple tables ------
--------------------------------------------------

--Access Data from Tables

--Joining two tables with a Natural Join
SELECT Employee_ID, Last_name, Job_ID, Job_Title
FROM EMPLOYEES
NATURAL JOIN JOBS
ORDER BY Employee_ID;

--Joining two tables with an ON clause
SELECT Employee_ID, Last_name, Location_ID, e.Department_ID
FROM EMPLOYEES e
JOIN DEPARTMENTS d
On e.Department_ID = d.Department_ID
ORDER BY Employee_ID;

--Left outer join
SELECT e.last_name, d.department_id, d.department_name
FROM EMPLOYEES e
LEFT OUTER JOIN DEPARTMENTS d
ON e.department_id = d.department_id;

--Right outer join
SELECT e.last_name, d.deparment_id, d.department_name
FROM EMPLOYEES e
RIGHT OUTER JOIN DEPARTMENTS d
ON e.department_id = d.department_id;

--Self join
SELECT Worker.Last_name AS "Worker", Manager.Last_name AS "Reports To"
FROM EMPLOYEES Worker
JOIN EMPLOYEES Manager
ON(Worker.Manager_ID = Manger.Employee_ID)
ORDER BY Manager.Last_name;

---------------------------------------------------
--- (9) Using subqueries to solve queries ---------
---------------------------------------------------

--Manipulating Data Using Subqueries

--Executing single-row subqueries - the inner query must only return a single value to the outer query
--Reads as 'return all employees who have the same job as employee Bates (The job_id of Bates is unknown)
SELECT last_name, job_id, salary
FROM EMPLOYEES
WHERE job_id = (SELECT job id
		FROM EMPLOYEES
		WHERE last_name = 'Bates');

--Using the IN, ANY or ALL operators in a multi-row subqery
--The inner query returns mulitple rows (the minimum salary for EACH department)
--Therefore an equality operator cannot be used in the WHERE clause. IN accepts multiple values 
--Reads as return all employees who earn the equivalent of any departmental minimum
SELECT last_name, job_id, salary
FROM EMPLOYEES
WHERE job_id IN (SELECT MIN(salary)
		FROM EMPLOYEES
		GROUP BY department_id);

--Using a multi-column subquery
--In this example the inner query is retrieving multiple columns
--therefore the WHERE clause must have matching columns for comparison, but this avoids having to construct separate WHERE clauses
--Reads as "return all employees who earn the equivalent of their own departmental minimum"
SELECT first_name, department_id, salary
FROM EMPLOYEES
WHERE (salary, department_id) IN
	(SELECT MIN(salary), department_id
	FROM EMPLOYEES
	GROUP BY department_id)
ORDER BY department_id;

--Use a correlated update subquery to update one table, based on values from another table
--A correlated subquery occurs when the inner query depends on the outer query. The EMP_COPY table in this case
--Is only stated in the outer query (aliases as 'e', yet the inner query references e.department_id.
--In a correlated subquery the inner query cannot be executed on its own
UPDATE EMP_COPY e
SET department_name = (SELECT department_name
			FROM department d
			WHERE e.department_id = d.department_id);

SELECT * FROM EMP_COPY;

-----------------------------------------------
-- (10A) Managing Schema Objects ---------------
-----------------------------------------------

--Creating a PRIMARY KEY constraint (receieves a system generated name)
ALTER TABLE EMP_COPy
MODIFY employee_id PRIMARY KEY;

--Alternate code to create a primary key constraint (user-defined name)
ALTER TABLE EMP_COPY
ADD CONSTRAINT emp_id_pk
PRIMARY KEY (employee_id)

--Disable constraints to simply "turn them off" temporarily
ALTER TABLE DEPARTMENTS
DISABLE CONSTRAINT DEPT_LOC_FK;

--Disable the primary key, and cascade to disable any associated foreign keys
ALTER TABLE LOCATIONS
ENABLE PRIMARY KEY;

--Re-enable foreign key
ALTER TABLE DEPARTMENTS
ENABLE CONSTRAINT DEPT_LOCK_FK;

--Manually creating an index on the last_name column
CREATE INDEX emp_last_name_idx
ON EMP_COPY(last_name);

--Determine the structure of the USER_INDEXES data dictionary table
DESCRIBE USER_INDEXES;

--View specific index properties
SELECT index_name, index_type, table_name
FROM USER_INDEXES
WHERE table_name = 'EMPLOYEES';

--Create a directory object in the database to represent the file system directory (path to data file)
CREATE DIRECTORY old_emps AS '/home/oracle/Documents/Emp_Dir';

--If necesarry grant read permission to user or role
GRANT READ ON DIRECTORY old_emps TO User1;

--Create the external table, the column order must match the order in the datafile
CREATE TABLE old_emps (emp_id INTEGER, last_name VARCHAR(20), first_name VARCHAR(20))
ORGANIZATION EXTERNAL
(
TYPE ORACLE_LOADER
DEFAULT DIRECTORY old_emps
LOCATION ('Old_Emps.dat')
)

-----------------------------------------------
-- (10B) Creating Other Schema Objects --------
-----------------------------------------------

--To create a view, simpy "wrap" your SELECT statement in the CREATE VIEW AS statement
CREATE VIEW emp_view_dept_80
AS
SELECT employee_id, last_name, salary
FROM EMPLOYEES
WHERE departement_id = 80;

--Verify data is retreived from the view
SELECT * FROM emp_view_dept_80;

--Create an independent and reusable numeric sequence to automatically generate ne values in a table

CREATE SEQUENCE id_seq
START WITH 280
INCREMENT BY 10
MAXVALUE 1000;

--Verify existing values
SELECT * FROM DEPARTMENTS
ORDER BY department_id DESC;

--Use the sequence to insert a new record
INSERT INTO DEPARTMENTS (department_id, department_name, manger_id, lcoation_id)
VALUES (id_seq.NEXTVAL, 'Testing', null, 2500);

--Use ALTER SEQUENCE to modify the properties of an existing sequence
--NOTE: The START WITH property is not supported by the Alter Sequence statement
--If this need to be changed the sequence would have to be dropped and recreated
--but be careful when dropping any object, ensure it is safe to do so

ALTER SEQUENCE id_seq
--START WITH 280 - not supported
INCREMENT BY 20
MAXVALUE 2000;

--Use the 'user_sequences' system view to see properties of sequences in database

--Determine which properties about sequences you are interested in seeing
DESCRIBE user_sequences;

--Retrive a list of sequences by their name
SELECT sequence_name
FROM user_sequnces;

--Retrive various properties about the sequnces
SELECT max_value, increment_by
FROM user_sequences
WHERE sequence_name = 'ID_SEQ';

------------------------------------------
-- (11) Using the set operators ----------
------------------------------------------

-- A UNION combines the result sets of both queries, but removes duplicates
-- 107 employees, 7 retired, 6 duplicates, 108 returned
SELECT Employee_ID, Last Name, Job_ID
FROM EMPLOYEES
UNION
SELECT Employee_ID, Last Name, Job_ID
FROM RETIRED_EMPLOYEES;

-- A UNION ALL combines ALL records from both record sets including duplicates
-- 107 employees PLUS the 7 retired, 114 returned
SELECT Employee_ID, Last Name, Job_ID
FROM EMPLOYEES
UNION ALL
SELECT Employee_ID, Last Name, Job_ID
FROM RETIRED_EMPLOYEES;

-- An INTERSECT combines only the records that are common to both tables
-- 7 retired employees, only 1 unique, 6 duplicates
SELECT Employee_ID, Last Name, Job_ID
FROM EMPLOYEES
INTERSECT
SELECT Employee_ID, Last Name, Job_ID
FROM RETIRED_EMPLOYEES;

-- A MINUS operator returns only records from the first table that NOT redundantly
-- appear in the second table (107 employees, but 6 are duplicated in the 
-- RETIRED_EMPLOYEES table, 107-6=101 records returned
SELECT Employee_ID, Last Name, Job_ID
FROM EMPLOYEES
MINUS
SELECT Employee_ID, Last Name, Job_ID
FROM RETIRED_EMPLOYEES;

-- The ORDER BY must appear at the end of the entire statement, but must reference a column
-- in the first SELECT statement
SELECT location_id, department_name, TO_CHAR(null) "Warehouse Location"
FROM DEPARTMENTS
UNION
SELECT location_id, TO_CHAR(null) "Department", state_province
FROM LOCATIONS
ORDER BY "Warehouse Location"

--------------------------------------------------------
--- (12) Managing Objects with Data Dictionary Views ---
--------------------------------------------------------

-- Querying various Data Dictionary views, note the data is case-sensitive
-- when using WHERE clause
DESCRIBE user_tables;

SELECT table_name, backed_up
FROM user_tables;

DESCRIBE user_tab_columns;

SELECT columns_name, data_type
FROM user_tab_columns
WHERE table_name = 'EMPLOYEES';

DESCRIBE user_constraints;

SELECT constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE table_name = 'EMPLOYEES';

-- Adding comments to a table
COMMENT ON TABLE EMPLOYEES
IS 'This table contains employee data'

-- View by selecting from all_tab_comments, or user_tab_comments
SELECT * FROM all_tab_comments

-- Adding comments to a column
COMMENT ON COLUMN EMPLOYEES.first_name
IS 'First name of the employee, must not contain a null';

-----------------------------------------------------
--- (13) Manipulating Data Using Advanced Queries ---
-----------------------------------------------------

-- Using an unconditional INSERT ALL multi-table insert

INSERT ALL
INTO SAL_HISTORY VALUES (emoid, hiredate, sal)
INTO MGR_HISTORY VALUES (empid, mgr, sal)

SELECT employee_id, empid, hire_date hiredate, salary sal, manager_id mgr
FROM EMPLOYEES
WHERE employee_id > 200

-- Verify records were inserted

SELECT * FROM SAL_HISTORY;
SELECT * FROM MGR_HISTORY;


-- Using a conditional INSERT FIRST multi-table insert

INSERT FRIST

WHEN salary < 5000 THEN
	INTO SAL_LOW VALUES (employee_id, last_name, salary)

WHEN salary BETWEEN 5000 AND 10000 THEN
	INTO SAL_MID VALUES (employee_id. last_name, salary)

ELSE
	INTO SAL_HIGH VALUES (employee_id, last_name, salary)

SELECT employee_id, last_name, salary
FROM EMPLOYEES;

-- Verify records were inserted
SELECT * FROM SAL_LOW;
SELECT * FROM SAL_MID;
SELECT * FROM SAL_HIGH;

-- Dropped objects are not pernamently and irrevocably removed. Query the RECYCLEBIN
-- to determine which objects can be restored

SELECT original_name, operation
FROM RECYCLEBIN;

-- Use the FLASHBACK TABLE statement to restore the dropped object
FLASHBACK TABLE CUSTOMERS TO BEFORE DROP;

-- Verify table and records have been restored
SELECT * FROM CUSTOMERS;

-- Using the VERSIONS BETWEEN clause to track the history
-- of changes to a value

SELECT versions_startime AS "Start Date", versions_endtime AS "End Date", salary
FROM EMP_COPY
VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE
WHERE last_name = 'Landry';

UPDATE EMP_COPY
SET salary = 3200
WHERE last_name = 'Landry';

COMMIT;

-- Verify current value

SELECT salary
FROM EMP_COPY
WHERE last_name = 'Landry';

-- PIVOTING

-- View source data
SELECT * FROM SALES_SOURCE_DATA;

-- Verify target data
SELECT * FROM SALES_INFO

INSERT ALL
INTO SALES_INFO VALUES (emp_id, week_id, mon)
INTO SALES_INFO VALUES (emp_id, week_id, tue)
INTO SALES_INFO VALUES (emp_id, week_id, wed)
INTO SALES_INFO VALUES (emp_id, week_id, thu)
INTO SALES_INFO VALUES (emp_id, week_id, fri)

SELECT emp-id, week_id, mon, tue, wed, thu, fri
FROM SALES_SOURCE_DATA;

------------------------------------------
---- (14) Controlling User Access --------
------------------------------------------


-- Create a new user
CREATE USER new_user1
IDETIFIED BY new_password;

-- Grant system privileges to the new user
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW
TO new_user1;

-- Create a new role
CREATE ROLE managers1;

-- Grant system priveleges to the new role
GRANT CREATE TABLE, CREATE VIEW
TO managers1;

-- Create a new user
CREATE USER new_user2
IDETIFIED BY u1_password;

-- Grant a role to a user (add the user to the role)
GRANT managers
TO user2;

-- To change Alice's password, use the ALTER USER command
ALTER USER user2
IDENTIFIED BY new_u1_password;

-- Passing along granted object privileges to other user via the WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE
ON EMPLOYEES
TO user2
WITH GRANT OPTION;

-- Revoking object privileges
REVOKE SELECT, INSERT, UPDATE
ON EMPLOYEES
FROM user2;

-- Revoking system privileges
REVOKE CREATE SESSION, CREATE TABLE, CREATE VIEW
FROM new_user1;

-- Revoking role privileges
REVOKE CREATE TABLE, CREATE VIEW
FROM manangers1;
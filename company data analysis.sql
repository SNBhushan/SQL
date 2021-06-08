CREATE TABLE employee(
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(20),
  laSt_name VARCHAR(20),
  birth_date DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);
----------------BRANCH TABLE--------------------------------------------

CREATE TABLE Branch(
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(20),
  mgr_id INT ,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL

);

---------ADDING FOREIGN KEY --------------------------------------------
ALTER TABLE employee
ADD FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
ON DELETE SET  NULL;

ALTER TABLE employee
ADD FOREIGN KEY (super_id) REFERENCES employee(emp_id) 
ON DELETE SET NULL;

-----------------------CLIENT TABLE-------------------------------------
CREATE TABLE client(
client_id INT PRIMARY KEY,
client_name VARCHAR(20),
branch_id INT,
FOREIGN KEY (branch_id) REFERENCES Branch(branch_id) 
ON DELETE SET NULL

);

-----------------WORKS_WITH TABLE ---------------------------------

CREATE TABLE works_with(
emp_id INT,
client_id INT,
total_sales INT,
PRIMARY KEY (emp_id,client_id),
FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY (client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

-------BRANCH_sUPPLIER TABLE------------------------------------------
CREATE TABLE branch_supplier(
branch_id INT,
supplier_name VARCHAR(30),
supply_type VARCHAR(30),
PRIMARY KEY(branch_id,supplier_name),
foreign key (branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE
);

----------------------INSERTING ATTRIBUTES------------------------
INSERT INTO employee VALUES(100,'david','wallace','1967-11-17','M',250000,NULL,NULL);
INSERT INTO Branch VALUES(1,'corporate',100,'2006-02-09');

UPDATE employee
SET branch_id=1
WHERE emp_id=100; 

INSERT INTO employee VALUES(101,'jan','levinson','1961-05-11','F',110000,100,1);
 
INSERT INTO employee VALUES(102,'michael','scott','1964-03-15','M',75000,100,NULL);
INSERT INTO Branch VALUES (2,'scrantion',102,'2006-02-09');

UPDATE employee
SET branch_id=2
WHERE emp_id=102;
INSERT INTO employee VALUES(103,'angela','martin','1971-06-25','F',63000,102,2);
INSERT INTO employee VALUES(104,'kelly','kapoor','1980-02-05','F',55000,102,2);
INSERT INTO employee VALUES(105,'stanley','hudson','1958-02-19','M',69000,102,2);
INSERT INTO employee VALUES(106,'josh','porter','1969-09-05','M',78000,100,NULL);
INSERT INTO Branch VALUES(3,'stamford',106,'1998-0-13');

UPDATE employee
SET branch_id=3
WHERE emp_id=106;

INSERT INTO employee VALUES(107,'andy','benard','1973-07-22','M',6500,106,3);
INSERT INTO employee VALUES(108,'jim','halpert','1978-10-01','M',71000,106,3);

INSERT INTO client VALUES(400,'Dunmore Hifgschool',2);
INSERT INTO client VALUES(401,'Lackwana Country',2);
INSERT INTO client VALUES(402,'FedEx',3);
INSERT INTO client VALUES(403,'JOhn Daly Law,LLC',3);
INSERT INTO client VALUES(404,'Scranton Whitepapers',2);
INSERT INTO client VALUES(405,'Times Newspaper',3);
INSERT INTO client VALUES(406,'FedEx',2);

INSERT INTO works_with VALUES(105,400,55000);
INSERT INTO works_with VALUES(102,401,267000);
INSERT INTO works_with VALUES(108,402,22500);
INSERT INTO works_with VALUES(107,403,5000);
INSERT INTO works_with VALUES(108,403,12000);
INSERT INTO works_with VALUES(105,404,33000);
INSERT INTO works_with VALUES(107,405,26000);
INSERT INTO works_with VALUES(102,406,15000);
INSERT INTO works_with VALUES(105,406,130000);

INSERT INTO branch_supplier VALUES(2,'Hammer Mill','paper');
INSERT INTO branch_supplier VALUES(2,'Uni-Ball','Writing Utensils');
INSERT INTO branch_supplier VALUES(3,'Patriot Paper','Paper');
INSERT INTO branch_supplier VALUES(2,'J.T.Forms&Labels','Custom Forms');
INSERT INTO branch_supplier VALUES(3,'Uni-Ball','Writing Utensils');
INSERT INTO branch_supplier VALUES(3,'Hammer Mill','Paper');
INSERT INTO branch_supplier VALUES(3,'Stanford Labels','Custom Forms');
 

 SELECT * FROM works_with;
----------FIND ALL EMPLOYEES ORDERED BY SALARY---------------------------------
SELECT * FROM employee
ORDER BY sex,first_name ,laSt_name;
 
 -----------FIND FIRST 5 EMPLOYEES OF THE TABLE-------------------------------
 SELECT * FROM employee
 WHERE emp_id<=105;

 -------------FIND FIRST AND LAST NAME OF EMPLOYESS---------------------------
 SELECT first_name,laSt_name FROM employee;

 -------------FIND FORENAME AND SURNAME FROM EMPLOYEES------------------------
 SELECT first_name AS forename,laSt_name AS surname FROM employee;

 ------------------FIND OUT THE DIFFERENT GENDERS-----------------------------
 SELECT DISTINCT sex FROM employee;
 
 --------------SQL FUNCTIONS--------------------------------------------------

 SELECT COUNT(emp_id) FROM employee;
 SELECT COUNT(super_id) FROM employee;

 ---------------FIND THE NUMBER OF FEMALE BORN AFTER 1970s--------------------
 SELECT COUNT(emp_id) FROM employee
 WHERE sex='F' AND birth_date>'1971-01-01';

 ----------------FIND THE AVERAGE OF ALL EMPLOYEE SALARY----------------------
 SELECT AVG(salary) FROM employee
 WHERE SEX = 'M';

 -----------------FIND SUM OF ALL EMPLOYEES SALARIES---------------------------
 SELECT SUM(salary) FROM employee;
 SELECT * FROM employee;

 --------------FIND OUT HOW MANY MALES AND FEMALES THERE ARE-----------------
 SELECT COUNT(sex),sex FROM employee
 GROUP BY SEX;

 -----------------FIND THE TOTAL SALES OF SALESMAN----------------------------
 SELECT SUM(total_sales),emp_id FROM works_with
 GROUP BY emp_id;

 --------------------FIND ANY CLIENT'S WHO ARE LLC----------------------------
 SELECT * FROM  client
 WHERE client_name LIKE '%LLC';

 ---------FIND ANY BRANCH SUPPILERS WHO ARE IN LABEL BUSINESS-----------------
 SELECT * FROM branch_supplier
 WHERE supplier_name LIKE '%Labels';

 -----------FIND ANY EMPLYOEEE BORN IN OCTOBER--------------------------------
 SELECT * FROM employee
 WHERE birth_date LIKE '____-10%';

 -------------------FIND ANY CLIENTS WHO ARE SCHOOLS--------------------------
 SELECT * FROM client
 WHERE client_name LIKE '%school';

 ---------------FIND A LIST OF EMPLOYEE AND BRANCH NAMES-----------------------
 SELECT first_name FROM employee
 UNION
 SELECT branch_name FROM Branch;
 
 ----------------FIND THE LIST OF ALL CLIENT AND BRANCH SUPPLIER NAME'S--------------
 SELECT client_name ,client_id FROM client
 UNION
 SELECT supplier_name,branch_id FROM branch_supplier;

 -----------FIND THE LIST OF ALL MONEY SPENT OR EARNED BY THE COMPANY---------
 SELECT salary FROM employee
 UNION
 SELECT total_sales FROM works_with;
 --------------------------------------------------------------------------
 INSERT INTO Branch VALUES (4,'Buffalo',NULL,NULL);

 ----------------FIND ALL BRANCHES AND THEIR MANAGERS-------------------------
 SELECT employee.emp_id,employee.first_name,Branch.branch_name
 FROM employee
 RIGHT JOIN Branch
 ON employee.emp_id=Branch.mgr_id;

 --------------- FIND NAMES OF ALL EMPLOYEE HAVE 
 --------------- SOLD OVER 30,000 TO SINGLE CLIENT
SELECT employee.first_name ,employee.laSt_name FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id FROM works_with
    WHERE total_sales>30000
);

 ----FIND ALL THE CLIENTS WHO ARE HANDLED BY THE BRANCH THAT SCOTT MANAGES---
SELECT client.client_name FROM client
WHERE CLIENT.branch_id =(
     SELECT Branch.branch_id FROM Branch
    WHERE Branch.mgr_id=102
    LIMIT 1

);

--------------TRIGGERS--------------------------------------------------------
DELIMITTER $$
CREATE my_trigger BEFORE INSERT 
ON employee 
FOR EACH ROW BEGIN
INSERT INTO trigger_test ('added new employee'); END$$




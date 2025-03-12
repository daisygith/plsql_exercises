
-- LOOP
--1. Write a PL/SQL program to display the names of all departmenst.
DECLARE 
v_departments_name departments.department_name%type;
    CURSOR c1_name IS 
        SELECT department_name FROM departments;
BEGIN
    OPEN c1_name;
    FETCH c1_name INTO v_departments_name;
    
    WHILE c1_name%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_departments_name);
        FETCH c1_name INTO v_departments_name;
    END LOOP;
    CLOSE c1_name;
END;
/

--2.Write a PL/SQL program to display the employee IDs, names, and department names of all employees
DECLARE 
v_departments_title departments.department_name%type;
v_employee_id employees.id%type;
v_first_name employees.first_name%type;
v_last_name employees.last_name%type;

    CURSOR c1_name IS 
        SELECT id, first_name, last_name, departments.department_name FROM employees
        join departments on employees.department_code = departments.department_id
        order by id;
BEGIN
  DBMS_OUTPUT.PUT_LINE('ID | NAME | DEPARTMENT NAME');
  DBMS_OUTPUT.PUT_LINE('-------------------');
    OPEN c1_name;
    FETCH c1_name INTO v_employee_id, v_first_name, v_last_name,v_departments_title;
    
    WHILE c1_name%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_employee_id || '       | ' || v_first_name||' '|| v_last_name || '    | ' || v_departments_title);
        FETCH c1_name INTO v_employee_id, v_first_name, v_last_name,v_departments_title;
    END LOOP;
    CLOSE c1_name;
END;
/

-- 3. Write a PL/SQL program to display department_code and full name order by id;
DECLARE 
v_departments_code employees.department_code%type;
v_first_name employees.first_name%type;
v_last_name employees.last_name%type;

    CURSOR c1_name IS 
        SELECT department_code, first_name, last_name FROM employees order by id;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Department CODE | NAME');
  DBMS_OUTPUT.PUT_LINE('-------------------');
    OPEN c1_name;
    FETCH c1_name INTO v_departments_code, v_first_name, v_last_name;
    
    WHILE c1_name%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_departments_code || '       | ' || v_first_name||' '|| v_last_name);
        FETCH c1_name INTO v_departments_code, v_first_name, v_last_name;
    END LOOP;
    CLOSE c1_name;
END;
/

--4. Write a PL/SQL program to display the employee IDs, names and salaries of all employees.
DECLARE 
v_employee_id employees.id%type;
v_first_name employees.first_name%type;
v_last_name employees.last_name%type;
v_money employees.money%type;


    CURSOR c1_name IS 
        SELECT id, first_name, last_name, money FROM employees order by id;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Department CODE | NAME | SALARY');
  DBMS_OUTPUT.PUT_LINE('-------------------');
    OPEN c1_name;
    FETCH c1_name INTO v_employee_id, v_first_name, v_last_name,v_money;
    
    WHILE c1_name%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_employee_id || '       | ' || v_first_name||' '|| v_last_name || '    | ' || v_money);
        FETCH c1_name INTO v_employee_id, v_first_name, v_last_name,v_money;
    END LOOP;
    CLOSE c1_name;
END;
/

--5. Write a PL/SQL program to display the department IDs, department_names, and manager names of all departments
DECLARE 
    CURSOR c1_name IS 
        SELECT department_id, department_name, CONCAT(employees.first_name,employees.last_name) as manager_name
        FROM departments
        left join employees on departments.manager_id = employees.id 
        ORDER BY departments.department_id;
        
        v_record c1_name%ROWTYPE;
BEGIN
    OPEN c1_name;
    FETCH c1_name INTO v_record;
    
    WHILE c1_name%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_record.department_id);
        DBMS_OUTPUT.PUT_LINE(v_record.department_name);
        DBMS_OUTPUT.PUT_LINE(v_record.manager_name);
        FETCH c1_name INTO v_record;
    END LOOP;
    CLOSE c1_name;
END;
/

--6.Write a PL/SQL program to display the department IDs, names, and the name of the city where the department is located of all departments.
DECLARE 
    CURSOR c1_name IS 
        SELECT department_id, department_name, city
        FROM departments
        ORDER BY department_id;
        
        v_record c1_name%ROWTYPE;
BEGIN
    OPEN c1_name;
    FETCH c1_name INTO v_record;
    
    WHILE c1_name%FOUND 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_record.department_id);
        DBMS_OUTPUT.PUT_LINE(v_record.department_name);
        DBMS_OUTPUT.PUT_LINE(v_record.city);
        FETCH c1_name INTO v_record;
    END LOOP;
    CLOSE c1_name;
END;
/
--7. Write a PL/SQL program to display the average salary for each department. Return department title and average salary in a row.
DECLARE 
v_department_name departments.department_name%type;
v_department_id departments.department_id%type;

v_avg_salary NUMBER;
v_total_salary NUMBER;
v_employee_count NUMBER;

CURSOR c_department IS
        SELECT department_id, department_name FROM departments
        order by department_id;
CURSOR c_salary (p_department_id IN departments.department_id%TYPE) IS
		SELECT money FROM employees
        WHERE department_code = p_department_id;
            
BEGIN
  DBMS_OUTPUT.PUT_LINE('DEPARTMENT' || CHR(9) || 'Average Salary');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    OPEN c_department;
    FETCH c_department INTO v_department_id,v_department_name;
    
    WHILE c_department%FOUND 
    LOOP 
    v_total_salary :=0;
    v_employee_count :=0;
        OPEN c_salary(v_department_id);
        FETCH c_salary INTO v_avg_salary;
            WHILE c_salary%FOUND
            LOOP
                v_total_salary := v_total_salary+ v_avg_salary;
                v_employee_count := v_employee_count + 1;
            FETCH c_salary INTO v_avg_salary;
            END LOOP;
        CLOSE c_salary;
        IF v_employee_count > 0 THEN
            v_avg_salary := round((v_total_salary / v_employee_count),2);
        ELSE
            v_avg_salary := 0;
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_department_id || ' '|| v_department_name || CHR(9) || v_avg_salary);
        FETCH c_department INTO v_department_id,v_department_name;
    END LOOP;
    CLOSE c_department;
END;
/

--8. Write a PL/SQL program to display the total salary expense for each department. Return depart name and salary expenses in tabular form.

DECLARE 
v_department_name departments.department_name%type;
v_department_id departments.department_id%type;

v_salary NUMBER;
v_total_salary NUMBER;
v_employee_count NUMBER;

CURSOR c_department IS
        SELECT department_id, department_name FROM departments
        order by department_id;
CURSOR c_salary (p_department_id IN departments.department_id%TYPE) IS
		SELECT e.money FROM employees e
        WHERE e.department_code = p_department_id;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('DEPARTMENT ID' || CHR(9) ||'DEPARTMENT NAME' || CHR(9) || 'Salary EXPENSE');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------');
  OPEN c_department;
  FETCH c_department INTO v_department_id,v_department_name;
  WHILE c_department%FOUND LOOP
    v_total_salary := 0;
    v_salary := 0;
    v_employee_count :=0;
    
    OPEN c_salary(v_department_id);
    FETCH c_salary INTO v_salary;
        WHILE c_salary%FOUND LOOP
            v_total_salary := v_total_salary + v_salary;
            v_employee_count := v_employee_count + 1;
        FETCH c_salary INTO v_salary;
        END LOOP;
    CLOSE c_salary;
        DBMS_OUTPUT.PUT_LINE(v_department_id || CHR(9) || v_department_name || CHR(9) || v_total_salary);
        FETCH c_department INTO v_department_id,v_department_name;
  END LOOP;
  CLOSE c_department;

END;
/

--9. Write a PL/SQL program to display the number of employees in each department using a nested while loop. Return department name and number of employees.
DECLARE 
v_department_name departments.department_name%type;
v_department_id departments.department_id%type;

v_employee_count NUMBER;

v_employee_name employees.first_name%type;

CURSOR c_department IS
    SELECT department_id, department_name FROM departments
    ORDER BY department_id;
CURSOR c_employee(p_department_id IN departments.department_id%TYPE) IS
    SELECT first_name FROM employees
    WHERE employees.department_code = p_department_id;
    
BEGIN 
    OPEN c_department;
    FETCH c_department INTO v_department_id, v_department_name;
    WHILE c_department%FOUND LOOP
        v_employee_count := 0;
        OPEN c_employee(v_department_id);
        FETCH c_employee INTO v_employee_name;
            WHILE c_employee%FOUND LOOP
                v_employee_count := v_employee_count + 1;
            FETCH c_employee INTO v_employee_name;
            END LOOP;
        CLOSE c_employee;
        DBMS_OUTPUT.PUT_LINE(v_department_id || CHR(9) || v_department_name || CHR(9) || v_employee_count);
        FETCH c_department INTO v_department_id, v_department_name;
    END LOOP;
    CLOSE c_department;
END;
--10. Write a PL/SQL program to display the employees who have the highest salary in each department using a nested while loop.
DECLARE 
v_department_name departments.department_name%type;
v_department_id departments.department_id%type;

v_employee_count NUMBER;

v_employee_first_name employees.first_name%type;
v_employee_last_name employees.last_name%type;
v_salary employees.money%type;


CURSOR c_department IS
    SELECT department_id, department_name FROM departments
    ORDER BY department_id;
CURSOR c_employee(p_department_id IN departments.department_id%TYPE) IS
    SELECT first_name, last_name, money FROM employees
    WHERE employees.department_code = p_department_id
    ORDER BY money DESC
    FETCH FIRST 1 ROWS ONLY;
    
BEGIN 
    OPEN c_department;
    FETCH c_department INTO v_department_id, v_department_name;
    WHILE c_department%FOUND LOOP
        v_employee_count := 0;
        OPEN c_employee(v_department_id);
        FETCH c_employee INTO v_employee_first_name,v_employee_last_name,v_salary;
            WHILE c_employee%FOUND LOOP
                v_employee_count := v_employee_count + 1;
            FETCH c_employee INTO v_employee_first_name,v_employee_last_name,v_salary;
            END LOOP;
        CLOSE c_employee;
        DBMS_OUTPUT.PUT_LINE(v_department_id || CHR(9) || v_department_name || CHR(9) || v_employee_first_name || CHR(5) || v_employee_last_name || chr(9) || v_salary);
        FETCH c_department INTO v_department_id, v_department_name;
    END LOOP;
    CLOSE c_department;
END;

--11. Write a PL/SQL program to display the employees who have the lowest salary in each department.
DECLARE 
v_department_name departments.department_name%type;
v_department_id departments.department_id%type;

v_employee_count NUMBER;

v_employee_first_name employees.first_name%type;
v_employee_last_name employees.last_name%type;
v_salary employees.money%type;


CURSOR c_department IS
    SELECT department_id, department_name FROM departments
    ORDER BY department_id;
CURSOR c_employee(p_department_id IN departments.department_id%TYPE) IS
    SELECT first_name, last_name, money FROM employees
    WHERE employees.department_code = p_department_id
    ORDER BY money
    FETCH FIRST 1 ROWS ONLY;
    
BEGIN 
    OPEN c_department;
    FETCH c_department INTO v_department_id, v_department_name;
    WHILE c_department%FOUND LOOP
        v_employee_count := 0;
        OPEN c_employee(v_department_id);
        FETCH c_employee INTO v_employee_first_name,v_employee_last_name,v_salary;
            WHILE c_employee%FOUND LOOP
                v_employee_count := v_employee_count + 1;
            FETCH c_employee INTO v_employee_first_name,v_employee_last_name,v_salary;
            END LOOP;
        CLOSE c_employee;
        DBMS_OUTPUT.PUT_LINE(v_department_id || CHR(9) || v_department_name || CHR(9) || v_employee_first_name || CHR(9) || v_employee_last_name || chr(9) || v_salary);
        FETCH c_department INTO v_department_id, v_department_name;
    END LOOP;
    CLOSE c_department;
END;

-- Exception Handling
--1.Write a PL/SQL block to handle the exception when a division by zero occurs.
DECLARE 
    v_result NUMBER;
    BEGIN
        v_result := 10/0;
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('FAULT - DIVISION BY 0!');
END;
/
--2. Handle the NO_DATA_FOUND exception when retrieving a row from a table and no matching record is found.
DECLARE 
    v_result NUMBER;
    v_employees employees%ROWTYPE;
    BEGIN
        v_result := 23;
        
        SELECT * into v_employees FROM EMPLOYEES WHERE ID = v_result;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;
/

--3. Handle the TOO_MANY_ROWS exception when retrieving multiple rows instead of a single row from a table.
DECLARE 
    v_employees employees%ROWTYPE;
    BEGIN
        SELECT * into v_employees FROM EMPLOYEES;
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO MANY ROWS');
END;
/
DECLARE 
    v_dep_id employees.department_code%TYPE := 9;
    v_employees_id employees.id%type;
    v_employees_first_name employees.first_name%type;
    v_employees_last_name employees.first_name%type;

    BEGIN
        SELECT id,first_name,last_name into v_employees_id, v_employees_first_name, v_employees_last_name
        FROM EMPLOYEES
        WHERE department_code = v_dep_id;
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO MANY ROWS');
END;
/

--4. Handle the INVALID_NUMBER exception when converting a non-numeric value to a number.
DECLARE 
    v_result NUMBER;
    BEGIN
        SELECT TO_NUMBER('123a') INTO v_result FROM dual;
        
    EXCEPTION
        WHEN INVALID_NUMBER THEN
            DBMS_OUTPUT.PUT_LINE('INVALID NUMBER');
END;
/


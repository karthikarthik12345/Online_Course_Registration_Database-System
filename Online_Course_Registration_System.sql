create database Online_Course_Registration_System ;
use Online_Course_Registration_System;
-- 1. Student Table---

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    Mobile_no VARCHAR(15),
    E_mail VARCHAR(100),
    poy INT -- year of passing
);

-- 2. Course Table---

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT
);

-- 3. Administrator Table---

CREATE TABLE Administrator (
    user_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_fees DECIMAL(10, 2)
);

-- 4. Course Schedules Table----

CREATE TABLE Course_Schedules (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    user_id INT,
    start_date DATE,
    end_date DATE,
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (user_id) REFERENCES Administrator(user_id)
);

     -- 5. Registrations Table---
     
CREATE TABLE Registrations (
    registration_id INT PRIMARY KEY,
    student_id INT,
    schedule_id INT,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (schedule_id) REFERENCES Course_Schedules(schedule_id)
);
              ----- inserting values-----

INSERT INTO Student (student_id, student_name, Mobile_no, E_mail, poy) VALUES
(1, 'John Doe', '6381721997', 'john.doe@example.com', 2020),
(2, 'Jane Smith', '6381721888', 'jane.smith@example.com', 2021),
(3, 'Mike Johnson', '6381721777', 'mike.johnson@example.com', 2020),
(4, 'Sara Brown', '6381721666', 'sara.brown@example.com', 2022),
(5, 'Chris Evans', '6381721555', 'chris.evans@example.com', 2023),
(6, 'Eva Adams', '6381721444', 'eva.adams@example.com', 2022),
(7, 'Liam Wilson', '6381721333', 'liam.wilson@example.com', 2021),
(8, 'Noah King', '6381721222', 'noah.king@example.com', 2020),
(9, 'Olivia Taylor', '6381721111', 'olivia.taylor@example.com', 2021),
(10, 'Emma White', '6381721000', 'emma.white@example.com', 2023);

INSERT INTO Course (course_id, course_name, course_description) VALUES
(101, 'Introduction to Databases', 'Learn the basics of databases and SQL queries.'),
(102, 'Web Development', 'Learn HTML, CSS, and JavaScript to build websites.'),
(103, 'Data Science', 'Learn data analysis using Python and R.'),
(104, 'Mobile App Development', 'Develop mobile applications for Android and iOS.'),
(105, 'Cloud Computing', 'Learn cloud architecture and services.');

INSERT INTO Administrator (user_id, course_name, course_fees) VALUES
(5001, 'Introduction to Databases', 15000),
(5002, 'Web Development', 12000),
(5003, 'Data Science', 20000),
(5004, 'Mobile App Development', 22000),
(5005, 'Cloud Computing', 25000);

INSERT INTO Course_Schedules (schedule_id, course_id, user_id, start_date, end_date, start_time, end_time) VALUES
(1, 101, 5001, '2024-01-10', '2024-04-15', '09:00:00', '11:00:00'),
(2, 102, 5002, '2024-01-15', '2024-04-20', '10:00:00', '12:00:00'),
(3, 103, 5003, '2024-02-01', '2024-05-01', '11:00:00', '13:00:00'),
(4, 104, 5004, '2024-03-01', '2024-06-01', '12:00:00', '14:00:00'),
(5, 105, 5005, '2024-04-01', '2024-07-01', '13:00:00', '15:00:00');


INSERT INTO Registrations (registration_id, student_id, schedule_id) VALUES
(12123, 1, 1),
(12124, 2, 2),
(12125, 3, 3),
(12126, 4, 4),
(12127, 5, 5),
(12128, 6, 1),
(12129, 7, 2),
(12130, 8, 3),
(12131, 9, 4),
(12132, 10, 5);


      ----- Retrieve All Courses with particular name-----
      
SELECT * FROM Course
WHERE course_name = 'Introduction to databases';


SELECT * FROM Course_Schedules
WHERE start_date > '2024-01-01';

SELECT student_name,e_mail FROM Student
WHERE poy = 2020;

                       ----------- views----------

        
                  -- Student Information and Course Registration--

CREATE VIEW Course_Info AS
SELECT 
    S.student_id, 
    S.student_name, 
    S.E_mail, 
    C.course_name, 
    CS.start_date, 
    CS.end_date 
FROM 
    Student S
JOIN 
    Registrations R ON S.student_id = R.student_id
JOIN 
    Course_Schedules CS ON R.schedule_id = CS.schedule_id
JOIN 
    Course C ON CS.course_id = C.course_id;

drop view Course_Info; 
select * from course_info;

                -------- Course Schedules Overview---------
                
CREATE VIEW Schedule_Details AS
SELECT 
    C.course_name, 
    CS.start_date, 
    CS.end_date, 
    CS.start_time, 
    CS.end_time, 
    A.user_id, 
    A.course_fees 
FROM 
    Course_Schedules CS
JOIN 
    Course C ON CS.course_id = C.course_id
JOIN 
    Administrator A ON CS.user_id = A.user_id;

select * from Schedule_Details;

                             ----- joins-----
                             
       ----- Retrieve Students Enrolled in a Specific Course---   
                       
SELECT S.student_name, C.course_name
FROM Student S
JOIN Registrations R ON S.student_id = R.student_id
JOIN Course_Schedules CS ON R.schedule_id = CS.schedule_id
JOIN Course C ON CS.course_id = C.course_id
WHERE C.course_id = 101;
 
               ----- Course Schedule Details----
 
SELECT C.course_name, CS.start_date, CS.end_date, CS.start_time, CS.end_time
FROM Course C
JOIN Course_Schedules CS ON C.course_id = CS.course_id;
                          
                   -------- Stored procedure ----       
 
                  ----- Update Course Fees----- 
 
 DELIMITER $$
CREATE PROCEDURE UpdateCourseFees(IN courseName VARCHAR(100),IN newFees DECIMAL(10, 2))
BEGIN
    UPDATE Administrator
    SET course_fees = newFees
    WHERE course_name = courseName;
    
    SELECT 'Course Fees Updated Successfully' AS result;
END $$
DELIMITER ;

CALL UpdateCourseFees('Web Development', 13000);

                ----- Delete a Students Registration ------

DELIMITER $$
CREATE PROCEDURE DeleteStudentRegistration(
    IN registrationId INT
)
BEGIN
    DELETE FROM Registrations
    WHERE registration_id = registrationId;
    
    SELECT 'Student Registration Deleted Successfully' AS result;
END $$
DELIMITER ;

CALL DeleteStudentRegistration(12123);


                   
                   
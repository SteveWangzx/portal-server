--Update 3/30 - Normalization has been finished. Corrections to the DB as per the ER diagram have also been made. Checks and Triggers now need to be confirmed but database is ready to be implemented. 

--Update 3/27 - Normalization has been started. Plan is to finish it by the middle of this week. I don't believe the database will run in the current state. 

--Update 3/21/2022 note. Not sure about Doctor, Patient, Employee functional dependencies. Double check these!
--Keep original tables until we are sure the functional dependencies are correct and their are no further issues.
--I dont know if the decomposed tables need foreign keys to each other or any of that information.
--Also dont know if the relationship tables need to reference one or both decomposed tables
--And dont know how decomposed tables interact with the weak entity --> dont be concerned with if its a weak entity. Decompose and then redraw based on design. 


--This will remove ALL active tables not just the ones located in this project. However there is no guessing on what order to drop things.
/*BEGIN

FOR c IN (SELECT table_name FROM user_tables) LOOP
EXECUTE IMMEDIATE ('DROP TABLE "' || c.table_name || '" CASCADE CONSTRAINTS');
END LOOP;

FOR s IN (SELECT sequence_name FROM user_sequences) LOOP
EXECUTE IMMEDIATE ('DROP SEQUENCE ' || s.sequence_name);
END LOOP;

END;*/

CREATE TABLE DB_User (
User_ID CHAR(9),
SSN CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Gender CHAR(1),
Race CHAR(50),
PRIMARY KEY (User_ID),
UNIQUE (SSN),
UNIQUE (Username),
UNIQUE(Phone_Number));

INSERT INTO DB_User VAlUES('003', '111111111', 'Nathan', 'Kool', 'KoolGuy', 'idkpassword', TO_DATE('1997-05-04', 'YYYY-MM-DD'), '7895612347', 'MA', 'Worcester', '1245 Innovation Street', 'M', 'White');
INSERT INTO DB_User VAlUES('005', '222222222', 'Amanda', 'Smith', 'Coolgal', 'thisIsapassword', TO_DATE('2000-05-04', 'YYYY-MM-DD'), '963258741', 'MA', 'Salem', '1800 Witch Hunt Road', 'F', 'White');


--discuss price with group. attribute is really weird and out of place...
CREATE TABLE Pharmacy (
Pharmacy_ID CHAR(9),
Pharmacy_name CHAR(30),
Price REAL,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
PRIMARY KEY (Pharmacy_ID),
UNIQUE (Phone_Number)
);

INSERT INTO Pharmacy VALUES ('00001', 'WalGreens', 65.09, '1234567890', 'MA','Worcester','45 Polytech Street');
INSERT INTO Pharmacy VALUES ('00002', 'CVS', 75.09, '0123456789','MA','Boston','123 Street');


CREATE TABLE Drug_Information (
Prescription_ID CHAR(9),
Prescription_Name CHAR(30),
Quantity INTEGER,
Dosage CHAR(10),
Expiration_Date DATE,
PRIMARY KEY (Prescription_ID));

INSERT INTO Drug_Information VALUES ('001', 'Moneyflan', 20, '1.5 mg', TO_DATE('2022-03-04', 'YYYY-MM-DD'));
INSERT INTO Drug_Information VALUES ('002', 'blahdrug',  10, '1.2 mg', TO_DATE('2022-02-04', 'YYYY-MM-DD'));

CREATE TABLE Drug_Name (
Prescription_Name CHAR(30),
Prescription_Type CHAR(20),
PRIMARY KEY (Prescription_Name));

INSERT INTO Drug_Name VALUES ('Moneyflan','Oral');
INSERT INTO Drug_Name VALUES ('blahdrug','Topical');


--FD: pid -->Pname, ptype
/*CREATE TABLE Drug_Prescription (
Prescription_ID CHAR(9),
Prescription_Type CHAR(20),
Prescription_Name CHAR(30),
Quantity INTEGER,
Dosage CHAR(10),
Expiration_Date DATE,
PRIMARY KEY (Prescription_ID));

INSERT INTO Drug_Prescription VALUES ('001', 'Oral', 'Moneyflan', 20, '1.5 mg', TO_DATE('2022-03-04', 'YYYY-MM-DD'));
INSERT INTO Drug_Prescription VALUES ('002', 'Topical', 'blahdrug', 10, '1.2 mg', TO_DATE('2022-02-04', 'YYYY-MM-DD'));*/

--Decomposed drug tabless
/*CREATE TABLE Drug_Information(
Prescription_ID CHAR(9),
Quantity INTEGER,
Dosage CHAR(10),
Expiration_Date DATE,
PRIMARY KEY (Prescription_ID));

INSERT INTO Drug_Information VALUES ('001',  20, '1.5 mg', TO_DATE('2022-03-04', 'YYYY-MM-DD'));
INSERT INTO Drug_Information VALUES ('002',  10, '1.2 mg', TO_DATE('2022-02-04', 'YYYY-MM-DD'));

CREATE TABLE Drug_Name(
Prescription_ID CHAR(9),
Prescription_Type CHAR(20),
Prescription_Name CHAR(30),
PRIMARY KEY (Prescription_ID));

INSERT INTO Drug_Name VALUES ('001', 'Oral', 'Moneyflan');
INSERT INTO Drug_Name VALUES ('002', 'Topical', 'blahdrug'); */

--Need FK between treatment and drug? 
--FD: Treatment_id -> notes, start_date, end_date, diagnosis, diagnosis_category
--Diagnosis -> diagnosis_category
--Start_date, end_date -> notes, diagnosis, diagnosis_category

CREATE TABLE Treatment_Information (
Treatment_ID CHAR(9),
Diagnosis CHAR(50),
Start_Date DATE,
End_Date DATE,
Treatment_Description CHAR(500),
PRIMARY KEY (Treatment_ID));

INSERT INTO Treatment_Information VALUES ('001', 'Liver Cancer', TO_DATE('2021-03-04','YYYY-MM-DD'), TO_DATE('2022-03-04','YYYY-MM-DD'), 'Stage 1, treatable');
INSERT INTO Treatment_Information VALUES ('002', 'Strep Throat', TO_DATE('2020-01-20','YYYY-MM-DD'), TO_DATE('2020-03-01','YYYY-MM-DD'),'Presribed antibiotics as treatement'); 


CREATE TABLE Treatment_Diagnosis (
Diagnosis CHAR(50),
Diagnosis_Category CHAR(30),
PRIMARY KEY (Diagnosis));

INSERT INTO Treatment_Diagnosis VALUES ('Liver Cancer', 'Cancer');
INSERT INTO Treatment_Diagnosis VALUES ('Strep Throat', 'Bacterial Infection'); 


/*CREATE TABLE Treatment (
Treatment_ID CHAR(9),
Diagnosis CHAR(50),
Start_Date DATE,
End_Date DATE,
Diagnosis_Category CHAR(30),
Notes CHAR(500),
PRIMARY KEY (Treatment_ID));

INSERT INTO Treatment VALUES ('001', 'Liver Cancer', TO_DATE('2021-03-04','YYYY-MM-DD'), TO_DATE('2022-03-04','YYYY-MM-DD'), 'Cancer', 'Stage 1, treatable');
INSERT INTO Treatment VALUES ('002', 'Strep Throat', TO_DATE('2020-01-20','YYYY-MM-DD'), TO_DATE('2020-03-01','YYYY-MM-DD'), 'Bacterial Infection', 'Presribed antibiotics as treatement'); */

--Need FK between doctor and treatment/patient/medical record?
--Superkey = SSN, Username FD: SSN, username --> (Fname, Lname)?
/*CREATE TABLE User_Doctor (
User_ID CHAR(9),
SSN CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Gender CHAR(1),
Race CHAR(15),
Specialty CHAR(50),
PRIMARY KEY (User_ID),
UNIQUE (SSN),
UNIQUE (Username));

INSERT INTO Doctor VALUES ('0001', 'Hubert', 'Farnsworth', 'PlantExpress', 'BenderIzGreat', TO_DATE('2000-04-22','YYYY-MM-DD'), '012-345-6789','MA','Cambridge','456 Street','M');
INSERT INTO Doctor VALUES ('0002', 'Rick', 'Sanchez', 'Wubadub', 'Morty', TO_DATE('1985-06-13','YYYY-MM-DD'), '987-654-3210','MA','Plymouth','123 XYZ','M');*/

--Decompose Doctor table
CREATE TABLE Doctor_Name(
User_ID CHAR(9),
SSN CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
PRIMARY KEY (User_ID),
UNIQUE (Username));

INSERT INTO Doctor_Name VALUES ('147852','0001', 'Hubert', 'Farnsworth', 'PlantExpress');
INSERT INTO Doctor_Name VALUES ('258741','0002', 'Rick', 'Sanchez', 'Wubadub');

CREATE TABLE Doctor_Information(
User_ID CHAR(9),
SSN CHAR(9),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Gender CHAR(1),
PRIMARY KEY (User_ID),
UNIQUE (Username));

INSERT INTO Doctor_Information VALUES ('147852', '0001', 'PlantExpress', 'BenderIzGreat', TO_DATE('2000-04-22','YYYY-MM-DD'), '012-345-6789','MA','Cambridge','456 Street','M');
INSERT INTO Doctor_Information VALUES ('258741', '0002', 'Wubadub', 'Morty', TO_DATE('1985-06-13','YYYY-MM-DD'), '987-654-3210','MA','Plymouth','123 XYZ','M');

--Cant think of any functional dependecies 
CREATE TABLE Medical_Record (
MedR_ID CHAR(9),
Drug_History CHAR(100),
Treatment_History CHAR(100),
Doctor_History CHAR(100),
Family_History CHAR(100),
Date_Of_Examination Date,
PRIMARY KEY (MedR_ID));

INSERT INTO Medical_Record VALUES ('001', 'No history', 'Fractured arm at age 12', 'Dr. John Goodman', 'Mother has history of cancer', TO_DATE('2022-03-04','YYYY-MM-DD'));
INSERT INTO Medical_Record VALUES ('002', 'History of Drug Abuse - Opioids', 'Broke back in skiing accident', 'Dr. Jain Goodgal', 'Father has history of heart problems', TO_DATE('2021-02-05','YYYY-MM-DD'));

--use patient ssn as the foreign key to insurance
-- super key = (patientId, SSN, Username) FD: patientId --> Fname, Lname, ssn --> Fname, Lname, username --> fname, lname, ssn --> username
/*CREATE TABLE User_Patient (
Patient_ID CHAR(9),
SSN CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Gender CHAR(1),
Race CHAR(15),
PRIMARY KEY (Patient_ID),
UNIQUE (SSN),
UNIQUE (Username));

INSERT INTO Patient VALUES ('001', '123456789', 'Mike', 'Feelsbad', 'Ihurt', 'Alot10', TO_DATE('2000-07-23','YYYY-MM-DD'), '123-555-6666', 'MA', 'Boston','123 Street', 'M', 'Latino');
INSERT INTO Patient VALUES ('002', '999999999', 'Linda', 'Sickz', 'NotOK', 'ByLongshot', TO_DATE('2005-10-22','YYYY-MM-DD'), '123-444-5555', 'MD', 'College Park','123 Seasame Street', 'F', 'Caucasian');*/

CREATE TABLE Patient_Name(
User_ID CHAR(9),
SSN CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
PRIMARY KEY (User_ID),
UNIQUE (SSN),
UNIQUE (Username));

INSERT INTO Patient_Name VALUES ('001', '123456789', 'Mike', 'Feelsbad', 'Ihurt');
INSERT INTO Patient_Name VALUES ('002', '999999999', 'Linda', 'Sickz', 'NotOK');

CREATE TABLE Patient_Information(
User_ID CHAR(9),
SSN CHAR(9),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Gender CHAR(1),
Race CHAR(50),
PRIMARY KEY (User_ID),
UNIQUE (SSN),
UNIQUE (Username),
UNIQUE (Phone_Number)
);

INSERT INTO Patient_Information VALUES ('001', '123456789', 'Ihurt', 'Alot10', TO_DATE('2000-07-23','YYYY-MM-DD'), '123-555-6666', 'MA', 'Boston','123 Street', 'M', 'Latino');
INSERT INTO Patient_Information VALUES ('002', '999999999', 'NotOK', 'ByLongshot', TO_DATE('2005-10-22','YYYY-MM-DD'), '123-444-5555', 'MD', 'College Park','123 Seasame Street', 'F', 'Caucasian');

--Might need to be able to have doctors look up prescribed drugs from psychiatrist
--Ck: psy_id FD: psy_id --> fname, lname
/*CREATE TABLE Psychiatrist (
Psy_ID CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Prescibed_Drugs CHAR(50),
Race CHAR(20),
Gender CHAR(2),
PRIMARY KEY (Psy_ID));

INSERT INTO Psychiatrist VALUES ('111111111','John','Goodguy', '3030303030','MA','Salem','789 Witch Street', 'Happypin', 'White', 'M');
INSERT INTO Psychiatrist VALUES ('222222222','Jain','Goodgal', '4040404040','MA','Lowell','563 Somewhere Street', 'Gladerall', 'African American', 'F');*/

--Decomposition of tables
CREATE TABLE Psychiatrist_Information(
SSN CHAR(9),
User_ID CHAR(9),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Prescibed_Drugs CHAR(50),
Gender CHAR(1),
Race CHAR(50),
PRIMARY KEY (User_ID),
UNIQUE (SSN),
UNIQUE (Username)
);

INSERT INTO Psychiatrist_Information VALUES ('12333','111111111', '3030303030', 'Psygood', TO_DATE('2005-10-21','YYYY-MM-DD'), '303456789','MA','Salem','789 Witch Street', 'Happypin', 'M', 'White');
INSERT INTO Psychiatrist_Information VALUES ('12343','222222222', '4040404040', 'Mentalhealth', TO_DATE('1998-08-11','YYYY-MM-DD'), '456123789','MA','Lowell','563 Somewhere Street', 'Gladerall', 'F', 'African American');

CREATE TABLE Psychiatrist_Name(
User_ID CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
PRIMARY KEY (User_ID));

INSERT INTO Psychiatrist_Name VALUES ('111111111','John','Goodguy');
INSERT INTO Psychiatrist_Name VALUES ('222222222','Jain','Goodgal');

--Super key: (employeeID, username) FD: empID --> (Fname, Lname), username --> (Fname, Lname)
--Come back to! 
/*CREATE TABLE User_Employees (
User_ID CHAR(9),
SSN CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Speciality CHAR(100),
Race CHAR(20),
Gender CHAR(2),
PRIMARY KEY (User_ID),
UNIQUE (SSN),
UNIQUE (Username));

INSERT INTO Employees VALUES ('003', 'Isaac', 'Zhao', 'izhao', 'izhaopass', TO_DATE('2000-01-01','YYYY-MM-DD'), '123-222-3333', 'MA','Boston','123 Street', 'Desk', 'Asian','M');
INSERT INTO Employees VALUES ('005', 'Josh', 'Levy', 'jlevy', 'jlevypass', TO_DATE('1995-09-30','YYYY-MM-DD'), '123-777-8888', 'MA','Worcester','45 Polytech Drive', 'IT', 'White','M');*/

CREATE TABLE Employees_Name(
Employee_ID CHAR(9),
Fname CHAR(20),
Lname CHAR(20),
Username CHAR(60),
PRIMARY KEY (Employee_ID),
UNIQUE (Username));

INSERT INTO Employees_Name VALUES ('003', 'Isaac', 'Zhao', 'izhao');
INSERT INTO Employees_Name VALUES ('005', 'Josh', 'Levy', 'jlevy');

CREATE TABLE Employees_Information(
Employee_ID CHAR(9),
Username CHAR(60),
Password CHAR(60),
DOB DATE,
Phone_Number CHAR(12),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
Speciality CHAR(100),
Race CHAR(50),
Gender CHAR(2),
PRIMARY KEY (Employee_ID),
UNIQUE (Username));

INSERT INTO Employees_Information VALUES ('003', 'izhao', 'izhaopass', TO_DATE('2000-01-01','YYYY-MM-DD'), '123-222-3333', 'MA','Boston','123 Street', 'Desk', 'Asian','M');
INSERT INTO Employees_Information VALUES ('005', 'jlevy', 'jlevypass', TO_DATE('1995-09-30','YYYY-MM-DD'), '123-777-8888', 'MA','Worcester','45 Polytech Drive', 'IT', 'White','M');

--ck: office_id FD: office_id --> name
CREATE TABLE Office_Location(
Office_ID CHAR(9),
Name CHAR(20),
State CHAR(2),
City CHAR(30),
Street CHAR(50),
PRIMARY KEY (Office_ID));

INSERT INTO Office_Location VALUES ('111111111','Office1','MA', 'Boston', '333 Somewhere Drive');
INSERT INTO Office_Location VALUES ('222222222','Office2','MA', 'Cambridge', '444 Nowhere Way');

--Dont know if this weak entity can/needs to be decomposed
CREATE TABLE Office_Contact_Information(
Office_ID CHAR(9),
Office_Phone_Number CHAR(12),
Emergency_Phone_Number CHAR(12),
Email CHAR(20),
PRIMARY KEY (Office_ID, Emergency_Phone_Number),
FOREIGN KEY (Office_ID) REFERENCES Office_Location (Office_ID) ON DELETE CASCADE);

INSERT INTO Office_Contact_Information VALUES ('111111111', '123-111-2222', '222-222-2222', 'icontact@mail.com');
INSERT INTO Office_Contact_Information VALUES ('222222222', '987-999-8888', '333-333-3333', 'memail@kmail.com');

--ck: IP_ID FD: IP_ID --> name
/*CREATE TABLE Insurance_Provider(
IP_ID CHAR(9),
Name CHAR(20),
Phone_Number CHAR(12),
PRIMARY KEY (IP_ID));

INSERT INTO Insurance_Provider VALUES ('123', 'StealYoMoney Group', '444-444-4444');
INSERT INTO Insurance_Provider VALUES ('456', 'VampiresRus', '555-555-5555');*/

--Decomposition of insurance_provider
CREATE TABLE Insurance_Name(
IP_ID CHAR(9),
In_Out CHAR(50),
PRIMARY KEY (IP_ID));

INSERT INTO Insurance_Name VALUES ('123', 'In-network');
INSERT INTO Insurance_Name VALUES ('456', 'Out-network');

CREATE TABLE Insurance_Information(
IP_ID CHAR(9),
Name CHAR(20),
Phone_Number CHAR(12),
PRIMARY KEY (IP_ID),
UNIQUE (Phone_Number));

INSERT INTO Insurance_Information VALUES ('123', 'StealYoMoney Group', '444-444-4444');
INSERT INTO Insurance_Information VALUES ('456', 'VampiresRus', '555-555-5555');

-- Start of relationship tables
CREATE TABLE Sells (
Pharmacy_ID CHAR(9),
Prescription_ID CHAR(9),
PRIMARY KEY(Pharmacy_ID, Prescription_ID),
FOREIGN KEY (Pharmacy_ID) REFERENCES Pharmacy (Pharmacy_ID),
FOREIGN KEY (Prescription_ID) REFERENCES Drug_Information (Prescription_ID));

INSERT INTO Sells VALUES ('00001','001');
INSERT INTO Sells VALUES ('00002', '002');

CREATE TABLE Uses(
Prescription_ID CHAR(9),
Treatment_ID CHAR(9),
PRIMARY KEY (Prescription_ID, Treatment_ID),
FOREIGN KEY (Prescription_ID) REFERENCES Drug_Information (Prescription_ID),
FOREIGN KEY (Treatment_ID) REFERENCES Treatment_Information (Treatment_ID));

INSERT INTO Uses VALUES ('001', '001');
INSERT INTO Uses VALUES ('002', '002');

CREATE TABLE Prescribed (
Treatment_ID CHAR(9),
Psy_ID CHAR(9),
Patient_ID CHAR(9),
PRIMARY KEY (Treatment_ID, Psy_ID, Patient_ID),
FOREIGN KEY (Treatment_ID) REFERENCES Treatment_Information (Treatment_ID),
FOREIGN KEY (Psy_ID) REFERENCES Psychiatrist_Information (User_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID)
);

INSERT INTO Prescribed VALUES ('001', '111111111', '001');
INSERT INTO Prescribed VALUES ('002', '222222222', '002');

CREATE TABLE Given (
Treatment_ID CHAR(9),
Patient_ID CHAR(9),
PRIMARY KEY (Treatment_ID, Patient_ID),
FOREIGN KEY (Treatment_ID) REFERENCES Treatment_Information (Treatment_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID));

INSERT INTO Given VALUES ('001', '001');
INSERT INTO Given VALUES ('002', '002');

CREATE TABLE Assigns (
Treatment_ID CHAR(9),
Doctor_ID CHAR(9),
PRIMARY KEY (Treatment_ID, Doctor_ID),
FOREIGN KEY (Treatment_ID) REFERENCES Treatment_Information (Treatment_ID),
FOREIGN KEY (Doctor_ID) REFERENCES Doctor_Information (User_ID));

INSERT INTO Assigns VALUES ('001', '147852');
INSERT INTO Assigns VALUES ('002', '258741');

CREATE TABLE Assigned (
Doctor_ID CHAR(9),
Patient_ID CHAR(9),
PRIMARY KEY (Doctor_ID, Patient_ID),
FOREIGN KEY (Doctor_ID) REFERENCES Doctor_Information (User_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID));

INSERT INTO Assigned VALUES ('147852', '001');
INSERT INTO Assigned VALUES ('258741', '002');

CREATE TABLE Created_By (
Doctor_ID CHAR(9),
MedR_ID CHAR(9),
PRIMARY KEY (Doctor_ID, MedR_ID),
FOREIGN KEY (Doctor_ID) REFERENCES Doctor_Information (User_ID),
FOREIGN KEY (MedR_ID) REFERENCES Medical_Record (MedR_ID));

INSERT INTO Created_By VALUES ('147852', '001');
INSERT INTO Created_By VALUES ('258741', '002');

CREATE TABLE Has_Medical_Record (
MedR_ID CHAR(9),
Patient_ID CHAR(9),
Drug_History CHAR(100),
Treatment_History CHAR(100),
Doctor_History CHAR(100),
Family_History CHAR(100),
Date_Of_Examination Date,
PRIMARY KEY (MedR_ID),
UNIQUE (Patient_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID));

INSERT INTO Has_Medical_Record VALUES ('001', '001', 'No history', 'Fractured arm at age 12', 'Dr. John Goodman', 'Mother has history of cancer', TO_DATE('2022-03-04','YYYY-MM-DD'));
INSERT INTO Has_Medical_Record VALUES ('002', '002', 'History of Drug Abuse - Opioids', 'Broke back in skiing accident', 'Dr. Jain Goodgal', 'Father has history of heart problems', TO_DATE('2021-02-05','YYYY-MM-DD'));

CREATE TABLE Insured(
Patient_ID CHAR(9),
IP_ID CHAR(9),
PRIMARY KEY (Patient_ID, IP_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID),
FOREIGN KEY (IP_ID) REFERENCES Insurance_Name (IP_ID));

INSERT INTO Insured VALUES ('001', '123');
INSERT INTO Insured VALUES ('002', '456');

CREATE TABLE Visits(
Patient_ID CHAR(9),
Psy_ID CHAR(9),
PRIMARY KEY (Patient_ID, Psy_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID),
FOREIGN KEY (Psy_ID) REFERENCES Psychiatrist_Information (User_ID));

INSERT INTO Visits VALUES ('001', '111111111');
INSERT INTO Visits VALUES ('002', '222222222');

CREATE TABLE Admitted(
Patient_ID CHAR(9),
Office_ID CHAR(9),
PRIMARY KEY (Patient_ID, Office_ID),
FOREIGN KEY (Patient_ID) REFERENCES Patient_Information (User_ID),
FOREIGN KEY (Office_ID) REFERENCES Office_Location (Office_ID));

INSERT INTO Admitted VALUES ('001', '111111111');
INSERT INTO Admitted VALUES ('002', '222222222');

CREATE TABLE Goes_To(
User_ID CHAR(9),
Office_ID CHAR(9),
PRIMARY KEY (User_ID, Office_ID),
FOREIGN KEY (User_ID) REFERENCES DB_User (User_ID),
FOREIGN KEY (Office_ID) REFERENCES Office_Location (Office_ID));

INSERT INTO Goes_To VALUES ('003', '111111111');
INSERT INTO Goes_To VALUES ('005', '222222222');


--Start of triggers
--Trigger #1 Check the age of users being inserted into the database. Make sure the age is within a reasonable limit i.e. < 125 years old (oldest living person was at least 122)!
----SELECT FLOOR((sysdate - DOB)/365) FROM DB_User;
CREATE TRIGGER maxageDB BEFORE INSERT ON DB_User
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) > 125)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'Violation of Max User Age. Age cannot be greater than 125 years old.');
            END;
--KEEP THIS SLASH IT PREVENTS ERRORS. When creating a trigger you are creating a package and this notes the end. 
/
--Test case for trigger. It works!
--INSERT INTO DB_User VAlUES('004', '18000504', 'Nathan', 'Kool', 'someguy', 'idkpassword', TO_DATE('1800-05-04', 'YYYY-MM-DD'), '18006541', 'MA', 'Worcester', '1245 Innovation Street', 'M', 'White');
--Have to create triggers for each indivdual table that has that information
CREATE TRIGGER maxageDoc BEFORE INSERT ON Doctor_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) > 125)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'Violation of Max User Age. Age cannot be greater than 125 years old.');
            END;
/
CREATE TRIGGER maxagePatient BEFORE INSERT ON Patient_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) > 125)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'Violation of Max User Age. Age cannot be greater than 125 years old.');
            END;
/
CREATE TRIGGER maxagePsych BEFORE INSERT ON Psychiatrist_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) > 125)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'Violation of Max User Age. Age cannot be greater than 125 years old.');
            END;
/
CREATE TRIGGER maxageEmployee BEFORE INSERT ON Employees_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) > 125)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'Violation of Max User Age. Age cannot be greater than 125 years old.');
            END;
/
--Trigger #2 Make sure user cannot update their information to make themselves younger
CREATE TRIGGER newAgeDB BEFORE UPDATE ON DB_User
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) < old.DOB)
            BEGIN
                RAISE_APPLICATION_ERROR (-20006, 
                'Violation of user age. New user age cannot be less than old user age.');
            END;
/
--Test case for trigger. I can't get the test case to work. Keep getting an inconsistent data type error
--UPDATE DB_User U SET U.DOB = TO_DATE('2021-05-04', 'YYYY-MM-DD') WHERE U.User_ID = '003';
CREATE TRIGGER newAgeDoc BEFORE UPDATE ON Doctor_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) < old.DOB)
            BEGIN
                RAISE_APPLICATION_ERROR (-20006, 
                'Violation of user age. New user age cannot be less than old user age.');
            END;
/
CREATE TRIGGER newAgePatient BEFORE UPDATE ON Patient_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) < old.DOB)
            BEGIN
                RAISE_APPLICATION_ERROR (-20006, 
                'Violation of user age. New user age cannot be less than old user age.');
            END;
/
CREATE TRIGGER newAgePsych BEFORE UPDATE ON Psychiatrist_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) < old.DOB)
            BEGIN
                RAISE_APPLICATION_ERROR (-20006, 
                'Violation of user age. New user age cannot be less than old user age.');
            END;
/
CREATE TRIGGER newAgeEmp BEFORE UPDATE ON Employees_Information
    FOR EACH ROW
        WHEN ((FLOOR(sysdate - new.DOB)/ 365) < old.DOB)
            BEGIN
                RAISE_APPLICATION_ERROR (-20006, 
                'Violation of user age. New user age cannot be less than old user age.');
            END;
/

--Tigger #3 Auto increment id of inserted rows - need to change all primary keys from char to some number
/*CREATE SEQUENCE user_sequence;

CREATE OR REPLACE TRIGGER auto_inc_DBU BEFORE INSERT ON DB_User
    FOR EACH ROW
        BEGIN
            SELECT user_sequence.nextval
            INTO :new.id
            FROM dual;
        END;
/*/

--Trigger #4 Check if new pass is the same as the old password. 
CREATE TRIGGER newPassDB BEFORE UPDATE ON DB_User
    FOR EACH ROW
        WHEN (new.Password = old.Password)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'New password is the same as the old password!');
            END;
/
--Test case for trigger. I can't get the test case to work. Keep getting an inconsistent data type error
--UPDATE DB_User U SET U.DOB = TO_DATE('2021-05-04', 'YYYY-MM-DD') WHERE U.User_ID = '003';
CREATE TRIGGER newPassDoc BEFORE UPDATE ON Doctor_Information
    FOR EACH ROW
        WHEN (new.Password = old.Password)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'New password is the same as the old password!');
            END;
/
CREATE TRIGGER newPassPatient BEFORE UPDATE ON Patient_Information
    FOR EACH ROW
        WHEN (new.Password = old.Password)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'New password is the same as the old password!');
            END;
/
CREATE TRIGGER newPassPsych BEFORE UPDATE ON Psychiatrist_Information
    FOR EACH ROW
        WHEN (new.Password = old.Password)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'New password is the same as the old password!');
            END;
/
CREATE TRIGGER newPassEmp BEFORE UPDATE ON Employees_Information
    FOR EACH ROW
        WHEN (new.Password = old.Password)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004, 
                'New password is the same as the old password!');
            END;
/

--Trigger #5 Check that drug quantity is greater than zero
CREATE TRIGGER someQuantity BEFORE INSERT ON Drug_Information
    FOR EACH ROW
        WHEN (new.Quantity < 0)
            BEGIN
                RAISE_APPLICATION_ERROR (-20004,
                'Drug Quantity must be greater than zero!');
            END;
/
--Trigger check. It works!
--INSERT INTO Drug_Information VALUES ('003', 'blahdrug',  -1, '1.2 mg', TO_DATE('2022-02-04', 'YYYY-MM-DD'));
--Trigger #6 Check that the gender input into the database is either male or female
CREATE TRIGGER genderDB BEFORE INSERT ON DB_User
FOR EACH ROW
    WHEN (new.gender NOT IN ('M','F'))
        BEGIN
            RAISE_APPLICATION_ERROR (-20004,
            'Gender must be either M or F!');
        END;
/
--Trigger check. It works!
--INSERT INTO DB_User VAlUES('006', '1', 'Amanda', 'Smith', 'gal', 'thisIsapassword', TO_DATE('2000-05-04', 'YYYY-MM-DD'), '1', 'MA', 'Salem', '1800 Witch Hunt Road', 'k', 'White');
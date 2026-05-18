
CREATE DATABASE HospitalManagement;
USE HospitalManagement;


CREATE TABLE Patient (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    DateOfBirth DATE,
    Gender ENUM('Male','Female','Other'),
    ContactInfo VARCHAR(50)
);

CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(30),
    LastName VARCHAR(30),
    Specialty VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(50)
);

CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Reason VARCHAR(100),
    Status VARCHAR(20),
    
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE Billing (
    BillingID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Amount DECIMAL(10,2),
    BillingDate DATE,
    Status VARCHAR(20),

    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

CREATE TABLE MedicalRecord (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Diagnosis VARCHAR(100),
    Treatment VARCHAR(100),
    RecordDate DATE,
    Notes VARCHAR(200),

    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);

CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    Medication VARCHAR(100),
    Dosage VARCHAR(50),
    StartDate DATE,
    EndDate DATE,

    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

INSERT INTO Patient 
(FirstName, LastName, DateOfBirth, Gender, ContactInfo)
VALUES
('Aarav','Sharma','2000-05-10','Male','9811111111'),
('Anjali','Rai','1999-07-15','Female','9822222222'),
('Bibek','Thapa','2001-03-20','Male','9833333333'),
('Sneha','Karki','1998-12-11','Female','9844444444'),
('Amit','Joshi','2002-01-25','Male','9855555555');

INSERT INTO Doctor
(FirstName, LastName, Specialty, Phone, Email)
VALUES
('Ramesh','Adhikari','Cardiology','9800000001','ramesh@gmail.com'),
('Sita','Shrestha','Neurology','9800000002','sita@gmail.com'),
('Hari','Khadka','Orthopedic','9800000003','hari@gmail.com');

INSERT INTO Appointment
(PatientID, DoctorID, AppointmentDate, Reason, Status)
VALUES
(1,1,'2026-01-05','Heart Checkup','Scheduled'),
(2,2,'2026-02-10','Headache','Completed'),
(3,3,'2026-03-15','Bone Pain','Scheduled'),
(1,2,'2026-04-12','Migraine','Completed'),
(4,1,'2025-12-20','Chest Pain','Cancelled');

INSERT INTO Billing
(PatientID, Amount, BillingDate, Status)
VALUES
(1,1500,'2026-01-06','Paid'),
(2,2500,'2026-02-11','Paid'),
(3,800,'2026-03-16','Pending'),
(1,1200,'2026-04-13','Paid'),
(5,500,'2026-05-01','Paid');

INSERT INTO MedicalRecord
(PatientID, Diagnosis, Treatment, RecordDate, Notes)
VALUES
(1,'Heart Disease','Surgery','2026-01-06','Successful'),
(2,'Migraine','Medication','2026-02-11',NULL),
(3,'Fracture','Surgery','2026-03-16','Needs Rest'),
(4,'Fever','Paracetamol','2026-04-10','Recovered');

INSERT INTO Prescription
(PatientID, DoctorID, Medication, Dosage, StartDate, EndDate)
VALUES
(1,1,'Paracetamol','500mg','2026-01-06','2026-01-10'),
(2,2,'Ibuprofen','400mg','2026-02-11','2026-02-15'),
(3,3,'Amoxicillin','250mg','2026-03-16','2026-03-20'),
(1,2,'Paracetamol','500mg','2026-04-13','2026-04-18'),
(4,1,'Ibuprofen','200mg','2026-04-11','2026-04-16');



-- 1. Find the total billing amount paid by each patient. Display PatientID and total
-- amount.

SELECT PatientID, SUM(Amount) AS TotalAmount
FROM Billing
GROUP BY PatientID;


-- 2. Count the total number of appointments booked for each doctor. Display
-- Doctorname and appointment count.

SELECT 
    CONCAT(d.FirstName,' ',d.LastName) AS DoctorName,
    COUNT(a.AppointmentID) AS AppointmentCount
FROM Doctor d
JOIN Appointment a
ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID;

-- 3. Find the average billing amount from the Billing table.
SELECT AVG(Amount) AS AverageBillingAmount
FROM Billing;


-- 4 Display the maximum and minimum billing amount recorded in the Billing table.
SELECT 
    MAX(Amount) AS MaximumAmount,
    MIN(Amount) AS MinimumAmount
FROM Billing;


-- 5 List all doctors who have issued more than 2 prescriptions. Display doctorname
-- and prescription count.

SELECT 
    CONCAT(d.FirstName,' ',d.LastName) AS DoctorName,
    COUNT(p.PrescriptionID) AS PrescriptionCount
FROM Doctor d
JOIN Prescription p
ON d.DoctorID = p.DoctorID
GROUP BY d.DoctorID
HAVING COUNT(p.PrescriptionID) > 2;


-- 6 Find the total number of medical records grouped by Diagnosis. Display Diagnosis
-- and record count.

SELECT Diagnosis, COUNT(*) AS RecordCount
FROM MedicalRecord
GROUP BY Diagnosis;


-- 7Display the full name of each patient along with their diagnosis from the
-- MedicalRecord table.

SELECT 
    CONCAT(p.FirstName,' ',p.LastName) AS PatientName,
    m.Diagnosis
FROM Patient p
JOIN MedicalRecord m
ON p.PatientID = m.PatientID;


-- 8 List all appointments along with the patient's first name, last name, and the
-- doctor's first name and last name.
 
SELECT 
    a.AppointmentID,
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    d.FirstName AS DoctorFirstName,
    d.LastName AS DoctorLastName
FROM Appointment a
JOIN Patient p
ON a.PatientID = p.PatientID
JOIN Doctor d
ON a.DoctorID = d.DoctorID;


-- 9 Show all prescriptions along with the medication name, patient name, and the
-- prescribing doctor's name.

SELECT 
    pr.Medication,
    CONCAT(p.FirstName,' ',p.LastName) AS PatientName,
    CONCAT(d.FirstName,' ',d.LastName) AS DoctorName
FROM Prescription pr
JOIN Patient p
ON pr.PatientID = p.PatientID
JOIN Doctor d
ON pr.DoctorID = d.DoctorID;


-- 10 List all patients and their billing details. Include patients who have no billing
-- records as well.

SELECT 
    p.PatientID,
    CONCAT(p.FirstName,' ',p.LastName) AS PatientName,
    b.Amount,
    b.Status
FROM Patient p
LEFT JOIN Billing b
ON p.PatientID = b.PatientID;


-- 11 Display all doctors and any appointments they have. Show doctors with no
-- appointments too.

SELECT 
    d.DoctorID,
    CONCAT(d.FirstName,' ',d.LastName) AS DoctorName,
    a.AppointmentID,
    a.AppointmentDate
FROM Doctor d
LEFT JOIN Appointment a
ON d.DoctorID = a.DoctorID;


-- 12 . Find each patient's full name and the total amount billed to them by joining Patient
-- and Billing tables.
SELECT 
    CONCAT(p.FirstName,' ',p.LastName) AS PatientName,
    SUM(b.Amount) AS TotalBilledAmount
FROM Patient p
JOIN Billing b
ON p.PatientID = b.PatientID
GROUP BY p.PatientID;


-- 13 . List appointment details (date, reason, status) together with the patient's gender
-- and contact info.

SELECT 
    a.AppointmentDate,
    a.Reason,
    a.Status,
    p.Gender,
    p.ContactInfo
FROM Appointment a
JOIN Patient p
ON a.PatientID = p.PatientID;


-- 14 Retrieve all appointments where the status is 'Scheduled' and appointments is
-- after Jan 1 2026. 

SELECT *
FROM Appointment
WHERE Status = 'Scheduled'
AND AppointmentDate > '2026-01-01';


-- 15 Find all patients whose first name starts with the letter 'A'
SELECT *
FROM Patient
WHERE FirstName LIKE 'A%';


-- 16 Display all billing records where the amount is between 500 and 2000.
SELECT *
FROM Billing
WHERE Amount BETWEEN 500 AND 2000;


-- 17 List all prescriptions where the medication is either 'Paracetamol', 'Ibuprofen', or
-- 'Amoxicillin'.
SELECT *
FROM Prescription
WHERE Medication IN ('Paracetamol','Ibuprofen','Amoxicillin');


-- 18 Retrieve medical records where the treatment contains the word 'Surgery' or the
-- notes are not null.
SELECT *
FROM MedicalRecord
WHERE Treatment LIKE '%Surgery%'
OR Notes IS NOT NULL;


-- 19 Add a new column called BloodGroup of type VARCHAR(5) to the Patient table.
ALTER TABLE Patient
ADD BloodGroup VARCHAR(5);


-- 20 Modify the Phone column in the Doctor table to change its data type from
-- VARCHAR(15) to VARCHAR(20).
ALTER TABLE Doctor
MODIFY Phone VARCHAR(20);













--

 
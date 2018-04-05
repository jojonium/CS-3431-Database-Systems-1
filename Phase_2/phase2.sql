/* Drop all tables */
DROP TABLE StayIn;
DROP TABLE Equipment;
DROP TABLE EquipmentType;
DROP TABLE RoomAccess;
DROP TABLE RoomService;
DROP TABLE Room;
DROP TABLE Employee;
DROP TABLE Examine;
DROP TABLE Admission;
DROP TABLE Patient;
DROP TABLE Doctor;

/* Create the tables */
CREATE TABLE Doctor (dID INTEGER Primary Key, Gender CHAR(1) NOT NULL, Specialty varchar2(20), dFName varchar2(20) NOT NULL, dLName varchar2(20) NOT NULL);
ALTER TABLE Doctor ADD CONSTRAINT chk_gndr CHECK (Gender='M' OR Gender='F');

CREATE TABLE Patient (SSN INTEGER Primary Key, pFName varchar2(20) NOT NULL, pLName varchar2(20) NOT NULL, Address varchar2(20), TelNum INTEGER);

CREATE TABLE Examine (dID INTEGER, AdmissionNum INTEGER, DoctorComment varchar2(255));
ALTER TABLE Examine ADD CONSTRAINT pk_didadnum PRIMARY KEY (dID, AdmissionNum);
ALTER TABLE Examine ADD CONSTRAINT fk_did FOREIGN KEY (dID) REFERENCES Doctor(dID);

CREATE TABLE Admission (AdmissionNum INTEGER Primary Key, AdmissionDate DATE NOT NULL, LeaveDate DATE, TotalPayment REAL, InsurancePayment REAL, SSN INTEGER, FutureVisit DATE);
ALTER TABLE Admission ADD CONSTRAINT fk_ssn FOREIGN KEY (SSN) REFERENCES Patient(SSN);

ALTER TABLE Examine ADD CONSTRAINT fk_adNum FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum);

/* EmpRank: 0=regular employee, 1=division manager, 2=general manager */
CREATE TABLE Employee (eID INTEGER Primary Key, eFName varchar2(20) NOT NULL, eLName varchar2(20) NOT NULL, Salary REAL NOT NULL, jobTitle varchar2(30) NOT NULL, OfficeNum INTEGER, empRank INTEGER NOT NULL, supervisorID INTEGER);
ALTER TABLE Employee ADD CONSTRAINT fk_sid FOREIGN KEY (supervisorID) REFERENCES Employee(eID);

CREATE TABLE Room (Num INTEGER Primary Key, OccupiedFlag INTEGER NOT NULL);
ALTER TABLE Room ADD CONSTRAINT chk_of CHECK (OccupiedFlag=1 OR OccupiedFlag=0);

CREATE TABLE RoomService (Num INTEGER, Service varchar2(20));
ALTER TABLE RoomService ADD CONSTRAINT fk_num FOREIGN KEY (Num) REFERENCES Room(Num);
ALTER TABLE RoomService ADD CONSTRAINT pk_snumserv PRIMARY KEY (Num, Service);

CREATE TABLE RoomAccess (Num INTEGER, eID INTEGER);
ALTER TABLE RoomAccess ADD CONSTRAINT pk_anumserv PRIMARY KEY (Num, eID);
ALTER TABLE RoomAccess ADD CONSTRAINT fk_ranum FOREIGN KEY (Num) REFERENCES Room(Num);
ALTER TABLE RoomAccess ADD CONSTRAINT fk_eid FOREIGN KEY (eID) REFERENCES Employee(eID);

CREATE TABLE EquipmentType(qid INTEGER Primary Key, Description varchar2(200), Model varchar2(20) NOT NULL, Instructions varchar2(1000));

CREATE TABLE Equipment(serial# varchar2(20) Primary key, typeID INTEGER, purchaseyear INTEGER NOT NULL, lastInspection DATE, roomNum INTEGER);
ALTER TABLE Equipment ADD CONSTRAINT fk_et FOREIGN KEY (typeID) REFERENCES EquipmentType(qid);
ALTER TABLE Equipment ADD CONSTRAINT fk_roomNum FOREIGN KEY (roomNum) REFERENCES Room(Num);

CREATE TABLE StayIn(AdmissionNum INTEGER, RoomNum INTEGER, startDate DATE, endDate DATE);
ALTER TABLE StayIn ADD CONSTRAINT fk_an FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum);
ALTER TABLE StayIn ADD CONSTRAINT fk_rn FOREIGN KEY (RoomNum) REFERENCES Room(Num);
ALTER TABLE StayIn ADD CONSTRAINT pk_anrnsd PRIMARY KEY (AdmissionNum, RoomNum, startDate);


/* 10 Patients */
INSERT INTO Patient VALUES (111223333, 'John', 'Titor', '3 Hard Drive', 932940555);
INSERT INTO Patient VALUES (293049593, 'Nick', 'Cumello', '15 Montvale Rd', NULL);
INSERT INTO Patient VALUES (291040559, 'Matt', 'Hagan', NULL, NULL);
INSERT INTO Patient VALUES (201939350, 'Hitagi', 'Senjougahara', '100 West St', 2034952020);
INSERT INTO Patient VALUES (332932939, 'Marie', 'Curie', '39 Highland St', 1010203949);
INSERT INTO Patient VALUES (111922929, 'Kyle', 'Hanlon', '51 Fruit St', NULL);
INSERT INTO Patient VALUES (103939405, 'Seymour', 'Skinner', NULL, 1929495050);
INSERT INTO Patient VALUES (969384059, 'Phil', 'Connors', '93 Sagamore Rd', 9030039993);
INSERT INTO Patient VALUES (103945959, 'Ethan', 'Gouveia', '161 Highland St', NULL);
INSERT INTO Patient VALUES (040596810, 'Paul', 'Allen', NULL, 1930459);


/* 10 Doctors */
INSERT INTO Doctor VALUES (1, 'M', 'Neuroscience', 'Nick', 'Petitti');
INSERT INTO Doctor VALUES (2, 'M', NULL, 'Matt', 'Hagan');
INSERT INTO Doctor VALUES (3, 'F', 'Cardiology', 'Lucy', 'Steel');
INSERT INTO Doctor VALUES (4, 'F', NULL, 'Haruhara', 'Haruko');
INSERT INTO Doctor VALUES (5, 'M', 'Dermatology', 'Patrick', 'Bateman');
INSERT INTO Doctor VALUES (6, 'M', 'Hematology', 'Dio', 'Brando');
INSERT INTO Doctor VALUES (7, 'F', NULL, 'Asuka', 'Langley');
INSERT INTO Doctor VALUES (8, 'M', 'Optometry', 'Bill', 'Hartford');
INSERT INTO Doctor VALUES (9, 'M', NULL, 'James', 'Bond');
INSERT INTO Doctor VALUES (10, 'F', 'Radiology', 'Lois', 'Lane');

/* 10 Rooms */
INSERT INTO Room VALUES (011, 0);
INSERT INTO Room VALUES (293, 0);
INSERT INTO Room VALUES (122, 1);
INSERT INTO Room VALUES (002, 1);
INSERT INTO Room VALUES (443, 0);
INSERT INTO Room VALUES (123, 0);
INSERT INTO Room VALUES (234, 1);
INSERT INTO Room VALUES (023, 1);
INSERT INTO Room VALUES (384, 0);
INSERT INTO Room VALUES (301, 1);

/* Room Services */
INSERT INTO RoomService VALUES (011, 'Intensive Care Unit');
INSERT INTO RoomService VALUES (011, 'Ward Room');
INSERT INTO RoomService VALUES (293, 'Consulting Room');
INSERT INTO RoomService VALUES (293, 'Ward Room');
INSERT INTO RoomService VALUES (443, 'Emergency Room');
INSERT INTO RoomService VALUES (443, 'Operating Room');

/* 3 Equipment Types */
INSERT INTO EquipmentType VALUES (2930, 'a medical imaging technique used in radiology to form pictures of the anatomy and the physiological processes of the body', 'MRI', 'Ask someone who knows what they are doing.');
INSERT INTO EquipmentType VALUES (8668, 'a machine with an x-ray emitter and an x-ray detector', 'X-Ray Machine', 'Ask someone who knows how to use it.');
INSERT INTO EquipmentType VALUES (4493, 'a device used for recording the electrical activity of the heart over a period of time using electrodes placed on the skin.', 'Electrocardiogram', 'I have no idea');

/* 3 Equipment of each type */
INSERT INTO Equipment VALUES ('3939202', 2930, 2010, NULL, 002);
INSERT INTO Equipment VALUES ('3939495', 2930, 2011, '09-DEC-11', 301);
INSERT INTO Equipment VALUES ('4A-0C-3', 2930, 2011, '27-SEP-11', 384);
INSERT INTO Equipment VALUES ('2-FC-3A', 2930, 2010, '27-SEP-14', 384);
INSERT INTO Equipment VALUES ('6573929', 8668, 1990, NULL, 293);
INSERT INTO Equipment VALUES ('5758291', 8668, 2000, '01-JAN-18', 122);
INSERT INTO Equipment VALUES ('1127273', 8668, 2017, '30-DEC-17', 443);
INSERT INTO Equipment VALUES ('9494289', 4493, 2010, NULL, 122);
INSERT INTO Equipment VALUES ('A01-02X', 4493, 1979, '14-FEB-08', 123);
INSERT INTO Equipment VALUES ('1102020', 4493, 2011, NULL, 023);

/* At least 5 patients have 2 or more admissions */
INSERT INTO Admission VALUES (1, '01-JAN-18', '05-JAN-18', 100000, 934.44, 111223333, NULL);
INSERT INTO Admission VALUES (2, '10-JAN-18', '11-JAN-18', 2000, 1929.99, 111223333, NULL);
INSERT INTO Admission VALUES (3, '3-JAN-18', NULL, 293030, 0, 111922929, '28-FEB-95');
INSERT INTO Admission VALUES (4, '8-JAN-18', '9-JAN-18', 3004.34, 2092.12, 103939405, NULL);
INSERT INTO Admission VALUES (5, '10-JAN-18', '11-JAN-18', 100, 50, 103939405, '10-JAN-19');
INSERT INTO Admission VALUES (6, '20-NOV-17', '25-NOV-17', 1000, 50.70, 040596810, NULL);
INSERT INTO Admission VALUES (7, '25-DEC-17', '27-DEC-17', 3923, 1919, 040596810, '25-SEP-18');
INSERT INTO Admission VALUES (8, '20-NOV-17', '25-NOV-17', 1000, 50.70, 332932939, NULL);
INSERT INTO Admission VALUES (9, '25-DEC-17', '27-DEC-17', 3923, 1919, 332932939, '25-SEP-18');
INSERT INTO Admission VALUES (10, '20-NOV-17', '25-NOV-17', 1000, 50.70, 969384059, NULL);
INSERT INTO Admission VALUES (11, '25-DEC-17', '27-DEC-17', 3923, 1919, 969384059, '25-DEC-20');
INSERT INTO Admission VALUES (12, '18-FEB-18', '19-FEB-18', 10292, 21, 111223333, '21-FEB-18');

/* Stay In */
INSERT INTO StayIn VALUES (1, 011, '01-JAN-18', '03-JAN-18');
INSERT INTO StayIn VALUES (1, 293, '03-JAN-18', '05-JAN-18');
INSERT INTO StayIn VALUES (2, 122, '10-JAN-18', '11-JAN-18');
INSERT INTO StayIn VALUES (3, 023, '3-JAN-18', NULL);
INSERT INTO StayIn VALUES (4, 301, '8-JAN-18', '9-JAN-18');
INSERT INTO StayIn VALUES (5, 123, '10-JAN-18', '11-JAN-18');
INSERT INTO StayIn VALUES (6, 384, '20-NOV-17', '25-NOV-17');
INSERT INTO StayIn VALUES (7, 023, '25-DEC-17', '27-DEC-17');
INSERT INTO StayIn VALUES (8, 002, '20-NOV-17', '25-NOV-17');
INSERT INTO StayIn VALUES (9, 023, '25-DEC-17', '27-DEC-17');
INSERT INTO StayIn VALUES (10, 002, '20-NOV-17', '25-NOV-17');
INSERT INTO StayIn VALUES (11, 023, '25-DEC-17', '27-DEC-17');
INSERT INTO StayIn VALUES (12, 011, '18-FEB-18', '19-FEB-18');

/* Examine */
INSERT INTO Examine VALUES (2, 4, 'I have no comment');
INSERT INTO Examine VALUES (6, 8, 'Blah blah blah');
INSERT INTO Examine VALUES (5, 1, 'John Titor was examined for the first time by Dr. Patrick Bateman');
INSERT INTO Examine VALUES (5, 2, 'John Titor was examined for the second time by Dr. Patrick Bateman');
INSERT INTO Examine VALUES (5, 12, 'John Titor was examined for the third time by Dr. Patrick Bateman');

/* 10 regular employees, 4 division managers, and 2 general managers */
INSERT INTO Employee VALUES (1, 'Stanley', 'Kubrick', 500000, 'First General Manager', 304, 2, NULL);
INSERT INTO Employee VALUES (2, 'John', 'Carpenter', 1000000, 'Second General Manager', 505, 2, NULL);

INSERT INTO Employee VALUES (3, 'R.J.', 'MacReady', 250000, 'Morgue Supervisor', 202, 1, 2);
INSERT INTO Employee VALUES (4, 'Hal', 'Gordon', 395033.35, 'Custodian Supervisor', 125, 1, 1);
INSERT INTO Employee VALUES (5, 'Robert', 'Fulton', 293940, 'Communications Officer', NULL, 1, 1);
INSERT INTO Employee VALUES (6, 'John', 'Williams', 10000, 'Composer', 284, 1, 2);

INSERT INTO Employee VALUES (7, 'Ben', 'Childs', 100000, 'Mortician', NULL, 0, 3);
INSERT INTO Employee VALUES (8, 'Steven', 'Spielberg', 20499.99, 'Corpse Mover', NULL, 0, 3);
INSERT INTO Employee VALUES (9, 'David', 'Cronenberg', 394050, 'Viscera Cleanup', NULL, 0, 3);
INSERT INTO Employee VALUES (10, 'Steve', 'Jobs', 24000.01, 'Janitor', NULL, 0, 4);
INSERT INTO Employee VALUES (11, 'Fritz', 'Lang', 393949, 'Janitor', NULL, 0, 4);
INSERT INTO Employee VALUES (12, 'Quentin', 'Tarantino', 299999.99, 'Janitor', NULL, 0, 4);
INSERT INTO Employee VALUES (13, 'Albert', 'Speer', 49000, 'Social Media Chairman', NULL, 0, 5);
INSERT INTO Employee VALUES (14, 'Douglas', 'Andre', 2, 'Cello Player', NULL, 0, 6);
INSERT INTO Employee VALUES (15, 'Richard', 'Linklater', 293494, 'Tuba Player', NULL, 0, 6);
INSERT INTO Employee VALUES (16, 'Jesus', 'Christ', 100000000000, 'Lead Singer', NULL, 0, 6);

/* Room Access */
INSERT INTO RoomAccess VALUES (011, 1);
INSERT INTO RoomAccess VALUES (122, 1);
INSERT INTO RoomAccess VALUES (023, 1);
INSERT INTO RoomAccess VALUES (011, 16);
INSERT INTO RoomAccess VALUES (293, 16);
INSERT INTO RoomAccess VALUES (122, 16);
INSERT INTO RoomAccess VALUES (002, 16);
INSERT INTO RoomAccess VALUES (443, 16);
INSERT INTO RoomAccess VALUES (301, 16);
INSERT INTO RoomAccess VALUES (443, 5);
INSERT INTO RoomAccess VALUES (301, 5);


/* Queries */
/* Q1 */
SELECT Num
FROM Room
WHERE OccupiedFlag=1;

/* Q2 */
SELECT eID, eFName, eLName, Salary
FROM Employee 
WHERE supervisorID=6;

/* Q3 */
SELECT SSN, SUM(InsurancePayment)
FROM Admission
GROUP BY SSN;

/* Q4 */
SELECT P.SSN, pFName, pLName, COUNT(AdmissionNum) AS AdmissionCount
FROM Admission A, Patient P
WHERE A.SSN=P.SSN
GROUP BY P.SSN, pFName, pLName;

/* Q5 */
SELECT RoomNum
FROM Equipment
WHERE Serial#='A01-02X';

/* Q6 */
SELECT eID, count(Num) AS RoomCount
FROM RoomAccess
GROUP BY eID
HAVING COUNT(Num)=
	(SELECT MAX(CNT) AS MaxRooms
	 FROM (SELECT COUNT(Num) AS CNT
		   FROM RoomAccess
		   GROUP BY eID) q
	);

/* Q7 */ 
CREATE GLOBAL TEMPORARY TABLE RankNames (RankName varchar2(17) Primary Key, RankNum INTEGER NOT NULL);
INSERT INTO RankNames VALUES ('Regular employees', 0);
INSERT INTO RankNames VALUES ('Division managers', 1);
INSERT INTO RankNames VALUES ('General managers', 2);

SELECT RankName AS EmployeeType, COUNT(eID) AS CNT
FROM Employee E, RankNames R
WHERE E.EmpRank=R.RankNum
GROUP BY R.RankName;

DROP TABLE RankNames;

/* Q8 */
SELECT P.SSN, P.pFName, P.pLName, A.FutureVisit
FROM Patient P, Admission A
WHERE A.FutureVisit IS NOT NULL AND A.SSN=P.SSN;

/* Q9 */
SELECT E.typeID, Model, COUNT(Serial#) AS Quantity
FROM EquipmentType T, Equipment E
WHERE T.qid=E.TypeID
GROUP BY E.TypeID, Model
HAVING COUNT(Serial#)>3;

/* Q10 */
SELECT A.FutureVisit
FROM Patient P, Admission A
WHERE P.SSN=111223333 AND A.FutureVisit IS NOT NULL AND A.SSN=P.SSN;

/* Q11 */
SELECT E.dID
FROM Admission A, Examine E
WHERE A.SSN=111223333 AND E.AdmissionNum=A.AdmissionNum
GROUP BY E.dID
HAVING COUNT(E.AdmissionNum)>2;

/* Q12 */
SELECT TypeID
FROM Equipment
WHERE purchaseyear=2010
INTERSECT
SELECT TypeID
FROM Equipment
WHERE purchaseyear=2011;







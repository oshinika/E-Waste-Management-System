create database MiniProject;
use MiniProject;

create table User(
        User_ID varchar(20) not null,
        Initials varchar(50),
        First_Name varchar(100),
        Last_Name varchar(100),
        Street varchar(100) not null,
        City varchar(100) not null,
        Contact_No varchar(10),
        User_State varchar(30) not null,
        primary key (User_ID)        
);	

create table UserType(
        User_ID varchar(20) not null,
        User_Type varchar(50) not null,
        primary key (User_ID,User_Type),
		CONSTRAINT FK_UserType_User_ID FOREIGN KEY (User_ID) 
        REFERENCES User (User_ID)
		ON DELETE cascade ON UPDATE CASCADE
);


Create table WasteBin(
        Bin_ID varchar(10) not null ,
        User_ID varchar(20),
        Location varchar(50),
        Capacity varchar(50),
        Current_FillLevel varchar(50),
        primary key (Bin_ID),
        CONSTRAINT FK_User_ID FOREIGN KEY (User_ID) REFERENCES User (User_ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);
        
create table BinType(
        Bin_ID varchar(10) not null,
        Bin_Type varchar(50) not null,
        primary key(Bin_ID,Bin_Type),
        CONSTRAINT FKBinType_Bin_ID FOREIGN KEY (Bin_ID) 
        REFERENCES WasteBin (Bin_ID)
		ON DELETE cascade ON UPDATE CASCADE
);
        

create Table WasteType(        
        Type_ID varchar(10) not null ,
        Wsate_Type  varchar(50),
        primary key (Type_ID)
);
ALTER TABLE WasteType
CHANGE COLUMN Wsate_Type Waste_Type varchar(50);


create table WasteCollector(
		Collector_ID varchar(10) not null ,
        First_Name varchar(50),
        Last_Name varchar(50),
		ContactNo varchar(50), 
        primary key (Collector_ID)
);


CREATE TABLE WasteCollection (
    Collection_ID varchar(10) NOT NULL,
    Bin_ID varchar(10),
    Collector_ID varchar(10),
    CollectionDate date,
    Parent_Collection_ID varchar(10),  --  the recursive relationship
    PRIMARY KEY (Collection_ID),
    CONSTRAINT FK_Bin_ID FOREIGN KEY (Bin_ID) REFERENCES WasteBin (Bin_ID) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Collector_ID FOREIGN KEY (Collector_ID) REFERENCES WasteCollector (Collector_ID) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Parent_Collection_ID FOREIGN KEY (Parent_Collection_ID) 
    REFERENCES WasteCollection (Collection_ID) 
    ON DELETE CASCADE ON UPDATE CASCADE
);


create table RegulatoryAgency(
	    Agency_ID varchar(10) not null,
        First_Name varchar(50),
        Last_Name varchar(50),
		ContactNo varchar(50), 
        primary key (Agency_ID)
);

create table ViolationRecord(
       Data varchar(50),
       Agency_ID varchar(10),
       Description varchar(50),
       CONSTRAINT FK_ViolationRecord_Agency_ID 
       FOREIGN KEY (Agency_ID) 
       REFERENCES RegulatoryAgency (Agency_ID)
	   ON DELETE CASCADE ON UPDATE CASCADE
       );
ALTER TABLE ViolationRecord CHANGE COLUMN Data Date DATE;

       
       
create table LandFill(
       LandFill_ID varchar(10) not null,
       Type_ID varchar(10),
       Agency_ID varchar(10),
       Capacity varchar(50),
       Location varchar(50),
       primary key(LandFill_ID),
       CONSTRAINT FK_Type_ID FOREIGN KEY (Type_ID) 
       REFERENCES WasteType (Type_ID)
	   ON DELETE CASCADE ON UPDATE CASCADE,
       CONSTRAINT FK_Agency_ID FOREIGN KEY (Agency_ID) 
       REFERENCES  RegulatoryAgency (Agency_ID)
	   ON DELETE CASCADE ON UPDATE CASCADE
	);
    
create table WasteItem(
	   Type_ID varchar(10),
       LandFill_ID varchar(10),
       Collection_ID varchar(10),
       Weight varchar(50),
	   CONSTRAINT FK_WasteItem_Type_ID FOREIGN KEY (Type_ID) 
       REFERENCES WasteType (Type_ID)
	   ON DELETE CASCADE ON UPDATE CASCADE,
	   CONSTRAINT FK_WasteItem_Collection_ID FOREIGN KEY (Collection_ID) 
       REFERENCES WasteCollection (Collection_ID)
	   ON DELETE CASCADE ON UPDATE CASCADE,
	   CONSTRAINT FK_WasteItem_LandFill_ID FOREIGN KEY (LandFill_ID) 
       REFERENCES LandFill (LandFill_ID)
	   ON DELETE CASCADE ON UPDATE CASCADE
       );
       

create table ProcessingFacility(
        Facility_ID varchar(10) not null,
        Facility_Type varchar(50),
        Location varchar(50),
        primary key (Facility_ID)
	);
    
    
       
create table ProceedWaste(
      Proceed_ID varchar(10) not null,
      Type_ID varchar(10) ,
      Facility_ID varchar(10),
      Quantity varchar(50),
      Date_Proceed varchar(50),
      primary key (Proceed_ID),
      CONSTRAINT FK_ProceedWaste_Type_ID FOREIGN KEY (Type_ID) REFERENCES WasteType (Type_ID)
	  ON DELETE CASCADE ON UPDATE CASCADE,
      CONSTRAINT FK_ProceedWaste_Facility_ID FOREIGN KEY (Facility_ID) REFERENCES ProcessingFacility (Facility_ID)
	  ON DELETE CASCADE ON UPDATE CASCADE
      );
      

insert into User(User_ID, Initials, First_Name, Last_Name, Street, City, Contact_No, User_State)
values
('US0001', 'A.B.', 'Namal', 'Abeysinghe', 'Muthugala Mawatha', 'Colombo', '0776758456', 'Married'),
('US0002', 'P.', 'Kamala', 'Peris', 'Nawala Street', 'Kurunegala', '0773452123', 'Unmarried'),
('US0003', 'C.D.', 'Kumudu', 'Chandrasekara', 'Mahinda Mawatha', 'Madampe', '0708867564', 'Unmarried'),
('US0004', 'M.', 'Kumara', 'Mannaperuma', 'Rosa Street', 'Kaluthara', '0785673456', 'Married'),
('US0005', 'R.', 'Saman', 'Ranathunge', 'Chandana Street', 'Matara', '0723456734', 'Married'),
('US0006', 'Y.', 'Yoshitha', 'Somathilake', 'Mihindu Mawatha', 'Galle', '0706783456', 'Married');

UPDATE User
SET First_Name = 'Amali', Last_Name = 'Perera', Contact_No = '0708896567'
WHERE User_ID = 'US0002';

UPDATE User
SET First_Name = 'Lusi', Last_Name = 'Fedrick', 
Street = 'Mahinda Mawatha', City = 'Colombo'
WHERE User_ID = 'US0004';

DELETE FROM User WHERE User_ID = 'US0006';

select * from User;


insert into UserType(User_ID, User_Type)
values
('US0001', 'Domestic'),
('US0002', 'Medical Center'),
('US0006', 'Recycling Center'),
('US0001', 'Commercial Institute'),
('US0004', 'Educational Institute'),
('US0005', 'Medical Center');

UPDATE UserType
SET User_Type = 'Industrial Waste'
WHERE User_ID = 'US0006';

UPDATE Usertype
SET User_Type = 'Government Institutes'
WHERE User_ID = 'US0005';

DELETE FROM Usertype WHERE User_ID = 'US0004';

select * from UserType;


insert into WasteBin(Bin_ID, User_ID, Location, Capacity, Current_FillLevel)
values
('B0001', 'US0001', 'L1', 'Medium', '80%'),
('B0002', 'US0002', 'L2', 'Small', '50%'),
('B0003', 'US0003', 'L1', 'Large', '50%'),
('B0004', 'US0001', 'L3', 'Medium', '60%'),
('B0005', 'US0005', 'L3', 'Medium', '40%'),
('B0006', 'US0002', 'L1', 'Large', '80%');

UPDATE WasteBin
SET Location = 'L3' , Capacity = 'Large'
WHERE Bin_ID = 'US0001';

UPDATE WasteBin
SET Capacity = 'Medium', Current_FillLevel = '30'
WHERE Bin_ID = 'B0006';

DELETE FROM WasteBin WHERE Bin_ID = 'B0005';

select * from WasteBin;


insert into BinType(Bin_ID, Bin_Type)
values
('B0001', 'Red'),
('B0002', 'Green'),
('B0001', 'Yellow'),
('B0003', 'Blue'),
('B0006', 'Black');
INSERT INTO BinType(Bin_ID, Bin_Type)
VALUES
('B0005', 'Blue'); 
UPDATE BinType
SET Bin_ID = 'B0002', Bin_Type = 'Blue'
WHERE Bin_ID = 'B0003';

UPDATE BinType
SET Bin_ID = 'B0001', Bin_Type = 'Black'
WHERE Bin_ID = 'B0003';

DELETE FROM BinType WHERE Bin_ID = 'B0006';

select * from BinType;

insert into WasteType(Type_ID, Waste_Type)
values
('T001', 'Biodegradeble'),
('T002', 'Non biodegradeble'),
('T003', 'Recyclable'),
('T004', 'Electronic Waste'),
('T005','Construction');
INSERT INTO WasteType(Type_ID, Waste_Type)
VALUES
('T006', 'Hazardous Waste');
 

UPDATE WasteType
SET  Waste_Type = 'Chemical'
WHERE Type_ID = 'T001';

UPDATE WasteType
SET Waste_Type= 'Composite'
WHERE Type_ID = 'T002';

DELETE FROM WasteType WHERE Type_ID = 'T005';

select * from wasteType;

insert into WasteCollector(Collector_ID, First_Name, Last_Name, ContactNo)
values
('CI001', 'Saman', 'Karunarathna', '0417589145'),
('CI002', 'Sanath', 'Liyanage', '0912849751'),
('CI003', 'Apsara', 'Pathirana', '0745684165'),
('CI004', 'Gayani', 'kularathna', '0784598654'),
('CI005', 'Sumudu', 'Hewawasam', '0764578532'),
('CI006', 'Namal', 'Gamage', '0758643851');

UPDATE WasteCollector
SET First_Name = 'Kamal', Last_Name = 'Silva'
WHERE Collector_ID = 'CI001';

UPDATE WasteCollector
SET First_Name = 'Kamani', Last_Name = 'Perera'
WHERE Collector_ID = 'CI002';

DELETE FROM WasteCollector WHERE Collector_ID = 'CI006';

select * from wastecollector;

insert into WasteCollection(Collection_ID, Bin_ID, Collector_ID, CollectionDate)
values
('C0001', 'B0001', 'CI001', '2024-05-06'),
('C0002', 'B0002', 'CI002', '2024-05-05'),
('C0003', 'B0003', 'CI001', '2024-05-04'),
('C0004', 'B0001', 'CI003', '2024-05-01'),
('C0005', 'B0002', 'CI004', '2024-05-02');
INSERT INTO WasteCollection(Collection_ID, Bin_ID, Collector_ID, CollectionDate)
VALUES
('C0006', 'B0004', 'CI003', '2024-05-03'), 
('C0007', 'B0005', 'CI005', '2024-05-07');

 
UPDATE WasteCollection
SET CollectionDate = '2024-03-5'
WHERE Collection_ID = 'C0003';

UPDATE WasteCollection
SET CollectionDate = '2024-03-6'
WHERE Collection_ID = 'C0002';

DELETE FROM WasteCollection WHERE Collection_ID = 'C0005';

select * from wastecollection;


insert into RegulatoryAgency(Agency_ID, First_Name, Last_Name, ContactNo)
values
('A0001', 'Amal', 'Lokuge', '0714589615'),
('A0002', 'Kamal', 'Ranaweera', '0774896584'),
('A0003', 'Nimal', 'Ranathunga', '0764450890'),
('A0004', 'Anura', 'Pathirana', '0742019980'),
('A0005', 'Piyumi', 'Ileperuma', '0715000662');
INSERT INTO RegulatoryAgency(Agency_ID, First_Name, Last_Name, ContactNo)
VALUES
('A0006', 'Saman', 'Silva', '0771234567');


UPDATE RegulatoryAgency
SET First_Name = 'Muthu', Last_Name = 'Kumari'
WHERE Agency_ID = 'A0004';

UPDATE RegulatoryAgency
SET First_Name = 'Uresha', Last_Name = 'Herath', ContactNo = '0776857356'
WHERE Agency_ID = 'A0002';

DELETE FROM RegulatoryAgency WHERE Agency_ID = 'A0001';

select * from RegulatoryAgency;



insert into ViolationRecord(Date, Agency_ID, Description)
values
('2024-05-05', 'A0001', null),
('2024-05-08', 'A0002', null),
('2024-05-06', 'A0001', null),
('2024-05-07', 'A0003', null),
('2024-05-08', 'A0002', null);
INSERT INTO ViolationRecord(Date, Agency_ID, Description)
VALUES
('2024-05-09', 'A0004', 'Improper waste disposal'),
('2024-05-10', 'A0005', 'Unauthorized dumping of hazardous waste');

UPDATE ViolationRecord
SET Date = '2023-09-08', Description = 'The restaurant persistently disregarded warnings and continued to violate waste disposal regulations, posing a risk to public health.'
WHERE Agency_ID = 'A0001';

UPDATE ViolationRecord
SET Date = '2024-05-07', Description = 'dumping hazardous waste'
WHERE Agency_ID = 'A0002';

DELETE FROM ViolationRecord WHERE Agency_ID = 'A0003';

select * from ViolationRecord;



insert into LandFill(LandFill_ID, Type_ID, Agency_ID, Capacity, Location)
values
('L001', 'T001', 'A0001', 'Medium', 'land1'),
('L002', 'T002', 'A0002', 'Small', 'land2'),
('L003', 'T004', 'A0001', 'Large', 'land3'),
('L004', 'T003', 'A0003', 'Medium', 'land4'),
('L005', 'T004', 'A0002', 'Large', 'land5');
INSERT INTO LandFill(LandFill_ID, Type_ID, Agency_ID, Capacity, Location)
VALUES
('L006', 'T005', 'A0004', 'Medium', 'land6');


UPDATE LandFill
SET Capacity = 'Small', Location = 'land3'
WHERE LandFill_ID = 'L003';

UPDATE LandFill
SET Capacity = 'Medium', Location = 'land2'
WHERE LandFill_ID = 'L002';

DELETE FROM LandFill WHERE LandFill_ID = 'L001';

select * from LandFill;


insert into WasteItem(Type_ID, LandFill_ID, Collection_ID, Weight)
values
('T001', 'L001', 'C0001', '45kg'),
('T002', 'L002', 'C0002', '30kg'),
('T003', 'L003', 'C0003', '29kg'),
('T004', 'L005', 'C0001', '40kg'),
('T003', 'L005', 'C0001', '38kg'),
('T004', 'L001', 'C0002', '50kg');


UPDATE WasteItem
SET Weight = '10kg'
WHERE Type_ID = 'T004' and LandFill_ID = 'L005';

UPDATE WasteItem
SET Weight = '60kg'
WHERE Type_ID = 'T002' and LandFill_ID = 'L002';

DELETE FROM WasteItem WHERE Type_ID = 'T001';

select * from WasteItem;


insert into ProcessingFacility(Facility_ID, Facility_Type, Location)
values
('F001', 'Recycling Facility', 'L1'),
('F002', 'Composting Facility', 'L2'),
('F003', 'Waste-to-Energy Facility', 'L6'),
('F004', 'Recycling Center', 'L3'),
('F005', 'Incineration Facility', 'L4'),
('F006', 'Biogas Plant', 'L5');


UPDATE ProcessingFacility
SET Location = 'L7'
WHERE Facility_ID = 'F004' and Facility_type = 'Recycling Facility' ;

UPDATE ProcessingFacility
SET Location = 'L8'
WHERE Facility_ID = 'F002';

DELETE FROM ProcessingFacility WHERE Facility_ID = 'F005';

select * from ProcessingFacility;

insert into ProceedWaste(Proceed_ID, Type_ID, Quantity, Facility_ID, Date_Proceed)
values
('P0001', 'T001', '80%', 'F001', '2024-05-09'),
('P0002', 'T002', '50%', 'F002', '2024-05-10'),
('P0003', 'T004', '40%', 'F003', '2024-05-09'),
('P0004', 'T003', '65%', 'F001', '2024-05-11'),
('P0005', 'T004', '50%', 'F002', '2024-05-08'),
('P0006', 'T005', '30%', 'F003', '2024-05-11');


UPDATE ProceedWaste
SET Quantity = '10%', Date_Proceed = '2024-02-03'
WHERE Proceed_ID = 'P0004';

UPDATE ProceedWaste
SET Quantity = '20%', Date_Proceed = '2024-04-11'
WHERE Proceed_ID = 'P0002';

DELETE FROM ProceedWaste WHERE Proceed_ID = 'P0001';

select * from ProceedWaste;




-- Retrieve the details of all waste collection records including the collection ID, bin ID, collector ID, and collection date.
SELECT Collection_ID, Bin_ID, Collector_ID, CollectionDate FROM WasteCollection;




-- Retrieve the first name, last name, and contact number of all waste collectors.
SELECT First_Name, Last_Name, ContactNo FROM WasteCollector;




-- Retrieve a combination of user table and landfill table
SELECT * FROM User, LandFill;



-- Create a view named "User_Details" that contains the user ID, 
-- first name, last name, street, and city of all users.
CREATE VIEW User_Details AS
SELECT User_ID, First_Name, Last_Name, Street, City FROM User;
SELECT * FROM User_Details;

-- Rename the "Location" column in the WasteBin table to 
-- "Bin_Location".

select Bin_ID, Location as Bin_Location from WasteBin;


-- Calculate the count of records

SELECT COUNT(*) AS Total_Count FROM WasteItem;


-- Retrieve the first name, last name, and contact number 
-- of waste collectors whose last names start with 'K'.
SELECT First_Name, Last_Name, ContactNo 
FROM WasteCollector WHERE First_Name LIKE '%Sa%';

-- Complex Queries
-- union
SELECT Waste_Type FROM WasteType where Type_Id='T006'
UNION
SELECT Bin_Type FROM BinType;

-- intersect
SELECT L.Type_ID FROM LandFill as L 
INTERSECT 
SELECT W.Type_ID FROM WasteType as W;

-- Finding collectors who have collected 
-- from all bins
SELECT Collector_ID
FROM WasteCollector
WHERE Collector_ID NOT IN (
    SELECT Collector_ID
    FROM WasteCollection
    WHERE Collector_ID IS NOT NULL
);


-- set difference
 SELECT c.Collector_ID, c.First_Name, c.Last_Name
FROM WasteCollector c
WHERE c.Collector_ID NOT IN (SELECT Collector_ID FROM WasteCollection);

-- division
SELECT Facility_ID FROM ProcessingFacility
WHERE NOT EXISTS (
    SELECT * FROM ProceedWaste
    WHERE ProcessingFacility.Facility_ID = ProceedWaste.Facility_ID
);
-- inner join
-- Joining WasteCollection and WasteCollector to get collector 
-- details for each collection
SELECT wc.Collection_ID, wc.Bin_ID, wc.CollectionDate, 
wcl.First_Name, wcl.Last_Name
FROM WasteCollection wc
INNER JOIN WasteCollector wcl ON wc.Collector_ID = wcl.Collector_ID;

-- natural join
SELECT *
FROM WasteBin as WB
NATURAL JOIN WasteCollector as WC where collector_ID='CI002';

-- Left outer join

SELECT u.User_ID, u.Contact_No, ut.user_type FROM User as U
LEFT OUTER JOIN UserType as ut ON u.User_ID = ut.User_ID;

CREATE VIEW UserView AS
SELECT User_ID, Contact_No
FROM User;
CREATE VIEW UserTypeView AS
SELECT User_ID, User_Type
FROM UserType;
SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserView AS u
LEFT OUTER JOIN UserTypeView AS ut ON u.User_ID = ut.User_ID;


-- Right Outer Join
CREATE VIEW UserView AS
SELECT User_ID, Contact_No
FROM User;
CREATE VIEW UserTypeView AS
SELECT User_ID, User_Type
FROM UserType;
SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserView AS u
RIGHT OUTER JOIN UserTypeView AS ut ON ut.User_ID = u.User_ID;

-- full outer join
SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserTypeView AS ut
LEFT OUTER JOIN UserView AS u ON ut.User_ID = u.User_ID

UNION

SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserTypeView AS ut
RIGHT OUTER JOIN UserView AS u ON ut.User_ID = u.User_ID;


-- outer union
(SELECT b.Bin_ID, b.Location, wc.Collection_ID, wc.CollectionDate
 FROM WasteBin b
 LEFT JOIN WasteCollection wc ON b.Bin_ID = wc.Bin_ID)
UNION ALL
(SELECT b.Bin_ID, b.Location, NULL AS Collection_ID, 
NULL AS CollectionDate
 FROM WasteBin b
 WHERE b.Bin_ID NOT IN (SELECT Bin_ID FROM WasteCollection));
 
 
 
 
SELECT 'User' AS Source, User_ID AS ID, First_Name, Last_Name,
Street AS Address,City FROM User
UNION 
SELECT 'WasteBin' AS Source,Bin_ID AS ID,NULL AS First_Name,
NULL AS Last_Name,Location AS Address,NULL AS City 
FROM WasteBin;

-- Nested Query with join
-- Using a nested query with join to retrieve waste collection details along with collector names
SELECT wc.Collection_ID, wc.Bin_ID, wc.CollectionDate, wcl.First_Name, wcl.Last_Name
FROM (
    SELECT *
    FROM WasteCollection
    WHERE CollectionDate = '2024-05-06'
) AS wc
inner JOIN WasteCollector wcl ON wc.Collector_ID = wcl.Collector_ID;


-- Nested Query with Projection
-- Retrieve only the first names of users who have bins.
SELECT First_Name FROM User WHERE User_ID IN 
(SELECT DISTINCT User_ID FROM WasteBin);
-- nested query with union
SELECT Type_ID, SourceTable, Quantity
FROM (
    SELECT Type_ID, 'WasteItem' AS SourceTable, Weight AS Quantity
    FROM WasteItem
    UNION
    SELECT Type_ID, 'ProceedWaste' AS SourceTable, Quantity AS Quantity
    FROM ProceedWaste
) AS CombinedData;

-- Tuning
-- union
-- before tuning
EXPLAIN SELECT Waste_Type FROM WasteType where Type_Id='T006'
UNION
SELECT Bin_Type FROM BinType;

-- create index
CREATE INDEX idx_Type_Id ON WasteType (Type_Id);
show indexes from wastetype;


CREATE INDEX idx_Bin_Type ON BinType (Bin_Type);
show indexes from Bintype; 



-- after tuning
EXPLAIN SELECT Waste_Type
FROM WasteType
WHERE Type_Id = 'T006'
UNION
SELECT Bin_Type
FROM BinType;
-- set difference
-- before tuning
Explain SELECT Collector_ID
FROM WasteCollector
WHERE Collector_ID NOT IN (
    SELECT Collector_ID
    FROM WasteCollection
    WHERE Collector_ID IS NOT NULL
);

-- after tuning
EXPLAIN SELECT wc.Collector_ID
FROM WasteCollector wc
LEFT JOIN WasteCollection wcl ON 
wc.Collector_ID = wcl.Collector_ID
WHERE wcl.Collector_ID IS NULL;
-- before tuning
explain SELECT Collector_ID
FROM WasteCollector
WHERE Collector_ID NOT IN (
    SELECT Collector_ID
    FROM WasteCollection
    WHERE Collector_ID IS NOT NULL
);



-- after tuning 
EXPLAIN SELECT pf.Facility_ID
FROM ProcessingFacility pf
LEFT JOIN ProceedWaste pw ON 
pf.Facility_ID = pw.Facility_ID
WHERE pw.Facility_ID IS NULL;


-- INNER JOIN
-- BEFORE TUNNING 
EXPLAIN SELECT wc.Collection_ID, 
wc.Bin_ID, wc.CollectionDate, wcl.First_Name, 
wcl.Last_Name FROM WasteCollection wc
INNER JOIN WasteCollector wcl ON 
wc.Collector_ID = wcl.Collector_ID;


-- CREATING INDEXES
CREATE INDEX idx_Collector_ID_wc ON WasteCollection (Collector_ID);
show indexes from WasteCollection;





CREATE INDEX idx_Collector_ID_wcl ON WasteCollector (Collector_ID);
show indexes from WasteCollector;

-- AFTER TUNNING
EXPLAIN SELECT wc.Collection_ID, wc.Bin_ID, 
wc.CollectionDate, wcl.First_Name, wcl.Last_Name
FROM WasteCollection wc
INNER JOIN WasteCollector wcl ON 
wc.Collector_ID = wcl.Collector_ID;

-- left outer 
CREATE VIEW UserView AS
SELECT User_ID, Contact_No FROM User;
CREATE VIEW UserTypeView AS
SELECT User_ID, User_Type
FROM UserType;
SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserView AS u
LEFT OUTER JOIN UserTypeView AS ut ON u.User_ID = ut.User_ID;


-- set difference
-- before tuning 
EXPLAIN SELECT c.Collector_ID, c.First_Name, 
c.Last_Name FROM WasteCollector c
WHERE c.Collector_ID NOT IN (SELECT Collector_ID 
FROM WasteCollection);


-- after tuning 
EXPLAIN SELECT c.Collector_ID, c.First_Name, 
c.Last_Name FROM WasteCollector c
LEFT JOIN WasteCollection wc ON 
c.Collector_ID = wc.Collector_ID
WHERE wc.Collector_ID IS NULL;


-- division
explain select Facility_ID FROM ProcessingFacility
WHERE NOT EXISTS (
    SELECT * FROM ProceedWaste
    WHERE ProcessingFacility.Facility_ID = ProceedWaste.Facility_ID
);

EXPLAIN SELECT PF.Facility_ID
FROM ProcessingFacility PF
LEFT JOIN ProceedWaste PW ON PF.Facility_ID = PW.Facility_ID
WHERE PW.Facility_ID IS NULL;


-- inner join
-- before tuning
explain select wc.Collection_ID, wc.Bin_ID, wc.CollectionDate, wcl.First_Name, wcl.Last_Name
FROM WasteCollection wc
INNER JOIN WasteCollector wcl ON wc.Collector_ID = wcl.Collector_ID;

-- Create indexes
CREATE INDEX idx_WasteCollection_Collector_ID ON WasteCollection (Collector_ID);
CREATE INDEX idx_WasteCollector_Collector_ID ON WasteCollector (Collector_ID);

-- show indexes
show indexes from wastecollection;
show indexes from wastecollector;


-- after tuning
Explain SELECT wc.Collection_ID, wc.Bin_ID, wc.CollectionDate, wcl.First_Name, wcl.Last_Name
FROM WasteCollection wc
INNER JOIN WasteCollector wcl ON wc.Collector_ID = wcl.Collector_ID;

-- left join 
-- before tunning
CREATE VIEW UserView AS SELECT User_ID, Contact_No
FROM User;
CREATE VIEW UserTypeView AS SELECT User_ID, User_Type
FROM UserType;
explain select u.User_ID, u.Contact_No, ut.User_Type
FROM UserView AS u
LEFT OUTER JOIN UserTypeView AS ut ON u.User_ID = ut.User_ID;


CREATE INDEX idx_User_User_ID ON User (User_ID);
show indexes from user;




CREATE INDEX idx_UserType_User_ID ON UserType (User_ID);
show indexes from usertype;



-- after tuning
explain select u.User_ID, u.Contact_No, ut.User_Type
FROM User u
LEFT OUTER JOIN UserType ut 
ON u.User_ID = ut.User_ID;

drop INDEX idx_User_User_ID ON User;
drop INDEX idx_UserType_User_ID ON UserType;
-- before tuning
CREATE VIEW UserView AS SELECT User_ID, Contact_No 
FROM User;
CREATE VIEW UserTypeView AS SELECT User_ID, User_Type 
FROM UserType;
explain SELECT u.User_ID, u.Contact_No, ut.User_Type 
FROM UserView AS u
RIGHT OUTER JOIN UserTypeView AS ut ON ut.User_ID = u.User_ID;

CREATE INDEX idx_User_User_ID ON User (User_ID);
show indexes from user;


CREATE INDEX idx_UserType_User_ID ON UserType (User_ID);
show indexes from usertype;

explain SELECT u.User_ID, u.Contact_No, 
ut.User_Type FROM UserView AS u
RIGHT OUTER JOIN UserTypeView AS ut 
ON ut.User_ID = u.User_ID;


-- full outer join
-- before tunning 
Explain SELECT u.User_ID, u.Contact_No, 
ut.User_Type FROM UserTypeView AS ut LEFT OUTER JOIN UserView AS u ON 
ut.User_ID = u.User_ID
UNION
SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserTypeView AS ut
RIGHT OUTER JOIN UserView AS u ON ut.User_ID = u.User_ID;

-- create indexes 
CREATE INDEX idx_User_User_ID ON User (User_ID);
show indexes from user;

CREATE INDEX idx_UserType_User_ID 
ON UserType (User_ID);
show indexes from usertype;


-- after tunning
Explain SELECT u.User_ID, u.Contact_No, 
ut.User_Type FROM UserTypeView AS ut LEFT OUTER JOIN 
UserView AS u ON ut.User_ID = u.User_ID
UNION 
SELECT u.User_ID, u.Contact_No, ut.User_Type
FROM UserTypeView AS ut RIGHT OUTER JOIN 
UserView AS u ON ut.User_ID = u.User_ID;

-- nested query
explain SELECT wc.Collection_ID, wc.Bin_ID, wc.CollectionDate, wcl.First_Name, 
wcl.Last_Name FROM (
    SELECT *
    FROM WasteCollection
    WHERE CollectionDate = '2024-05-06'
) AS wc
inner JOIN WasteCollector wcl ON wc.Collector_ID = wcl.Collector_ID;

CREATE INDEX idx_WasteCollection_CollectionDate 
ON WasteCollection (CollectionDate);
CREATE INDEX idx_WasteCollection_Collector_ID 
ON WasteCollection (Collector_ID);
show indexes from wastecollection;


CREATE INDEX idx_WasteCollector_Collector_ID 
ON WasteCollector (Collector_ID);
show indexes from wastecollector;


Explain SELECT wc.Collection_ID, wc.Bin_ID, 
wc.CollectionDate, wcl.First_Name, wcl.Last_Name
FROM WasteCollection wc
inner JOIN WasteCollector wcl ON wc.Collector_ID = wcl.Collector_ID
WHERE wc.CollectionDate = '2024-05-06';

-- nested query in projection
-- before tunning 
Explain SELECT First_Name FROM User 
WHERE User_ID IN 
(SELECT DISTINCT User_ID FROM WasteBin);


-- after tunning
Explain SELECT DISTINCT u.First_Name
FROM User u
inner JOIN WasteBin wb ON u.User_ID = wb.User_ID;


-- nested query in union

Explain SELECT Type_ID, SourceTable, Quantity
FROM (
    SELECT Type_ID, 'WasteItem' AS SourceTable, Weight AS Quantity
    FROM WasteItem
    UNION
    SELECT Type_ID, 'ProceedWaste' AS SourceTable, Quantity AS Quantity
    FROM ProceedWaste
) AS CombinedData;



CREATE INDEX idx_WasteItem_Type_ID 
ON WasteItem (Type_ID);
show indexes from WasteItem;



CREATE INDEX idx_ProceedWaste_Type_ID 
ON ProceedWaste (Type_ID);
show indexes from proceedwaste;


-- after tunning
Explain SELECT Type_ID, SourceTable, Quantity
FROM (
    SELECT Type_ID, 'WasteItem' AS SourceTable, Weight AS Quantity
    FROM WasteItem
    UNION ALL
    SELECT Type_ID, 'ProceedWaste' AS SourceTable, Quantity AS Quantity
    FROM ProceedWaste
) AS CombinedData;





























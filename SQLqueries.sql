--.open Project.db

PRAGMA foreign_keys = ON;

CREATE TABLE Tag (
    TagID INTEGER NOT NULL,
    Material VARCHAR(50),
    Color VARCHAR(50),
    PRIMARY KEY (TagID AUTOINCREMENT)
);

CREATE TABLE Fish (
    FishID INTEGER NOT NULL,
    TagID INTEGER NOT NULL,
    Kind VARCHAR(50),
    FK_ParentFishID INTEGER, 
    PRIMARY KEY (FishID AUTOINCREMENT),
    FOREIGN KEY (TagID) REFERENCES Tag (TagID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (FK_ParentFishID) REFERENCES Fish (FishID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Characteristics(
    FishID INTEGER NOT NULL,
    Condition INTEGER NOT NULL, -- 1 = Poor, 2 = OK, 3 = Good
    Age INTEGER,
    Heigh INTEGER, -- in centimeters
    Mass INTEGER, -- in grams
    FOREIGN KEY (FishID) REFERENCES Fish (FishID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Catcher(
    CatcherID INTEGER NOT NULL,
    Title VARCHAR(30),
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    PRIMARY KEY (CatcherID AUTOINCREMENT)
);

CREATE TABLE Area(
    AreaID INTEGER NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    City VARCHAR(10) NOT NULL,
    PRIMARY KEY (AreaID AUTOINCREMENT)
);

CREATE TABLE CaughtBy(
    FishID INTEGER NOT NULL,
    CatcherID INTEGER NOT NULL,
    AreaID INTEGER NOT NULL,
    CatchDate VARCHAR(50),
    Coordinates VARCHAR(50),
    FOREIGN KEY (FishID) REFERENCES Fish (FishID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CatcherID) REFERENCES Catcher (CatcherID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (AreaID) REFERENCES Area (AreaID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX FishIndex ON CaughtBy(FishID, CatcherID, AreaID);

-- Test values -- 

INSERT INTO Tag VALUES
    (10001, 'Leather', 'Blue'),
    (10002, 'Leather', 'Red'),
    (10003, 'Plastic', 'Yellow'),
    (10004, 'Silicone', 'White'),
    (10005, 'Silicone', null),
    (10006, 'Silicone', 'White'),
    (10007, 'Leather', 'Green'),
    (10008, 'Silicone', 'Red'),
    (10009, 'Plastic', 'Red'),
    (10010, 'Plastic', 'Blue');

INSERT INTO Fish VALUES
    (20001, 10005, 'Trout', null),
    (20002, 10002, 'Zander', null),
    (20003, 10003, 'Bass', null),
    (20004, 10004, 'Bass', 20003),
    (20005, 10001, 'Pike', null),
    (20006, 10006, 'Herring', null),
    (20007, 10008, 'Trout', null),
    (20008, 10007, 'Zander', null),
    (20009, 10009, 'Pike', null),
    (20010, 10010, 'Pike', null);


INSERT INTO Characteristics VALUES
    (20002, 2, 2, 80, 5000),
    (20001, 3, 3, 60, 3500),
    (20004, 2, 1, 30, 200),
    (20005, 3, 7, 120, 6500),
    (20003, 1, 5, 50, 3000),
    (20006, 2, 3, 60, 3000),
    (20007, 2, 7, 25, 1500),
    (20008, 3, 7, 15, 150),
    (20009, 3, 4, 70, 4500),
    (20010, 1, 2, 40, 3000);

INSERT INTO Catcher VALUES
    (50009, 'Researcher', 'Ben', 'Over'),
    (50010, 'Associate Researcher', 'Hugh', 'Jass'),
    (50011, 'Engineer', 'Jack', 'Hitoff'),
    (50012, 'Trainee', 'Sal', 'Ami'),
    (50013, 'Researcher', 'Maya', 'Butreeks');

INSERT INTO Area VALUES
    (70001, '00100', 'HKI'),
    (70002, '20240', 'TKU'),
    (70003, '53850', 'LPR'),
    (70004, '49400', 'HMA'),
    (70005, '07900', 'LVA');

INSERT INTO CaughtBy VALUES
    (20001, 50009, 70001, '15/1/2021', '60/25'),
    (20003, 50010, 70002, '28/7/2021', '60/22'),
    (20002, 50011, 70003, '16/6/2021', '61/28'),
    (20004, 50012, 70004, '18/6/2021', '60/27'),
    (20005, 50013, 70005, '16/2/2022', '60/26'),
    (20006, 50011, 70002, '29/7/2021', '60/22'),
    (20007, 50012, 70003, '17/6/2021', '61/28'),
    (20008, 50012, 70003, '16/6/2021', '61/28'),
    (20009, 50013, 70004, '19/6/2021', '60/27'),
    (20010, 50013, 70005, '16/2/2022', '60/26');

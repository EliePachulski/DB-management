--We cannot ensure that if a Zoom meeting is canceled, the important file should
-- also be deleted, as we cannot determine whether it was the only Zoom meeting associated
-- with this file. Therefore, deleting a Zoom meeting might result in deleting the only
-- meeting where the important file was edited, meaning the file should no longer be considered
-- important, but we cannot verify this. Similarly, regarding the work hours on an important file,
-- if a Zoom meeting is canceled, the hours should be reduced, but we cannot verify this either.

CREATE TABLE Contact
(
    cName   VARCHAR(50) PRIMARY KEY,
    cAdress VARCHAR(50) NOT NULL,
    cPhone  INT         NOT NULL,
    CHECK (Cphone >= 972500000000 AND Cphone <= 972599999999)
);


CREATE TABLE ContactRelation
(
    cName              VARCHAR(50),
    RelatedContactName VARCHAR(50),
    PRIMARY KEY (cName, RelatedContactName),
    FOREIGN KEY (cName) REFERENCES Contact ON DELETE CASCADE,
    FOREIGN KEY (RelatedContactName) REFERENCES Contact (cName) ON DELETE CASCADE,
    CHECK (cName <> RelatedContactName)
);


CREATE TABLE ZoomMeeting
(
    zmStartingtime TIMESTAMP PRIMARY KEY,
    zmSubject      VARCHAR(50) NOT NULL
);

CREATE TABLE Participation
(
    zmStartingtime TIMESTAMP,
    Participant    VARCHAR(50),
    PRIMARY KEY (zmStartingtime, Participant),
    FOREIGN KEY (zmStartingtime) REFERENCES ZoomMeeting ON DELETE CASCADE,
    FOREIGN KEY (Participant) REFERENCES Contact (cName) ON DELETE CASCADE
);


CREATE TABLE Delay
(
    zmStartingtime TIMESTAMP,
    Participant    VARCHAR(50),
    Delay          INT NOT NULL,
    CausedDelay    VARCHAR(50),
    PRIMARY KEY (zmStartingtime, Participant),
    FOREIGN KEY (zmStartingtime, Participant) REFERENCES Participation ON DELETE CASCADE,
    FOREIGN KEY (CausedDelay) REFERENCES Contact (cName) ON DELETE CASCADE,
    CHECK (Participant <> CausedDelay)
);


CREATE TABLE Folder
(
    foNum    INT PRIMARY KEY,
    foName   VARCHAR(50) NOT NULL,
    foDate   DATE        NOT NULL,
    foFather INT,
    FOREIGN KEY (foFather) REFERENCES Folder (foNum) ON DELETE CASCADE
);



CREATE TABLE File
(
    fiName   VARCHAR(50),
    fiSize   INT NOT NULL,
    fiType   CHAR(3),
    fiFolder INT,
    PRIMARY KEY (fiName, fiType, fiFolder),
    FOREIGN KEY (fiFolder) REFERENCES Folder (foNum) ON DELETE CASCADE,
    CHECK (fiSize > 0)
);


CREATE TABLE DBcourse
(
    fiName      VARCHAR(50) PRIMARY KEY,
    CorrectName VARCHAR(3) NOT NULL,
    CHECK (CorrectName = 'YES' OR CorrectName = 'NO'),
    FOREIGN KEY (fiName) REFERENCES File ON DELETE CASCADE
);


CREATE TABLE Others
(
    fiName VARCHAR(50) PRIMARY KEY,
    FOREIGN KEY (fiName) REFERENCES File ON DELETE CASCADE
);


CREATE TABLE Important
(
    fiName   VARCHAR(50) PRIMARY KEY,
    WorkHour INT NOT NULL,
    CHECK (WorkHour > 0),
    FOREIGN KEY (fiName) REFERENCES File ON DELETE CASCADE
);


CREATE TABLE FileEdition
(
    fiName         VARCHAR(50),
    zmStartingtime TIMESTAMP,
    PRIMARY KEY (fiName, zmStartingtime),
    FOREIGN KEY (fiName) REFERENCES Important ON DELETE CASCADE,
    FOREIGN KEY (zmStartingtime) REFERENCES ZoomMeeting ON DELETE CASCADE
);


CREATE TABLE Permission
(
    pContact VARCHAR(50),
    pType    CHAR(3),
    pDate    DATE,
    pReason  VARCHAR(50) NOT NULL,
    PRIMARY KEY (pContact, pType, pDate),
    FOREIGN KEY (pContact) REFERENCES Contact (cName) ON DELETE CASCADE
);

CREATE TABLE Error
(
    ErrorNum INT,
    pContact VARCHAR(50),
    pType    CHAR(3),
    pDate    DATE,
    ErrorLvl INT NOT NULL,
    PRIMARY KEY (ErrorNum, pContact, pType, pDate),
    FOREIGN KEY (pContact, pType, pDate) REFERENCES Permission ON DELETE CASCADE
);

--Tables Deletion

DROP TABLE FileEdition;
DROP TABLE Delay;
DROP TABLE Error;
DROP TABLE Permission;
DROP TABLE DBcourse;
DROP TABLE Others;
DROP TABLE Important;
DROP TABLE File;
DROP TABLE Participation;
DROP TABLE ContactRelation;
DROP TABLE ZoomMeeting;
DROP TABLE Contact;
DROP TABLE Folder;
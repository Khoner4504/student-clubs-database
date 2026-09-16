DROP TABLE ClubExpenses;
DROP TABLE ClubDuesPayment;
DROP TABLE Club;
DROP TABLE Student;

-- Create the Student table
CREATE TABLE Student (
    StudID CHAR(4) NOT NULL,
    FName VARCHAR(20) NOT NULL,
    LName VARCHAR(25) NOT NULL,
    CampusAddress VARCHAR(30),
    PRIMARY KEY (StudID)
);

-- Insert your Student record and then try an insert that would duplicate the Primary Key
INSERT INTO Student (StudID, FName, LName, CampusAddress)
VALUES ('c228', 'Connor', 'TR', '123 College Ave');

-- This should fail due to duplicate primary key
INSERT INTO Student (StudID, FName, LName, CampusAddress)
VALUES ('c228', 'Another', 'Student', '456 University St');

-- Create the Club table with appropriate Check constraint and PresidentID as foreign key
CREATE TABLE Club (
    ClubID SMALLINT NOT NULL,
    ClubName VARCHAR(40) NOT NULL,
    AnnualDues NUMERIC(6,2) NOT NULL,
    PresidentID CHAR(4) NOT NULL,
    DateFounded DATE,
    AccountBalance NUMERIC(7,2) NOT NULL,
    Type VARCHAR(12) NOT NULL CHECK (Type IN ('Honorary', 'Professional', 'Social')),
    PRIMARY KEY (ClubID),
    FOREIGN KEY (PresidentID) REFERENCES Student(StudID)
);

-- Insert a valid club record - using TO_DATE function for Oracle date format
INSERT INTO Club (ClubID, ClubName, AnnualDues, PresidentID, DateFounded, AccountBalance, Type)
VALUES (1, 'Data Science Club', 25.00, 'c228', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 500.00, 'Professional');

-- Try inserts that violate constraints
-- Duplicate primary key
INSERT INTO Club (ClubID, ClubName, AnnualDues, PresidentID, DateFounded, AccountBalance, Type)
VALUES (1, 'Another Club', 30.00, 'c228', TO_DATE('2023-02-20', 'YYYY-MM-DD'), 200.00, 'Social');

-- Invalid Type value
INSERT INTO Club (ClubID, ClubName, AnnualDues, PresidentID, DateFounded, AccountBalance, Type)
VALUES (2, 'Fun Club', 15.00, 'c228', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 100.00, 'Just for Fun');

-- Invalid foreign key (PresidentID doesn't exist in Student table)
INSERT INTO Club (ClubID, ClubName, AnnualDues, PresidentID, DateFounded, AccountBalance, Type)
VALUES (3, 'Invalid Club', 20.00, 'none', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 50.00, 'Social');

-- Create the ClubDuesPayment table with StudID and ClubId as foreign keys
CREATE TABLE ClubDuesPayment (
    DuesPaymentID SMALLINT NOT NULL,
    StudID CHAR(4) NOT NULL,
    ClubID SMALLINT NOT NULL,
    DuesAmount NUMERIC(5,2) NOT NULL,
    DatePaid DATE NOT NULL,
    PRIMARY KEY (DuesPaymentID),
    FOREIGN KEY (StudID) REFERENCES Student(StudID),
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID)
);

-- Insert a valid ClubDuesPayment record
INSERT INTO ClubDuesPayment (DuesPaymentID, StudID, ClubID, DuesAmount, DatePaid)
VALUES (1, 'c228', 1, 25.00, TO_DATE('2023-09-01', 'YYYY-MM-DD'));

-- Test constraints
-- Duplicate primary key
INSERT INTO ClubDuesPayment (DuesPaymentID, StudID, ClubID, DuesAmount, DatePaid)
VALUES (1, 'c228', 1, 25.00, TO_DATE('2023-09-01', 'YYYY-MM-DD'));

-- Invalid StudID (foreign key violation)
INSERT INTO ClubDuesPayment (DuesPaymentID, StudID, ClubID, DuesAmount, DatePaid)
VALUES (2, 'none', 1, 25.00, TO_DATE('2023-09-01', 'YYYY-MM-DD'));

-- Invalid ClubID (foreign key violation)
INSERT INTO ClubDuesPayment (DuesPaymentID, StudID, ClubID, DuesAmount, DatePaid)
VALUES (3, 'c228', 999, 25.00, TO_DATE('2023-09-01', 'YYYY-MM-DD'));

-- Create the ClubExpenses table with the 2 needed Check constraints and ClubID as a foreign key
CREATE TABLE ClubExpenses (
    ExpenseID SMALLINT NOT NULL,
    ClubID SMALLINT NOT NULL,
    ExpenseType VARCHAR(10) NOT NULL CHECK (ExpenseType IN ('Dues', 'Food', 'Travel', 'Supplies', 'Misc')),
    ExpenseDescription VARCHAR(30),
    ExpenseAmount NUMERIC(6,2) NOT NULL CHECK (ExpenseAmount >= 0 AND ExpenseAmount <= 1000),
    DatePaid DATE NOT NULL,
    Payee VARCHAR(40) NOT NULL,
    PRIMARY KEY (ExpenseID),
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID)
);

-- Insert a valid ClubExpenses record
INSERT INTO ClubExpenses (ExpenseID, ClubID, ExpenseType, ExpenseDescription, ExpenseAmount, DatePaid, Payee)
VALUES (1, 1, 'Supplies', 'Notebooks and pens', 50.00, TO_DATE('2023-09-10', 'YYYY-MM-DD'), 'Office Depot');

-- Test constraints
-- Duplicate primary key
INSERT INTO ClubExpenses (ExpenseID, ClubID, ExpenseType, ExpenseDescription, ExpenseAmount, DatePaid, Payee)
VALUES (1, 1, 'Food', 'Pizza for meeting', 75.00, TO_DATE('2023-09-15', 'YYYY-MM-DD'), 'Pizza Hut');

-- Invalid ExpenseType
INSERT INTO ClubExpenses (ExpenseID, ClubID, ExpenseType, ExpenseDescription, ExpenseAmount, DatePaid, Payee)
VALUES (2, 1, 'Entertainment', 'Band for party', 200.00, TO_DATE('2023-09-20', 'YYYY-MM-DD'), 'Local Band');

-- Invalid ExpenseAmount (too high)
INSERT INTO ClubExpenses (ExpenseID, ClubID, ExpenseType, ExpenseDescription, ExpenseAmount, DatePaid, Payee)
VALUES (3, 1, 'Travel', 'Conference trip', 1500.00, TO_DATE('2023-09-25', 'YYYY-MM-DD'), 'Conference Org');

-- Invalid ExpenseAmount (negative)
INSERT INTO ClubExpenses (ExpenseID, ClubID, ExpenseType, ExpenseDescription, ExpenseAmount, DatePaid, Payee)
VALUES (4, 1, 'Misc', 'Refund', -50.00, TO_DATE('2023-09-30', 'YYYY-MM-DD'), 'Member');

-- Invalid ClubID (foreign key violation)
INSERT INTO ClubExpenses (ExpenseID, ClubID, ExpenseType, ExpenseDescription, ExpenseAmount, DatePaid, Payee)
VALUES (5, 999, 'Food', 'Snacks', 20.00, TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Grocery Store');
-- Create the database
CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

-- 1. User table
CREATE TABLE [User] (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. Event table
CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL FOREIGN KEY REFERENCES [User](UserID),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    EventDate DATETIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Open', 'Closed', 'Cancelled')) DEFAULT 'Open',
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 3. Category table
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    DistanceKm DECIMAL(5,2) NOT NULL
);
GO

-- 4. EventCategory (junction)
CREATE TABLE EventCategory (
    EventCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL FOREIGN KEY REFERENCES Event(EventID),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryID),
    StartTime TIME,
    MaxParticipants INT,
    Price DECIMAL(10,2),
    CONSTRAINT UQ_EventCategory UNIQUE (EventID, CategoryID)
);
GO

-- 5. Enrolment
CREATE TABLE Enrolment (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL FOREIGN KEY REFERENCES [User](UserID),
    EventCategoryID INT NOT NULL FOREIGN KEY REFERENCES EventCategory(EventCategoryID),
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled')) DEFAULT 'Pending',
    PaymentStatus NVARCHAR(20) NOT NULL CHECK (PaymentStatus IN ('Unpaid', 'Paid', 'Refunded')) DEFAULT 'Unpaid'
);
GO

-- 6. Result
CREATE TABLE Result (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Enrolment(EnrolmentID),
    FinishTime TIME,
    Position INT,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Finished', 'DNF', 'DNS'))
);
GO

-- Seed data
-- Insert two organisers
INSERT INTO [User] (FirstName, LastName, Email, PasswordHash, Role)
VALUES 
('Girly', 'Mashilo', 'girly@organiser.com', 'hashed_password_1', 'Organiser'),
('Kele', 'Monagane', 'kele@organiser.com', 'hashed_password_2', 'Organiser');

-- Insert two participants
INSERT INTO [User] (FirstName, LastName, Email, PasswordHash, Role)
VALUES 
('Lebogang', 'Moeketsi', 'lebo@runner.com', 'hashed_password_3', 'Participant'),
('Kaizer', 'White', 'kaizer@runner.com', 'hashed_password_4', 'Participant');

-- Insert categories
INSERT INTO Category (Name, Description, DistanceKm)
VALUES 
('5km Fun Run', 'Short and easy', 5.0),
('10km Challenge', 'Medium distance', 10.0),
('Half Marathon', '21.1 km', 21.1),
('Full Marathon', '42.2 km', 42.2);

-- Insert events
INSERT INTO Event (OrganiserID, Name, Description, EventDate, Location, Status)
VALUES 
(1, 'Cape Town Cycle Tour', 'Annual cycling event', '2026-03-08 07:00:00', 'Cape Town', 'Open'),
(2, 'Soweto Marathon', 'Road running event', '2026-04-12 06:00:00', 'Soweto', 'Open');

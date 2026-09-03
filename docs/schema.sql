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

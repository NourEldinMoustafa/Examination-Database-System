-- Create the database
CREATE DATABASE ExaminationSystemENDGAME;
GO

-- Use the database 
USE ExaminationSystemENDGAME;
GO


-- Create the tables
CREATE TABLE Admin.Topics (
	TopicId int PRIMARY KEY IDENTITY(1,1),
    TopicName NVARCHAR(50) NOT NULL,
);

CREATE TABLE Admin.Branches (
    BranchID INT PRIMARY KEY IDENTITY(10,1),
    BranchName NVARCHAR(50) NOT NULL,
    BranchAddress NVARCHAR(100) ,
	MangerID int
);

CREATE TABLE Admin.Tracks (
    TrackID INT PRIMARY KEY IDENTITY(25,1),
    TrackName NVARCHAR(50) NOT NULL,
    BranchID INT ,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE Admin.Intakes (
    IntakeID INT PRIMARY KEY IDENTITY(40,1),
    IntakeName NVARCHAR(50) NOT NULL,
    IntakeStartDate DATE DEFAULT GETDATE(),
    IntakeEndDate DATE DEFAULT DATEADD(MONTH, 4, GETDATE()) 
);

CREATE TABLE Admin.Students (
    StudentID INT PRIMARY KEY IDENTITY(101,1),
    StudentName NVARCHAR(50) NOT NULL,
    StudentEmail NVARCHAR(50) NOT NULL,
    StudentPhone NVARCHAR(20) NOT NULL,
    IntakeID INT ,
    BranchID INT ,
    TrackID INT ,

    FOREIGN KEY (IntakeID) REFERENCES Intakes(IntakeID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID)
);

CREATE TABLE Admin.Courses (
    CourseID INT PRIMARY KEY IDENTITY(500,1),
    CourseName NVARCHAR(50) NOT NULL,
    CourseDescription NVARCHAR(MAX) ,
    CourseMaxDegree INT ,
    CourseMinDegree INT ,

);
alter TABLE Admin.Courses
add  TopicId int
alter TABLE Admin.Courses
add foreign key (TopicId )references Topics(TopicId)

CREATE TABLE Admin.Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1001,1),
    InstructorName NVARCHAR(50) NOT NULL,
    InstructorEmail NVARCHAR(50) NOT NULL,
    InstructorPhone NVARCHAR(20) NOT NULL,
    BranchID INT 
	
   
);
alter TABLE Admin.Instructors
add  SupervisorID int

alter TABLE Admin.Instructors
add foreign key (SupervisorID) references Instructors(InstructorID)


ALTER TABLE Admin.Instructors
ADD FOREIGN KEY (BranchID)
REFERENCES Branches(BranchID)


ALTER TABLE Admin.Branches
ADD FOREIGN KEY (MangerID)
REFERENCES Instructors(InstructorID)



CREATE TABLE Admin.InstructorCourses (

    InstructorID INT NOT NULL,
    CourseID INT NOT NULL,

	primary key (InstructorID,CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Admin.QuestionPool (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionText NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(20) NOT NULL CHECK (QuestionType IN ('Multiple Choice', 'True/False', 'Text')),
    CorrectAnswer NVARCHAR(MAX),
    BestAnswer NVARCHAR(MAX)
);
alter TABLE Admin.QuestionPool 
	add CourseID int foreign key (CourseID) references Courses(CourseID)

CREATE TABLE Admin.Exams (
    ExamID INT PRIMARY KEY IDENTITY(1,1),
    ExamType NVARCHAR(20) ,
    IntakeID INT NOT NULL,
    BranchID INT NOT NULL,
    TrackID INT NOT NULL,
    CourseID INT NOT NULL,

	
	FOREIGN KEY (IntakeID) REFERENCES Intakes(IntakeID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
ALTER TABLE Admin.Exams
ALTER COLUMN IntakeID int  NULL;

ALTER TABLE Admin.Exams
ALTER COLUMN BranchID int  NULL;
ALTER TABLE Admin.Exams
ALTER COLUMN TrackID int  NULL;

CREATE TABLE Admin.ExamQuestions (

    ExamID INT ,
    QuestionID INT ,
    QuestionDegree INT NOT NULL,
	primary key (ExamID,QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES QuestionPool(QuestionID)
);
ALTER TABLE Admin.ExamQuestions
ALTER COLUMN QuestionDegree int  NULL;

CREATE TABLE Admin.StudentExams (

    StudentID INT ,
    ExamID INT ,
    ExamDate DATE default getdate(),
    ExamStartTime TIME ,
    ExamEndTime TIME ,
	primary key (StudentID,ExamID),

    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);

CREATE TABLE Admin.StudentAnswers (

	StudentID int,
	ExamID int,
    QuestionID INT ,
    StudentAnswer NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT NOT NULL,
	primary key(ExamID,StudentID,QuestionID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (QuestionID) REFERENCES QuestionPool(QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);
ALTER TABLE Admin.StudentAnswers
	ALTER COLUMN IsCorrect int  NULL;

create TABLE Admin.StudentCourses(
	StudentID int 	,
	CourseID int ,
	CourseScore nvarchar(50),

	PRIMARY KEY (StudentID, CourseID),
	
	foreign key (CourseID) references Courses(CourseID),
	foreign key (StudentID) references Students(StudentID)

)




USE ExaminationSystemENDGAME
GO

-- display all courses
create proc Admin.usp_displayCourses
    @TopicName varchar(100)

AS
begin

  select  @TopicName 'Topic Name',CourseID, CourseName
	from Courses
	where TopicId = (select TopicId from Topics
							where TopicName = @TopicName)
end;

exec usp_displayCourses @TopicName= 'Web'
--=================================================


-- student regster in course
create proc Admin.usp_registerInCourse
@studentId int,@Courseid varchar(MAX) 
as 
begin 
	BEGIN TRY
		insert into StudentCourses (StudentID,CourseID)
		values(@studentId,@courseId)

		select StudentID,CourseID
		from StudentCourses
		PRINT 'Insert completed successfully.';
	END TRY
	BEGIN CATCH
		PRINT 'An error occurred during the Bulk Insert operation.';
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + ERROR_MESSAGE();
	END CATCH;
end;




-- student show his courses
create proc Admin.usp_showRegisterdCourses
@studentid int
as begin 

	select CourseName
	from StudentCourses SC
	join Courses C
	on C.CourseID = SC.CourseID 
	where StudentID = @studentid;

end;

exec Admin.usp_showRegisterdCourses @studentid = 101


-- to show the course exams
create proc Admin.usp_showExamsInCourse
@Cname int
as begin 
	SELECT e.ExamID, e.ExamName
	FROM Exams e
	JOIN Courses c ON e.CourseID = c.CourseID
	WHERE c.CourseName = @Cname;
end;


-- to show what is exams in course 
CREATE proc Admin.usp_getExamInfo
    @ExamID INT
AS
BEGIN
    select QP.QuestionText as  'Question', QP.QuestionType as'Type' 
	from ExamQuestions EQ
	join QuestionPool QP
	on EQ.QuestionID = QP.QuestionID
	where EQ.ExamID = @ExamID

END;
exec usp_getExamInfo @ExamID = 4


-- to answer question 
CREATE proc Admin.usp_answerQues
	@studentID int,
    @ExamID INT,
	@QuesID int,
	@stdAnswer varchar(MAX)
	
AS
BEGIN
-- cheeck  exam time 
    insert into StudentAnswers(StudentID,ExamID,QuestionID,StudentAnswer)
	values( @studentID, @ExamID ,@QuesID ,@stdAnswer  )

END;


-- to update answer question 
CREATE proc Admin.usp_updateAnswerQues
    @studentID INT,
    @ExamID INT,
    @QuesID INT,
    @stdAnswer VARCHAR(MAX)
AS
BEGIN
-- cheeck  exam time 

    UPDATE StudentAnswers
    SET StudentAnswer = @stdAnswer
    WHERE StudentID = @studentID
        AND ExamID = @ExamID
        AND QuestionID = @QuesID;
END;



-- for get all answer to review
CREATE proc Admin.usp_GetStudentExamAnswers
    @studentID INT,
    @ExamID INT
AS
BEGIN
-- cheeck time
    SELECT
        SA.QuestionID,
        QP.QuestionText,
        SA.StudentAnswer 'Your answer'

    FROM StudentAnswers SA
    JOIN
        ExamQuestions EQ 
	ON SA.ExamID = EQ.ExamID  AND SA.QuestionID = EQ.QuestionID
	join QuestionPool QP
	on QP.QuestionID = EQ.QuestionID


    WHERE
        SA.StudentID = @studentID
        AND SA.ExamID = @ExamID;
END;




-- to show the course score
CREATE proc Admin.usp_showExamScore
    @StudentID INT
AS
BEGIN
	
	
	select C.CourseName, SC.CourseScore

	from StudentCourses SC
	join Courses C
	on C.CourseID = SC.CourseID
	where StudentID=@StudentID
END;


-- to calac course score 
CREATE proc Admin.usp_CalculateExamScore
    @StudentID INT,
    @CourseID INT
AS
BEGIN
	declare @exid int
	declare @exSocre int

	select @exid  = ExamID
	from Exams
	where CourseID = @CourseID


	select @exSocre = sum(IsCorrect)
	from StudentAnswers
	group by StudentID, ExamID
	having StudentID = @StudentID and ExamID = @exid


	update StudentCourses
	set CourseScore = @exSocre
	where StudentID = @StudentID and CourseID =@CourseID
END;




--add course
CREATE proc Admin.usp_AddCourse
    @CourseId VARCHAR(10),
    @CourseName VARCHAR(100),
    @CourseMaxDegree INT,
    @CourseMinDegree INT,
    @TopicID INT
AS
BEGIN
    INSERT INTO Courses ([CourseID], CourseName, [CourseMaxDegree],[CourseMinDegree] , TopicID)
    VALUES (@CourseId, @CourseName, @CourseMaxDegree, @CourseMinDegree, @TopicID);
END;




-- add exam
CREATE proc Admin.usp_AddExam
	@instructorID int,-- how add exam 
    @ExamID INT,
    @ExamType VARCHAR(50),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @CourseID INT,
    @ExamName VARCHAR(100)
AS
BEGIN
	if EXISTS (select 1 from InstructorCourses where InstructorID =@instructorID and CourseID= @CourseID)begin

		INSERT INTO Exams (ExamID, ExamType, IntakeID, BranchID, TrackID, CourseID, ExamName)
		VALUES (@ExamID, @ExamType, @IntakeID, @BranchID, @TrackID, @CourseID, @ExamName);
		print 'ok Select the question to exam'
		select * from QuestionPool;
	END;
	else begin
		PRINT 'You are not tech this course ';
	end;

END;


-- add ques
CREATE proc Admin.usp_AddQuestion
    @QuestionID INT,
    @QuestionText VARCHAR(MAX),
    @QuestionType VARCHAR(50),
    @CorrectAnswer VARCHAR(MAX),
    @BestAnswer VARCHAR(MAX)
AS
BEGIN
    INSERT INTO QuestionPool(QuestionID, QuestionText, QuestionType, CorrectAnswer, BestAnswer)
    VALUES (@QuestionID, @QuestionText, @QuestionType, @CorrectAnswer, @BestAnswer);
END;



-- display QuestionPool
CREATE proc Admin.usp_diplayQuestionPool
	@instructorID int,
	@CourseID int
AS
BEGIN
	if EXISTS (select 1 from InstructorCourses where InstructorID =@instructorID and CourseID= @CourseID)
	begin

		select QuestionText, QuestionType
		from QuestionPool
		where CourseID = @CourseID
	end;
	else begin 
		print 'Sorry you can not create exam in this course '
	end;

END;



-- manager add course for instructor 
-- if instructor is supervisor to this instructor
CREATE proc Admin.usp_addCourseforinstructor
	@supID int,
	@instructorID int,
	@CourseID int
AS
BEGIN
	declare @acsup int ;

	select @acsup = SupervisorID
	from Instructors
	where InstructorID =@instructorID

	if(@supId = @acsup)begin
		insert into [dbo].[InstructorCourses] (instructorID ,CourseID )
		values(@instructorID ,@CourseID )
	end;
	else begin 
		print 'You Are not supervisor to this instructor'
	end;
	
END;




--proc Admin.to retrieve all students registered in a specific course:
CREATE proc Admin.usp_GetStudentsInCourse
    @CourseName NVARCHAR(50)
AS
BEGIN
    SELECT s.StudentName, s.StudentEmail
    FROM Admin.Students s
    INNER JOIN Admin.StudentCourses sc ON s.StudentID = sc.StudentID
    INNER JOIN Admin.Courses c ON sc.CourseID = c.CourseID
    WHERE c.CourseName = @CourseName;
END;

-- proc Admin.to retrieve all exams for a specific student:
CREATE proc Admin.usp_GetStudentExams
    @StudentID INT
AS
BEGIN
    SELECT e.ExamID, e.ExamName, se.ExamDate, se.ExamStartTime, se.ExamEndTime
    FROM Admin.StudentExams se
    INNER JOIN Admin.Exams e ON se.ExamID = e.ExamID
    WHERE se.StudentID = @StudentID;
END;




-- Stored  PROCEDURE Admin. to add a new topic
CREATE  PROCEDURE Admin.usp_AddTopic
    @TopicName NVARCHAR(50)
AS
BEGIN
    INSERT INTO Admin.Topics (TopicName) VALUES (@TopicName);
END;

-- Stored  PROCEDURE Admin. to update a student's information
CREATE  PROCEDURE Admin.usp_UpdateStudentInfo
    @StudentID INT,
    @StudentName NVARCHAR(50),
    @StudentEmail NVARCHAR(50),
    @StudentPhone NVARCHAR(20),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT
AS
BEGIN
    UPDATE Admin.Students
    SET StudentName = @StudentName,
        StudentEmail = @StudentEmail,
        StudentPhone = @StudentPhone,
        IntakeID = @IntakeID,
        BranchID = @BranchID,
        TrackID = @TrackID
    WHERE StudentID = @StudentID;
END;

-- Stored  PROCEDURE Admin. to insert a new course
CREATE  PROCEDURE Admin.usp_InsertCourse
    @CourseName NVARCHAR(50),
    @CourseDescription NVARCHAR(MAX),
    @CourseMaxDegree INT,
    @CourseMinDegree INT,
    @TopicId INT
AS
BEGIN
    INSERT INTO Admin.Courses (CourseName, CourseDescription, CourseMaxDegree, CourseMinDegree, TopicId)
    VALUES (@CourseName, @CourseDescription, @CourseMaxDegree, @CourseMinDegree, @TopicId);
END;

-- Stored  PROCEDURE Admin. to add a new question to the question pool
CREATE  PROCEDURE Admin.usp_AddQuestionToPool
    @QuestionText NVARCHAR(MAX),
    @QuestionType NVARCHAR(20),
    @CorrectAnswer NVARCHAR(MAX),
    @BestAnswer NVARCHAR(MAX),
    @CourseID INT
AS
BEGIN
    INSERT INTO Admin.QuestionPool (QuestionText, QuestionType, CorrectAnswer, BestAnswer, CourseID)
    VALUES (@QuestionText, @QuestionType, @CorrectAnswer, @BestAnswer, @CourseID);
END;

-- Stored  PROCEDURE Admin. to add a new exam
CREATE  PROCEDURE Admin.usp_AddExam
    @ExamType NVARCHAR(20),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @CourseID INT
AS
BEGIN
    INSERT INTO Admin.Exams (ExamType, IntakeID, BranchID, TrackID, CourseID)
    VALUES (@ExamType, @IntakeID, @BranchID, @TrackID, @CourseID);
END;

-- Stored  PROCEDURE Admin. to assign an instructor to a course
CREATE  PROCEDURE Admin.usp_AssignInstructorToCourse
    @InstructorID INT,
    @CourseID INT
AS
BEGIN
    INSERT INTO Admin.InstructorCourses (InstructorID, CourseID)
    VALUES (@InstructorID, @CourseID);
END;

-- Stored  PROCEDURE Admin. to register a student in a course
CREATE  PROCEDURE Admin.usp_RegisterStudentInCourse
    @StudentID INT,
    @CourseID INT,
    @CourseScore NVARCHAR(50)
AS
BEGIN
    INSERT INTO Admin.StudentCourses (StudentID, CourseID, CourseScore)
    VALUES (@StudentID, @CourseID, @CourseScore);
END;



-- Insert  PROCEDURE Admin. for Topics
CREATE  PROCEDURE Admin. InsertTopic
    @TopicName NVARCHAR(50)
AS
BEGIN
    INSERT INTO Topics (TopicName)
    VALUES (@TopicName)
END;

-- Insert  PROCEDURE Admin. for Branches
CREATE  PROCEDURE Admin. InsertBranch
    @BranchName NVARCHAR(50),
    @BranchAddress NVARCHAR(100),
    @MangerID INT
AS
BEGIN
    INSERT INTO Branches (BranchName, BranchAddress, MangerID)
    VALUES (@BranchName, @BranchAddress, @MangerID)
END;



-- Update  PROCEDURE Admin. for Branches
CREATE  PROCEDURE Admin. UpdateBranch
    @BranchID INT,
    @BranchName NVARCHAR(50),
    @BranchAddress NVARCHAR(100),
    @MangerID INT
AS
BEGIN
    UPDATE Branches
    SET BranchName = @BranchName, BranchAddress = @BranchAddress, MangerID = @MangerID
    WHERE BranchID = @BranchID
END;


-- Insert  PROCEDURE Admin. for Exams
CREATE  PROCEDURE Admin. CreateExam
    @ExamType NVARCHAR(20),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @CourseID INT
AS
BEGIN
    INSERT INTO Exams (ExamType, IntakeID, BranchID, TrackID, CourseID)
    VALUES (@ExamType, @IntakeID, @BranchID, @TrackID, @CourseID)
END;




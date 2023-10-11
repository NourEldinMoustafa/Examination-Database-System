use ExaminationSystemENDGAME
go


-- 
CREATE TABLE Admin.LoginLog (
    LoginID INT IDENTITY(1,1) PRIMARY KEY,
    LoginTime DATETIME,
    Username NVARCHAR(50),
    UserType NVARCHAR(50)
);
CREATE TABLE Admin.AdminNotification (
   NotificationMessage VARCHAR(MAX)
);

create TRIGGER NotifyAdminOnLogin
ON ALL SERVER
WITH EXECUTE AS 'admin' -- Change to an appropriate user with necessary permissions
FOR LOGON
AS
BEGIN
    DECLARE @EventType NVARCHAR(100);
    SET @EventType = ORIGINAL_LOGIN();

    IF @EventType IN ('student', 'TrainingManager','instructor')
    BEGIN
        INSERT INTO Admin.LoginLog (LoginTime, Username, UserType)
        VALUES (GETDATE(), ORIGINAL_LOGIN(), @EventType);


        INSERT INTO Admin.AdminNotification (NotificationMessage)
        VALUES ('User ' + ORIGINAL_LOGIN() + ' logged in at ' + CONVERT(NVARCHAR(50), GETDATE()));
    END

END;

-- Create the users
CREATE LOGIN Admin WITH PASSWORD = 'P@ssw0rd';
CREATE USER Admin FOR LOGIN Admin;
GRANT CONTROL TO Admin;


CREATE LOGIN TrainingManager WITH PASSWORD = 'P@ssw0rd';
CREATE USER TrainingManager FOR LOGIN TrainingManager;

grant execute on object ::[Admin].[InsertBranch]TO TrainingManager
grant execute on object ::[Admin].[UpdateBranch]TO TrainingManager
grant execute on object ::[Admin].[usp_addCourseforinstructor]TO TrainingManager
grant execute on object ::[Admin].[CreateExam]TO TrainingManager
grant execute on object ::[Admin].[usp_AddCourse]TO TrainingManager
grant execute on object ::[Admin].[usp_AddExam]TO TrainingManager
grant execute on object ::[Admin].[usp_AddQuestion]TO TrainingManager
grant execute on object ::[Admin].[usp_AddQuestionToPool]TO TrainingManager
grant execute on object ::[Admin].[usp_CalculateExamScore]TO TrainingManager
grant execute on object ::[Admin].[usp_diplayQuestionPool]TO TrainingManager
grant execute on object ::[Admin].[usp_displayCourses]TO TrainingManager
grant execute on object ::[Admin].[usp_GetStudentExamAnswers]TO TrainingManager
grant execute on object ::[Admin].[usp_GetStudentsInCourse]TO TrainingManager
grant execute on object ::[Admin].[usp_InsertCourse]TO TrainingManager
grant execute on object ::[Admin].[usp_getExamInfo]TO TrainingManager
grant execute on object ::[Admin].[usp_GetStudentExamAnswers]TO TrainingManager
grant execute on object ::[Admin].[usp_showExamScore]TO TrainingManager
grant execute on object ::[Admin].[usp_showRegisterdCourses]TO TrainingManager
grant execute on object ::[Admin].[usp_UpdateStudentInfo]TO TrainingManager


GRANT SELECT ON OBJECT::[Admin].[V_Courses_info]    TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[V_Cr_Exams_info]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[V_ExamQuestions_info]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[V_Exams_info]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[V_StudentCor_info]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[V_StudentCourses_info]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[vw_AverageCourseScores]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[vw_CoursesWithTopics]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[vw_ExamsWithQuestions]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[vw_StudentExamScores]TO TrainingManager
GRANT SELECT ON OBJECT::[Admin].[vw_SupervisorsWithInstructors]TO TrainingManager


CREATE LOGIN Instructor WITH PASSWORD = 'P@ssw0rd';
CREATE USER Instructor FOR LOGIN Instructor;

grant execute on object ::[Admin].[CreateExam]TO Instructor
grant execute on object ::[Admin].[usp_AddCourse]TO Instructor
grant execute on object ::[Admin].[usp_AddExam]TO Instructor
grant execute on object ::[Admin].[usp_AddQuestion]TO Instructor
grant execute on object ::[Admin].[usp_AddQuestionToPool]TO Instructor
grant execute on object ::[Admin].[usp_CalculateExamScore]TO Instructor
grant execute on object ::[Admin].[usp_diplayQuestionPool]TO Instructor
grant execute on object ::[Admin].[usp_displayCourses]TO Instructor
grant execute on object ::[Admin].[usp_GetStudentExamAnswers]TO Instructor
grant execute on object ::[Admin].[usp_GetStudentsInCourse]TO Instructor
grant execute on object ::[Admin].[usp_InsertCourse]TO Instructor
grant execute on object ::[Admin].[usp_getExamInfo]TO Instructor
grant execute on object ::[Admin].[usp_GetStudentExamAnswers]TO Instructor
grant execute on object ::[Admin].[usp_showExamScore]TO Instructor
grant execute on object ::[Admin].[usp_showRegisterdCourses]TO Instructor
grant execute on object ::[Admin].[usp_UpdateStudentInfo]TO Instructor


GRANT SELECT ON OBJECT::[Admin].[V_Courses_info]    TO Instructor
GRANT SELECT ON OBJECT::[Admin].[V_Cr_Exams_info]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[V_ExamQuestions_info]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[V_Exams_info]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[V_StudentCor_info]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[V_StudentCourses_info]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[vw_AverageCourseScores]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[vw_CoursesWithTopics]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[vw_ExamsWithQuestions]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[vw_StudentExamScores]TO Instructor
GRANT SELECT ON OBJECT::[Admin].[vw_SupervisorsWithInstructors]TO Instructor

CREATE LOGIN Student WITH PASSWORD = 'P@ssw0rd';
CREATE USER Student FOR LOGIN Student;

GRANT SELECT ON OBJECT:: [Admin].[V_Student_info] TO Student
GRANT SELECT ON OBJECT:: [Admin].[V_StudentAnswers_info] TO Student
GRANT SELECT ON OBJECT:: [Admin].[V_StudentCourses_info] TO Student
GRANT SELECT ON OBJECT:: [Admin].[vw_CoursesWithTopics] TO Student
GRANT SELECT ON OBJECT:: [Admin].[vw_ExamsWithQuestions] TO Student

grant execute on object :: [Admin].[usp_registerInCourse] to Student

grant execute on object :: [Admin].[usp_getExamInfo]TO Student
grant execute on object :: [Admin].[usp_displayCourses]TO Student
grant execute on object :: [Admin].[usp_answerQues]TO Student
grant execute on object :: [Admin].[usp_showExamScore]TO Student
grant execute on object :: [Admin].[usp_showExamsInCourse]TO Student
grant execute on object :: [Admin].[usp_updateAnswerQues]TO Student
grant execute on object :: [Admin].[usp_showRegisterdCourses]TO Student
grant execute on object :: [Admin].[usp_GetStudentExamAnswers]TO Student










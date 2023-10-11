use ExaminationSystemENDGAME
go

CREATE VIEW Admin.V_Student_info
AS
SELECT [StudentID],[StudentName],[BranchName],[BranchAddress],[TrackName],[IntakeName],[IntakeStartDate],[IntakeEndDate]
from Admin.[Students] s join Admin.[Branches] b
ON
s.[BranchID]=b.[BranchID]

join Admin.[Tracks] t
ON
s.[TrackID]=t.[TrackID]

join Admin.[Intakes] i
ON
s.[IntakeID]=i.[IntakeID];





/*****************Courses***********************/

CREATE VIEW Admin.V_Courses_info
AS
select  TopicName,CourseID, CourseName
from Admin.Courses c join Admin.Topics t
ON
c.TopicId=t.TopicId



/**************StudentCourses***************/

CREATE VIEW Admin.V_StudentCourses_info
AS
select  StudentID,CourseName
from Admin.StudentCourses s join Admin.Courses c
ON
s.CourseID=c.CourseID



/************Exams*****************/

CREATE VIEW Admin.V_Exams_info
AS
SELECT e.ExamID, e.ExamName
	from Admin.Exams e join Admin.Courses c
	ON 
	e.CourseID = c.CourseID



/************ExamQuestions*****************/

CREATE VIEW Admin.V_ExamQuestions_info
AS
select QuestionText, QuestionType 
from Admin.ExamQuestions E join Admin.QuestionPool Q
	on
	E.QuestionID = Q.QuestionID



/************ExamQuestions*****************/

CREATE VIEW Admin.V_StudentAnswers_info
AS
   SELECT SA.QuestionID, QP.QuestionText, SA.StudentAnswer 'Your answer'
    from Admin.StudentAnswers SA
    JOIN
        ExamQuestions EQ 
	ON SA.ExamID = EQ.ExamID  AND SA.QuestionID = EQ.QuestionID
	join Admin.QuestionPool QP
	on QP.QuestionID = EQ.QuestionID



/************StudentCourses*****************/

CREATE VIEW Admin.V_StudentCor_info
AS
select C.CourseName, SC.CourseScore
	from Admin.StudentCourses SC
	join Admin.Courses C
	on C.CourseID = SC.CourseID



/************Exams*****************/

CREATE VIEW Admin.V_Cr_Exams_info
AS
select exid = ExamID
	from Admin.Exams m join Admin.Courses o
	on 
	m.CourseID = o.CourseID




/*************Instructors***************/

CREATE VIEW Admin.V_Instructors_info
AS
SELECT InstructorName,BranchName,TrackName
from Admin.Instructors i join Admin.Branches b
ON
i.BranchID=b.BranchID
join Admin.Tracks t
ON
i.BranchID=t.BranchID









-- VIEW Admin.to display instructors along with their assigned courses:
CREATE VIEW Admin.vw_InstructorsWithCourses AS
SELECT i.InstructorName, c.CourseName
from Admin.Instructors i
INNER JOIN Admin.InstructorCourses ic ON i.InstructorID = ic.InstructorID
INNER JOIN Admin.Courses c ON ic.CourseID = c.CourseID;


--VIEW Admin.to display the average scores of students in each course:
CREATE VIEW Admin.vw_AverageCourseScores AS
SELECT c.CourseName, AVG(CONVERT(FLOAT, sc.CourseScore)) AS AverageScore
from Admin.Courses c
LEFT JOIN Admin.StudentCourses sc ON c.CourseID = sc.CourseID
GROUP BY c.CourseName;

--VIEW Admin.to display exams along with their questions for a specific course:
CREATE VIEW Admin.vw_ExamsWithQuestions AS
SELECT e.ExamName, q.QuestionText, q.QuestionType
from Admin.Exams e
INNER JOIN Admin.ExamQuestions eq ON e.ExamID = eq.ExamID
INNER JOIN Admin.QuestionPool q ON eq.QuestionID = q.QuestionID;


-- VIEW Admin.to display all supervisors along with their supervised instructors:
CREATE VIEW Admin.vw_SupervisorsWithInstructors AS
SELECT s.InstructorName AS SupervisorName, i.InstructorName AS SupervisedInstructor
from Admin.Instructors i
INNER JOIN Admin.Instructors s ON i.SupervisorID = s.InstructorID;


--VIEW Admin.to display students along with their exams and scores:
CREATE VIEW Admin.vw_StudentExamScores AS
SELECT s.StudentName, e.ExamName, se.ExamDate, se.ExamStartTime, se.ExamEndTime, sa.IsCorrect
from Admin.Students s
INNER JOIN Admin.StudentExams se ON s.StudentID = se.StudentID
INNER JOIN Admin.Exams e ON se.ExamID = e.ExamID
INNER JOIN Admin.StudentAnswers sa ON se.StudentID = sa.StudentID AND se.ExamID = sa.ExamID;


--VIEW Admin.to display all courses with their topics:
CREATE VIEW Admin.vw_CoursesWithTopics AS
SELECT c.CourseID, c.CourseName, t.TopicName
from Admin.Courses c
INNER JOIN Admin.Topics t ON c.TopicId = t.TopicId;


--VIEW Admin.to display students along with their courses and scores:
CREATE VIEW Admin.vw_StudentCourseScores AS
SELECT s.StudentID, s.StudentName, c.CourseName, sc.CourseScore
from Admin.Students s
INNER JOIN Admin.StudentCourses sc ON s.StudentID = sc.StudentID
INNER JOIN Admin.Courses c ON sc.CourseID = c.CourseID;


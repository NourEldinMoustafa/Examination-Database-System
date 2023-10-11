use ExaminationSystemENDGAME
go

create trigger afterRegINcourse
on StudentCourses
After insert
AS
Begin
	declare @courId int
	declare @stId int
	select @courId = CourseID,@stId = StudentID
	from inserted

	declare @discribe varchar(max),@Cname varchar(255),@maxd int,@mind int

	select @discribe = CourseDescription,@Cname=CourseName,
			@maxd = CourseMaxDegree,@mind = CourseMinDegree
	from Courses
	where CourseID = @courId

	print N'You regstered in '''+ @Cname +'''course the max degree is '''  + @maxd +''' and  the min degree is '''  + @mind +''''

end;
drop trigger afterRegINcourse




-- after insert or update validate the answer

create TRIGGER trg_validateStudentAnswer
ON [Admin].[StudentAnswers]
AFTER INSERT, UPDATE
AS
BEGIN
    declare @corrAns varchar(max),
	@stdAns varchar(max), @iscorr int ,@quesid int;

	declare @stdid int, @exid int;


	select @quesid =QuestionID,
	@stdAns =StudentAnswer,
	@stdid = StudentID,
	@exid = ExamID

	from inserted;
	

	select @corrAns = CorrectAnswer
	from [Admin].[QuestionPool]
	where QuestionID = @quesid;

	if (@stdAns = @corrAns)	begin
		set @iscorr = 1
	end;
	else begin
		set @iscorr = 0
	end;

	update [Admin].[StudentAnswers]
	set IsCorrect = @iscorr
	where StudentID =@stdid and ExamID = @exid and QuestionID =@quesid ;

END;

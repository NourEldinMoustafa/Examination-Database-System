-- Create the backup job
EXEC msdb.dbo.sp_add_job @job_name = 'ExaminationSystemBackup';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'ExaminationSystemBackup', @step_name = 'BackupDatabase', @subsystem = 'TSQL', @command = 'BACKUP DATABASE ExaminationSystem TO DISK = ''C:\Backups\ExaminationSystem.bak'' WITH INIT';
EXEC msdb.dbo.sp_add_schedule @schedule_name = 'DailyBackup', @freq_type = 4, @freq_interval = 1, @active_start_time = 235900;
EXEC msdb.dbo.sp_attach_schedule @job_name = 'ExaminationSystemBackup', @schedule_name = 'DailyBackup';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'ExaminationSystemBackup';

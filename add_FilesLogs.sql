

sp_helptext add_FilesLogs
create procedure add_FilesLogs  
as  
begin   
    
  IF not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEMP_FILES_MEDISERVICE]') AND type in (N'U'))  
  begin   
   CREATE TABLE TEMP_FILES_MEDISERVICE  (   FileName VARCHAR(MAX),   DEPTH VARCHAR(MAX),   [FILE] VARCHAR(MAX)    )  
  end   
   else   
  begin   
    truncate table TEMP_FILES_MEDISERVICE  
  end  
   
  INSERT INTO TEMP_FILES_MEDISERVICE  
  EXEC master.dbo.xp_DirTree 'C:\Temp\Lendo_log_IIS\MediService\arqs_logs',1,1  
   
  select * from TEMP_FILES_MEDISERVICE where FileName like '%.log%'  
end   



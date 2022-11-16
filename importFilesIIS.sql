


USE [DATABASE]
GO

/****** Object:  StoredProcedure [dbo].[import_n_FilesLogs]    Script Date: 23/02/2022 21:06:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER procedure [dbo].[import_n_FilesLogs] 
as
begin 
	DECLARE @FILENAME VARCHAR(MAX),@SQL VARCHAR(MAX), @quant_files int
 
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TEMP_FILES_MEDISERVICE]') AND type in (N'U'))

	WHILE EXISTS(select * from TEMP_FILES_MEDISERVICE where FileName like '%.log%')
	BEGIN
	   BEGIN TRY
		  SET @FILENAME = (SELECT TOP 1 FileName FROM TEMP_FILES_MEDISERVICE where FileName like '%.log%')
		 /* 
		  SET @SQL = 'BULK INSERT  #TEMP_RESULTS
		  FROM ''C:\Temp\Lendo_log_IIS\IIS-Log-Reader-master\arq_logs\' + @FILENAME +'''
		  WITH (FIRSTROW = 4, FIELDTERMINATOR = '' '', ROWTERMINATOR = ''\n'');'
		  */
		  -- exemplo:   C:\Temp\Lendo_log_IIS\MediService\20211129\     <-- com barra no final
		  SET @SQL = 'exec Import_arquivoMediservice ''C:\Temp\Lendo_log_IIS\MediService\arqs_logs\'', ' + ''''+@FILENAME + ''''

		  PRINT @SQL
		  EXEC(@SQL)

	 

	   END TRY
	   BEGIN CATCH
		  PRINT 'Failed processing : ' + @FILENAME
	   END CATCH

	   DELETE FROM TEMP_FILES_MEDISERVICE WHERE FileName = @FILENAME
	end
end 
GO


--====================

 move_filiesLogs
 
 USE [DATABASE]
GO

/****** Object:  StoredProcedure [dbo].[move_filiesLogs]    Script Date: 23/02/2022 21:09:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER procedure [dbo].[move_filiesLogs]
as
begin 

    EXEC sp_configure 'show advanced option', '1'  
	RECONFIGURE WITH OVERRIDE
	
 	EXEC sp_configure 'xp_cmdshell', 1;  
	RECONFIGURE;
 
         Exec master..xp_cmdshell 'move C:\Temp\Lendo_log_IIS\MediService\arqs_logs\*.* C:\Temp\Lendo_log_IIS\MediService\arqs_logs\baklogs'

    EXEC sp_configure 'xp_cmdshell', 0  
    RECONFIGURE;

end 
GO

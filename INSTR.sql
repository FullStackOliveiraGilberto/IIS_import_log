USE [DATABASE]
GO

/****** Object:  UserDefinedFunction [dbo].[INSTR]    Script Date: 23/02/2022 21:26:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[INSTR] (@str VARCHAR(8000), @substr VARCHAR(255), @start INT, @occurrence INT)
  RETURNS INT
  AS
  BEGIN
	DECLARE @found INT = @occurrence,
			@pos INT = @start;
 
	WHILE 1=1 
	BEGIN
		-- Find the next occurrence
		SET @pos = CHARINDEX(@substr, @str, @pos);
 
		-- Nothing found
		IF @pos IS NULL OR @pos = 0
			RETURN @pos;
 
		-- The required occurrence found
		IF @found = 1
			BREAK;
 
		-- Prepare to find another one occurrence
		SET @found = @found - 1;
		SET @pos = @pos + 1;
	END
 
	RETURN @pos;
  END
GO

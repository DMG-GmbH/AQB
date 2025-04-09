USE [AQB]
GO

/****** Object:  UserDefinedFunction [dbo].[F_Projekttraeger]    Script Date: 11.09.2024 10:44:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Riemer, Birgit>
-- Create date: <08.12.2022>
-- Description:	<Fügt alle Projektträgerbezeichnungen (einschl. Ort) einer Maßnahme zu einem String zusammen>
-- =============================================
CREATE FUNCTION [dbo].[F_Projekttraeger](@Massnahme_ID int, @Trennzeichen nvarChar(3))
RETURNS varchar(255) 
AS
BEGIN

	DECLARE @result as varchar(255);
	DECLARE @zeile as varchar(255);
	SET @result = '';

	DECLARE result_cursor CURSOR FOR
		SELECT IIf([T_Massnahmen_Projekttraeger].[Massn_Projekttr_Projekttraeger_ID] > 0, 
            [T_Projekttraeger].[Projekttraeger_Name] + 
			IIf([T_Projekttraeger].[Projekttraeger_Ort] > '', ', ' + [T_Projekttraeger].[Projekttraeger_Ort], ''), '') AS Projekttraeger
		FROM  T_Projekttraeger INNER JOIN
            T_Massnahmen_Projekttraeger ON T_Projekttraeger.Projekttraeger_ID = T_Massnahmen_Projekttraeger.Massn_Projekttr_Projekttraeger_ID
		WHERE T_Massnahmen_Projekttraeger.Massn_Projekttr_Massnahme_ID = @Massnahme_ID;

	OPEN result_cursor;

	FETCH NEXT FROM result_cursor INTO @zeile
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @result = ''
				SET @result = @zeile
			ELSE
				SET @result = @result + @Trennzeichen + @zeile;
			FETCH NEXT FROM result_cursor INTO @zeile
		END

	CLOSE result_cursor;
	DEALLOCATE result_cursor;

	RETURN @result;
END;

GO

/****** Object:  UserDefinedFunction [dbo].[F_Sonderzeichen_entfernen]    Script Date: 11.09.2024 10:44:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Riemer, Birgit
-- Create date: 08.12.2022
-- Description:	ersetzen einiger Sonderzeichen (insbes. Zeilenumbruch durch '#'
-- =============================================
CREATE FUNCTION [dbo].[F_Sonderzeichen_entfernen](@Bezeichnung nvarChar(255))
RETURNS nvarchar(255) 
AS
BEGIN

	DECLARE @result as nvarchar(255);
	SET @result = @Bezeichnung;
	SET @result = Replace(@result, Char(13)+Char(10), ' # ');
	SET @result = Replace(@result, Char(10), '');
	SET @result = Replace(@result, Char(13), '');
	SET @result = Replace(@result, Char(150), Char(45));
	SET @result = RTrim(LTrim(@result));
	RETURN @result;
END;
GO
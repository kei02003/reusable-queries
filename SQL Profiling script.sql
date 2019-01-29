/*Author: Emily Tew
  Date: 2.21.2017
  Comments: I think this could be improved by adding the max value of each column or adding the distinct values of each column where there are only a handful of values, such as gender. I believe this 
  will require a pivot  
*/

SET NOCOUNT ON
DECLARE @Schema NVARCHAR(100) = 'aaAITT',
	   @Table NVARCHAR(100) = 'CHFEventBASE',
	   @DistinctLimit NVARCHAR(100) = '',
	   @sql NVARCHAR(MAX) ='';

IF OBJECT_ID ('tempdb..#Nulls') IS NOT NULL DROP TABLE #Nulls

CREATE TABLE #Nulls (ColumnName sysname , NullCount int , NonNullCount int, TotalCount int, DistinctCount int)

 SELECT @sql += 
    'SELECT  
	   '''+COLUMN_NAME+''' AS ColumnName
	   , SUM(CASE WHEN '+COLUMN_NAME+' IS NULL THEN 1 ELSE 0 END) CountNulls 
	   , COUNT(' +COLUMN_NAME+') CountnonNulls 
	   , COUNT(*) AS TotalCount
	   , COUNT(DISTINCT '+COLUMN_NAME+') AS CountDistinct 
	  
	FROM '+QUOTENAME(TABLE_SCHEMA)+'.'+QUOTENAME(TABLE_NAME)+
	';'+ CHAR(10)
 

 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = @Schema
 AND TABLE_NAME = @Table

 INSERT INTO #Nulls 
 EXEC sp_executesql @sql

 SELECT 
    ColumnName
    ,NullCount
    ,NonNullCount
    ,100 * ROUND(CAST(NullCount AS float)/CAST(TotalCount AS float),4) AS NullPCT
    ,100 * ROUND(CAST(NonNullCount AS float)/CAST(TotalCount AS float),4) AS NotNullPCT
    ,DistinctCount
  --  CASE WHEN DistinctCount <= @DistinctLimit  
	 --    THEN DISTINCT(ColumnName) 
		--END AS test
 FROM #Nulls

 DROP TABLE #Nulls
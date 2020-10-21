/*
SELECT  Category, [2006],[2007],[2008]
FROM    ( 
		  SELECT  Category, Qty, Orderyear 
		  FROM Sales.CategoryQtyYear
		) AS D 
		  PIVOT
		 (
		  SUM(QTY) FOR orderyear IN ([2006],[2007],[2008]
		 )
		) AS pvt
ORDER BY Category;
*/

DECLARE @sql nvarchar(MAX);
 
 SET @sql = N'
 
 SELECT
   * 
  FROM
  (  
    SELECT Category
         , Qty
         , Orderyear
    FROM Sales.CategoryQtyYear
  ) AS D
  PIVOT   
  (
  SUM(QTY)
  FOR orderyear IN (' + (SELECT STUFF(
 (
	 SELECT ',' + QUOTENAME(LTRIM(Orderyear))
	 FROM
	   (SELECT DISTINCT Orderyear
		FROM Sales.CategoryQtyYear
	   ) AS T
	 ORDER BY
	 Orderyear
	 FOR XML PATH('')
 ), 1, 1, '')) + N')
  ) AS P;'; 

 EXEC sp_executesql @sql;
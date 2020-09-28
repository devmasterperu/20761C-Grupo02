--DESARROLLO

--CREATE SCHEMA development
--GO

--CREATE TABLE [development].[Categories](
--	[categoryid] [int] NOT NULL,
--	[categoryname] [nvarchar](15) NOT NULL,
--	[description] [nvarchar](200) NOT NULL
--) ON [PRIMARY]
--GO

truncate table [development].[Categories]

insert into [development].[Categories]
select * from Production.Categories where categoryid between 1 and 5

select * from [development].[Categories]

--CALIDAD

--CREATE SCHEMA quality
--GO

--CREATE TABLE [quality].[Categories](
--	[categoryid] [int] NOT NULL,
--	[categoryname] [nvarchar](15) NOT NULL,
--	[description] [nvarchar](200) NOT NULL
--) ON [PRIMARY]
--GO

truncate table [quality].[Categories]
insert into [quality].[Categories]
select * from Production.Categories where categoryid between 4 and 8

update [quality].[Categories] set categoryname='otro',description='otro'

select * from [quality].[Categories]

--MERGE

MERGE quality.Categories as T
USING development.Categories as S
ON T.categoryid=S.categoryid
WHEN MATCHED 
	THEN UPDATE SET T.categoryname=S.categoryname,T.description=S.description
WHEN NOT MATCHED BY TARGET--NO HAY EMPAREJAMIENTO CON DESTINO
	THEN INSERT(categoryid,categoryname,description) values (S.categoryid,S.categoryname,S.description)
WHEN NOT MATCHED BY SOURCE THEN--NO HAY EMPAREJAMIENTO CON FUENTE
	DELETE;

select * from Development.Categories order by categoryid

select * from quality.Categories order by categoryid
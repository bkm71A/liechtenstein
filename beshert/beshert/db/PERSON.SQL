if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERSON]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERSON]
GO

CREATE TABLE [dbo].[PERSON] (
	[ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EMAIL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PASSWORD] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FIRST_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LAST_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[STREET] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[APT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CITY] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[STATE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ZIP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HOME_PHONE] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[WORK_PHONE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CELL_PHONE] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SEX] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BIRTHDATE] [smalldatetime] NOT NULL ,
	[REGISTRATION_DATE] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO


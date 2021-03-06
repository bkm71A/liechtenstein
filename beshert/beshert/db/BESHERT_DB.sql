if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_STATE]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PERSON] DROP CONSTRAINT FK_STATE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_PERSON_ID]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PERSON_EXTRA] DROP CONSTRAINT FK_PERSON_ID
GO

/****** Object:  Table [dbo].[PERSON_EXTRA]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERSON_EXTRA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERSON_EXTRA]
GO

/****** Object:  Table [dbo].[PERSON]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PERSON]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PERSON]
GO

/****** Object:  Table [dbo].[ETHNICITY]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ETHNICITY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ETHNICITY]
GO

/****** Object:  Table [dbo].[ASTROLOGICAL]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ASTROLOGICAL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ASTROLOGICAL]
GO

/****** Object:  Table [dbo].[BODY_TYPE]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BODY_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BODY_TYPE]
GO

/****** Object:  Table [dbo].[CHECKBOX_LIST]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CHECKBOX_LIST]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CHECKBOX_LIST]
GO

/****** Object:  Table [dbo].[EVENT]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EVENT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EVENT]
GO

/****** Object:  Table [dbo].[HAIR_COLOR]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HAIR_COLOR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[HAIR_COLOR]
GO

/****** Object:  Table [dbo].[KOSHER]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[KOSHER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[KOSHER]
GO

/****** Object:  Table [dbo].[OBJECTIVE]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OBJECTIVE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OBJECTIVE]
GO

/****** Object:  Table [dbo].[RELIGION]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RELIGION]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RELIGION]
GO

/****** Object:  Table [dbo].[STATE]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[STATE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[STATE]
GO

/****** Object:  Table [dbo].[SYNAGOGUE]    Script Date: 4/29/2003 12:32:38 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SYNAGOGUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SYNAGOGUE]
GO

/****** Object:  Table [dbo].[ETHNICITY]    Script Date: 4/29/2003 12:32:38 PM ******/
CREATE TABLE [dbo].[ETHNICITY] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ASTROLOGICAL]    Script Date: 4/29/2003 12:32:39 PM ******/
CREATE TABLE [dbo].[ASTROLOGICAL] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[BODY_TYPE]    Script Date: 4/29/2003 12:32:39 PM ******/
CREATE TABLE [dbo].[BODY_TYPE] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CHECKBOX_LIST]    Script Date: 4/29/2003 12:32:39 PM ******/
CREATE TABLE [dbo].[CHECKBOX_LIST] (
	[CODE] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SECTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EVENT]    Script Date: 4/29/2003 12:32:39 PM ******/
CREATE TABLE [dbo].[EVENT] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[EVENT_DATE] [datetime] NOT NULL ,
	[DESCRIPTION] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[LOCATION] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[IS_SPEED_DATING] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[HAIR_COLOR]    Script Date: 4/29/2003 12:32:39 PM ******/
CREATE TABLE [dbo].[HAIR_COLOR] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[KOSHER]    Script Date: 4/29/2003 12:32:39 PM ******/
CREATE TABLE [dbo].[KOSHER] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[OBJECTIVE]    Script Date: 4/29/2003 12:32:40 PM ******/
CREATE TABLE [dbo].[OBJECTIVE] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[RELIGION]    Script Date: 4/29/2003 12:32:40 PM ******/
CREATE TABLE [dbo].[RELIGION] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[STATE]    Script Date: 4/29/2003 12:32:40 PM ******/
CREATE TABLE [dbo].[STATE] (
	[CODE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SYNAGOGUE]    Script Date: 4/29/2003 12:32:40 PM ******/
CREATE TABLE [dbo].[SYNAGOGUE] (
	[CODE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DESCRIPTION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PERSON]    Script Date: 4/29/2003 12:32:40 PM ******/
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

/****** Object:  Table [dbo].[PERSON_EXTRA]    Script Date: 4/29/2003 12:32:41 PM ******/
CREATE TABLE [dbo].[PERSON_EXTRA] (
	[ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[OBJECTIVE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RELOCATE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[BIRTH_COUNTRY] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GREWUP_COUNTRY] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ASTROLOGICAL] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MARITAL_STATUS] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CHILDREN] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ETHNICITY] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RELIGION] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SYNAGOGUE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[KOSHER] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[HEIGHT] [real] NOT NULL ,
	[WEIGHT] [real] NULL ,
	[BODY_TYPE] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HAIR] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[EYE] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DRINK] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SMOKE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[HEALTH] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[OCCUPATION] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[INCOME] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DEGREE] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[STUDIES] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[POLITICAL] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PARTY] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ETHNICITY] WITH NOCHECK ADD 
	CONSTRAINT [PK_ETHNICITY] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ASTROLOGICAL] WITH NOCHECK ADD 
	CONSTRAINT [PK_ASTROLOGICAL] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BODY_TYPE] WITH NOCHECK ADD 
	CONSTRAINT [PK_BODY_TYPE] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[EVENT] WITH NOCHECK ADD 
	CONSTRAINT [PK_EVENT] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[HAIR_COLOR] WITH NOCHECK ADD 
	CONSTRAINT [PK_HAIR_COLOR] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[KOSHER] WITH NOCHECK ADD 
	CONSTRAINT [PK_KOSHER] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[OBJECTIVE] WITH NOCHECK ADD 
	CONSTRAINT [PK_OBJECTIVE] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RELIGION] WITH NOCHECK ADD 
	CONSTRAINT [PK_RELIGION] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[STATE] WITH NOCHECK ADD 
	CONSTRAINT [PK_STATE] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SYNAGOGUE] WITH NOCHECK ADD 
	CONSTRAINT [PK_SYNAGOGUE] PRIMARY KEY  CLUSTERED 
	(
		[CODE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERSON] WITH NOCHECK ADD 
	CONSTRAINT [PK_PERSON] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERSON_EXTRA] WITH NOCHECK ADD 
	CONSTRAINT [PK_PERSON_EXTRA] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PERSON] WITH NOCHECK ADD 
	CONSTRAINT [DF_PERSON_APT] DEFAULT (null) FOR [APT],
	CONSTRAINT [DF_PERSON_WORK_PHONE] DEFAULT (null) FOR [WORK_PHONE],
	CONSTRAINT [DF_PERSON_CELL_PHONE] DEFAULT (null) FOR [CELL_PHONE],
	CONSTRAINT [DF_PERSON_REGISTRATION_DATE] DEFAULT (getdate()) FOR [REGISTRATION_DATE],
	CONSTRAINT [CK_SEX] CHECK ([SEX] = 'M' or [SEX] = 'F')
GO

ALTER TABLE [dbo].[PERSON] ADD 
	CONSTRAINT [FK_STATE] FOREIGN KEY 
	(
		[STATE]
	) REFERENCES [dbo].[STATE] (
		[CODE]
	)
GO

ALTER TABLE [dbo].[PERSON_EXTRA] ADD 
	CONSTRAINT [FK_PERSON_ID] FOREIGN KEY 
	(
		[ID]
	) REFERENCES [dbo].[PERSON] (
		[ID]
	)
GO


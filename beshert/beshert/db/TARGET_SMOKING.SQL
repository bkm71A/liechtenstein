/****** Object:  Table [dbo].[TARGET_SMOKING]    Script Date: 5/24/2003 10:56:25 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TARGET_SMOKING]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TARGET_SMOKING]
GO

/****** Object:  Table [dbo].[TARGET_SMOKING]    Script Date: 5/24/2003 10:56:27 AM ******/
CREATE TABLE [dbo].[TARGET_SMOKING] (
	[USERID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SMOKING] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TARGET_SMOKING] ADD 
	CONSTRAINT [FK_TARGET_SMOKING] FOREIGN KEY 
	(
		[SMOKING]
	) REFERENCES [dbo].[SMOKE] (
		[CODE]
	),
	CONSTRAINT [FK_TARGET_SMOKING_ID] FOREIGN KEY 
	(
		[USERID]
	) REFERENCES [dbo].[PERSON] (
		[ID]
	)
GO
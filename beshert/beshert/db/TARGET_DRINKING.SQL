/****** Object:  Table [dbo].[TARGET_DRINKING]    Script Date: 5/24/2003 10:56:25 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TARGET_DRINKING]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TARGET_DRINKING]
GO

/****** Object:  Table [dbo].[TARGET_DRINKING]    Script Date: 5/24/2003 10:56:27 AM ******/
CREATE TABLE [dbo].[TARGET_DRINKING] (
	[USERID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[DRINKING] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TARGET_DRINKING] ADD 
	CONSTRAINT [FK_TARGET_DRINKING] FOREIGN KEY 
	(
		[DRINKING]
	) REFERENCES [dbo].[DRINK] (
		[CODE]
	),
	CONSTRAINT [FK_TARGET_DRINKING_ID] FOREIGN KEY 
	(
		[USERID]
	) REFERENCES [dbo].[PERSON] (
		[ID]
	)
GO
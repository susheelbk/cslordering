/****** Object:  Index [UrlNameUnique]    Script Date: 08/06/2018 20:08:01 ******/
ALTER TABLE [dbo].[DistributerUIDetails] ADD  CONSTRAINT [UrlNameUnique] UNIQUE NONCLUSTERED 
(
	[UrlName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



USE [bnh]
GO
/****** Object:  Schema [bl]    Script Date: 02/14/2012 12:13:43 ******/
CREATE SCHEMA [bl] AUTHORIZATION [dbo]
GO
/****** Object:  Table [bl].[city]    Script Date: 02/14/2012 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bl].[city](
	[city_id] [uniqueidentifier] NOT NULL,
	[city_name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_city] PRIMARY KEY CLUSTERED 
(
	[city_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bl].[builder]    Script Date: 02/14/2012 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bl].[builder](
	[builder_id] [uniqueidentifier] NOT NULL,
	[builder_name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_builder] PRIMARY KEY CLUSTERED 
(
	[builder_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bl].[community]    Script Date: 02/14/2012 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bl].[community](
	[community_id] [uniqueidentifier] NOT NULL,
	[community_name] [nvarchar](100) NOT NULL,
	[zone] [nvarchar](30) NOT NULL,
	[city_id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_community] PRIMARY KEY CLUSTERED 
(
	[community_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [bl].[community_builders]    Script Date: 02/14/2012 12:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bl].[community_builders](
	[community_id] [uniqueidentifier] NOT NULL,
	[builder_id] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_community_TO_city]    Script Date: 02/14/2012 12:13:43 ******/
ALTER TABLE [bl].[community]  WITH CHECK ADD  CONSTRAINT [FK_community_TO_city] FOREIGN KEY([city_id])
REFERENCES [bl].[city] ([city_id])
GO
ALTER TABLE [bl].[community] CHECK CONSTRAINT [FK_community_TO_city]
GO
/****** Object:  ForeignKey [FK_community_builders_TO_builder]    Script Date: 02/14/2012 12:13:43 ******/
ALTER TABLE [bl].[community_builders]  WITH CHECK ADD  CONSTRAINT [FK_community_builders_TO_builder] FOREIGN KEY([builder_id])
REFERENCES [bl].[builder] ([builder_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [bl].[community_builders] CHECK CONSTRAINT [FK_community_builders_TO_builder]
GO
/****** Object:  ForeignKey [FK_community_builders_TO_community]    Script Date: 02/14/2012 12:13:43 ******/
ALTER TABLE [bl].[community_builders]  WITH CHECK ADD  CONSTRAINT [FK_community_builders_TO_community] FOREIGN KEY([community_id])
REFERENCES [bl].[community] ([community_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [bl].[community_builders] CHECK CONSTRAINT [FK_community_builders_TO_community]
GO

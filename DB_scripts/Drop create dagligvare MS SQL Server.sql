USE [dagligvare]
GO

/****  Sletter avhengigheter og tabeller  *****/

IF (OBJECT_ID('FK_kjedevarepris_kjede', 'F') IS NOT NULL) BEGIN ALTER TABLE kjedevarepris DROP CONSTRAINT FK_kjedevarepris_kjede END
IF (OBJECT_ID('FK_kjedevarepris_vare', 'F') IS NOT NULL) BEGIN ALTER TABLE kjedevarepris DROP CONSTRAINT FK_kjedevarepris_vare END
IF (OBJECT_ID('FK_kjedebonus_kjede', 'F') IS NOT NULL) BEGIN ALTER TABLE kjedebonus DROP CONSTRAINT FK_kjedebonus_kjede END
IF (OBJECT_ID('FK_kjedevaregruppebonus_kjede', 'F') IS NOT NULL) BEGIN ALTER TABLE kjedevaregruppebonus DROP CONSTRAINT FK_kjedevaregruppebonus_kjede END
IF (OBJECT_ID('FK_kjedevaregruppebonus_varegruppe', 'F') IS NOT NULL) BEGIN ALTER TABLE kjedevaregruppebonus DROP CONSTRAINT FK_kjedevaregruppebonus_varegruppe END
IF (OBJECT_ID('FK_handel_kasse', 'F') IS NOT NULL) BEGIN ALTER TABLE handel DROP CONSTRAINT FK_handel_kasse END
IF (OBJECT_ID('FK_handel_kunde', 'F') IS NOT NULL) BEGIN ALTER TABLE handel DROP CONSTRAINT FK_handel_kunde END
IF (OBJECT_ID('FK_varelinje_handel', 'F') IS NOT NULL) BEGIN ALTER TABLE varelinje DROP CONSTRAINT FK_varelinje_handel END
IF (OBJECT_ID('FK_varelinje_vare', 'F') IS NOT NULL) BEGIN ALTER TABLE varelinje DROP CONSTRAINT FK_varelinje_vare END
IF (OBJECT_ID('FK_bonus_handel', 'F') IS NOT NULL) BEGIN ALTER TABLE bonus DROP CONSTRAINT FK_bonus_handel END
IF (OBJECT_ID('FK_bonus_varegruppe', 'F') IS NOT NULL) BEGIN ALTER TABLE bonus DROP CONSTRAINT FK_bonus_varegruppe END
IF (OBJECT_ID('FK_kommune_fylke', 'F') IS NOT NULL) BEGIN ALTER TABLE kommune DROP CONSTRAINT FK_kommune_fylke END
IF (OBJECT_ID('FK_kunde_kunde', 'F') IS NOT NULL) BEGIN ALTER TABLE kunde DROP CONSTRAINT FK_kunde_kunde END
IF (OBJECT_ID('FK_butikk_kjede', 'F') IS NOT NULL) BEGIN ALTER TABLE butikk DROP CONSTRAINT FK_butikk_kjede END
IF (OBJECT_ID('FK_butikk_kommune', 'F') IS NOT NULL) BEGIN ALTER TABLE butikk DROP CONSTRAINT FK_butikk_kommune END
IF (OBJECT_ID('FK_kasse_butikk', 'F') IS NOT NULL) BEGIN ALTER TABLE kasse DROP CONSTRAINT FK_kasse_butikk END
IF (OBJECT_ID('FK_vare_varegruppe', 'F') IS NOT NULL) BEGIN ALTER TABLE vare DROP CONSTRAINT FK_vare_varegruppe END
IF (OBJECT_ID('FK_vare_mengdeenhet', 'F') IS NOT NULL) BEGIN ALTER TABLE vare DROP CONSTRAINT FK_vare_mengdeenhet END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bonus]') AND type in (N'U'))
DROP TABLE [dbo].[bonus]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[varelinje]') AND type in (N'U'))
DROP TABLE [dbo].[varelinje]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[handel]') AND type in (N'U'))
DROP TABLE [dbo].[handel]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kjedevaregruppebonus]') AND type in (N'U'))
DROP TABLE [dbo].[kjedevaregruppebonus]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kjedebonus]') AND type in (N'U'))
DROP TABLE [dbo].[kjedebonus]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kjedevarepris]') AND type in (N'U'))
DROP TABLE [dbo].[kjedevarepris]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vare]') AND type in (N'U'))
DROP TABLE [dbo].[vare]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[varegruppe]') AND type in (N'U'))
DROP TABLE [dbo].[varegruppe]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[bruker]') AND type in (N'U'))
DROP TABLE [dbo].[bruker]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[brukertype]') AND type in (N'U'))
DROP TABLE [dbo].[brukertype]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mengdeenhet]') AND type in (N'U'))
DROP TABLE [dbo].[mengdeenhet]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kasse]') AND type in (N'U'))
DROP TABLE [dbo].[kasse]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[butikk]') AND type in (N'U'))
DROP TABLE [dbo].[butikk]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kjede]') AND type in (N'U'))
DROP TABLE [dbo].[kjede]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kunde]') AND type in (N'U'))
DROP TABLE [dbo].[kunde]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[kommune]') AND type in (N'U'))
DROP TABLE [dbo].[kommune]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fylke]') AND type in (N'U'))
DROP TABLE [dbo].[fylke]
GO

/****  Oppretter tabeller  *****/


/****** Object:  Table [dbo].[fylke] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[fylke](
	[fylke_nr] [smallint] NOT NULL,
	[fylke_nv] [varchar](255) NOT NULL,
 CONSTRAINT [PK_fylke] PRIMARY KEY CLUSTERED
(
	[fylke_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[kommune] ******/
CREATE TABLE [dbo].[kommune](
	[kommune_nr] [smallint] NOT NULL,
	[kommune_nv] [varchar](255) NOT NULL,
	[fylke_nr] [smallint] NOT NULL,
 CONSTRAINT [PK_kommune] PRIMARY KEY CLUSTERED 
(
	[kommune_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[kommune]  WITH CHECK ADD  CONSTRAINT [FK_kommune_fylke] FOREIGN KEY([fylke_nr])
REFERENCES [dbo].[fylke] ([fylke_nr])
GO

ALTER TABLE [dbo].[kommune] CHECK CONSTRAINT [FK_kommune_fylke]
GO

/****** Object:  Table [dbo].[kunde] ******/
CREATE TABLE [dbo].[kunde](
	[kunde_nr] [smallint] NOT NULL,
	[kunde_nv] [varchar](255) NOT NULL,
	[kommune_nr] [smallint] NOT NULL,
 CONSTRAINT [PK_kunde] PRIMARY KEY CLUSTERED 
(
	[kunde_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[kunde]  WITH CHECK ADD  CONSTRAINT [FK_kunde_kunde] FOREIGN KEY([kommune_nr])
REFERENCES [dbo].[kommune] ([kommune_nr])
GO

ALTER TABLE [dbo].[kunde] CHECK CONSTRAINT [FK_kunde_kunde]
GO

/****** Object:  Table [dbo].[kjede] ******/
CREATE TABLE [dbo].[kjede](
	[kjede_nr] [smallint] NOT NULL,
	[kjede_nv] [varchar](255) NOT NULL,
 CONSTRAINT [PK_kjede] PRIMARY KEY CLUSTERED 
(
	[kjede_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[butikk] ******/
CREATE TABLE [dbo].[butikk](
	[butikk_nr] [smallint] NOT NULL,
	[butikk_nv] [varchar](255) NOT NULL,
	[kjede_nr] [smallint] NOT NULL,
	[kommune_nr] [smallint] NOT NULL,
 CONSTRAINT [PK_butikk] PRIMARY KEY CLUSTERED 
(
	[butikk_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[butikk]  WITH CHECK ADD  CONSTRAINT [FK_butikk_kjede] FOREIGN KEY([kjede_nr])
REFERENCES [dbo].[kjede] ([kjede_nr])
GO

ALTER TABLE [dbo].[butikk] CHECK CONSTRAINT [FK_butikk_kjede]
GO

ALTER TABLE [dbo].[butikk]  WITH CHECK ADD  CONSTRAINT [FK_butikk_kommune] FOREIGN KEY([kommune_nr])
REFERENCES [dbo].[kommune] ([kommune_nr])
GO

ALTER TABLE [dbo].[butikk] CHECK CONSTRAINT [FK_butikk_kommune]
GO

/****** Object:  Table [dbo].[kasse] ******/
CREATE TABLE [dbo].[kasse](
	[butikk_nr] [smallint] NOT NULL,
	[kasse_nr] [smallint] NOT NULL,
	[bruker_nr] [smallint] NOT NULL,
 CONSTRAINT [PK_kasse] PRIMARY KEY CLUSTERED 
(
	[butikk_nr] ASC,
	[kasse_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[kasse]  WITH CHECK ADD  CONSTRAINT [FK_kasse_butikk] FOREIGN KEY([butikk_nr])
REFERENCES [dbo].[butikk] ([butikk_nr])
GO

ALTER TABLE [dbo].[kasse] CHECK CONSTRAINT [FK_kasse_butikk]
GO

/****** Object:  Table [dbo].[brukertype] ******/
CREATE TABLE [dbo].[brukertype](
	[brukertype_kd] [char](2) NOT NULL,
	[brukertype_nv] [varchar](45) NOT NULL,
 CONSTRAINT [PK_brukertype] PRIMARY KEY CLUSTERED 
(
	[brukertype_kd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[bruker] ******/
CREATE TABLE [dbo].[bruker](
	[bruker_nr] [integer] identity NOT NULL,
	[bruker_nv] [varchar](45) NOT NULL,
	[passord] [varchar](45) NOT NULL,
	[brukertype_kd] [char](2) NOT NULL,
 CONSTRAINT [PK_bruker] PRIMARY KEY CLUSTERED 
(
	[bruker_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[bruker]  WITH CHECK ADD  CONSTRAINT [FK_bruker_brukertype] FOREIGN KEY([brukertype_kd])
REFERENCES [dbo].[brukertype] ([brukertype_kd])
GO

/****** Object:  Table [dbo].[varegruppe] ******/
CREATE TABLE [dbo].[varegruppe](
	[varegruppe_nr] [smallint] NOT NULL,
	[varegruppe_nv] [varchar](255) NOT NULL,
	[mvasats_pct] [tinyint] NULL,
 CONSTRAINT [PK_varegruppe] PRIMARY KEY CLUSTERED 
(
	[varegruppe_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[varegruppe] ******/
CREATE TABLE [dbo].[mengdeenhet](
	[mengdeenhet_nr] [tinyint] NOT NULL,
	[mengdeenhet_nv] [varchar](255) NOT NULL,
 CONSTRAINT [PK_mengdeenhet] PRIMARY KEY CLUSTERED
(
	[mengdeenhet_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[vare]  ******/
CREATE TABLE [dbo].[vare](
	[vare_nr] [smallint] NOT NULL,
	[vare_nv] [varchar](255) NOT NULL,
	[varegruppe_nr] [smallint] NOT NULL,
	[mengdeenhet_nr] [tinyint] NOT NULL,
 CONSTRAINT [PK_vare] PRIMARY KEY CLUSTERED
(
	[vare_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[vare]  WITH CHECK ADD  CONSTRAINT [FK_vare_varegruppe] FOREIGN KEY([varegruppe_nr])
REFERENCES [dbo].[varegruppe] ([varegruppe_nr])
GO

ALTER TABLE [dbo].[vare]  WITH CHECK ADD  CONSTRAINT [FK_vare_mengdeenhet] FOREIGN KEY([mengdeenhet_nr])
REFERENCES [dbo].[mengdeenhet] ([mengdeenhet_nr])
GO

ALTER TABLE [dbo].[vare] CHECK CONSTRAINT [FK_vare_varegruppe]
GO

/****** Object:  Table [dbo].[kjedevarepris] ******/
CREATE TABLE [dbo].[kjedevarepris](
	[kjede_nr] [smallint] NOT NULL,
	[vare_nr] [smallint] NOT NULL,
	[gjelder_fra] [datetime] NOT NULL,
	[gjelder_til] [datetime] NULL,
	[enhetpris_bel] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_kjedevarepris] PRIMARY KEY CLUSTERED
(
	[kjede_nr] ASC,
	[vare_nr] ASC,
	[gjelder_fra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[kjedevarepris]  WITH CHECK ADD  CONSTRAINT [FK_kjedevarepris_kjede] FOREIGN KEY([kjede_nr])
REFERENCES [dbo].[kjede] ([kjede_nr])
GO

ALTER TABLE [dbo].[kjedevarepris] CHECK CONSTRAINT [FK_kjedevarepris_kjede]
GO

ALTER TABLE [dbo].[kjedevarepris]  WITH CHECK ADD  CONSTRAINT [FK_kjedevarepris_vare] FOREIGN KEY([vare_nr])
REFERENCES [dbo].[vare] ([vare_nr])
GO

ALTER TABLE [dbo].[kjedevarepris] CHECK CONSTRAINT [FK_kjedevarepris_vare]
GO

/****** Object:  Table [dbo].[kjedebonus] ******/
CREATE TABLE [dbo].[kjedebonus](
	[kjede_nr] [smallint] NOT NULL,
	[gjelder_fra] [datetime] NOT NULL,
	[gjelder_til] [datetime] NULL,
	[bonussats_pct] [smallint] NOT NULL,
 CONSTRAINT [PK_kjedebonus] PRIMARY KEY CLUSTERED 
(
	[kjede_nr] ASC, 
	[gjelder_fra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[kjedebonus]  WITH CHECK ADD  CONSTRAINT [FK_kjedebonus_kjede] FOREIGN KEY([kjede_nr])
REFERENCES [dbo].[kjede] ([kjede_nr])
GO

ALTER TABLE [dbo].[kjedebonus] CHECK CONSTRAINT [FK_kjedebonus_kjede]
GO

/****** Object:  Table [dbo].[kjedevaregruppebonus] ******/
CREATE TABLE [dbo].[kjedevaregruppebonus](
	[kjede_nr] [smallint] NOT NULL,
	[varegruppe_nr] [smallint] NOT NULL,
	[gjelder_fra] [datetime] NOT NULL,
	[gjelder_til] [datetime] NULL,
	[bonussats_pct] [smallint] NOT NULL,
 CONSTRAINT [PK_kjedevaregruppebonus] PRIMARY KEY CLUSTERED 
(
	[kjede_nr] ASC,
	[varegruppe_nr] ASC,
	[gjelder_fra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[kjedevaregruppebonus]  WITH CHECK ADD  CONSTRAINT [FK_kjedevaregruppebonus_kjede] FOREIGN KEY([kjede_nr])
REFERENCES [dbo].[kjede] ([kjede_nr])
GO

ALTER TABLE [dbo].[kjedevaregruppebonus] CHECK CONSTRAINT [FK_kjedevaregruppebonus_kjede]
GO

ALTER TABLE [dbo].[kjedevaregruppebonus]  WITH CHECK ADD  CONSTRAINT [FK_kjedevaregruppebonus_varegruppe] FOREIGN KEY([varegruppe_nr])
REFERENCES [dbo].[varegruppe] ([varegruppe_nr])
GO

ALTER TABLE [dbo].[kjedevaregruppebonus] CHECK CONSTRAINT [FK_kjedevaregruppebonus_varegruppe]
GO

/****** Object:  Table [dbo].[handel] ******/
CREATE TABLE [dbo].[handel](
	[handel_nr] [int] identity NOT NULL,
	[tidspunkt] [datetime] NOT NULL,
	[butikk_nr] [smallint] NOT NULL,
	[kasse_nr] [smallint] NOT NULL,
	[kunde_nr] [smallint] NOT NULL,
	[handel_bel] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_handel] PRIMARY KEY CLUSTERED 
(
	[handel_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[handel]  WITH CHECK ADD  CONSTRAINT [FK_handel_kasse] FOREIGN KEY([butikk_nr], [kasse_nr])
REFERENCES [dbo].[kasse] ([butikk_nr], [kasse_nr])
GO

ALTER TABLE [dbo].[handel] CHECK CONSTRAINT [FK_handel_kasse]
GO

ALTER TABLE [dbo].[handel]  WITH CHECK ADD  CONSTRAINT [FK_handel_kunde] FOREIGN KEY([kunde_nr])
REFERENCES [dbo].[kunde] ([kunde_nr])
GO

ALTER TABLE [dbo].[handel] CHECK CONSTRAINT [FK_handel_kunde]
GO

/****** Object:  Table [dbo].[varelinje] ******/

CREATE TABLE [dbo].[varelinje](
	[handel_nr] [int] NOT NULL,
	[varelinje_nr] [smallint] NOT NULL,
	[vare_nr] [smallint] NOT NULL,
	[enhet_ant] [decimal](7, 3) NOT NULL,
	[enhetpris_bel] [decimal](7, 2) NOT NULL,
	[varelinje_bel] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_varelinje] PRIMARY KEY CLUSTERED 
(
	[handel_nr] ASC,
	[varelinje_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[varelinje]  WITH CHECK ADD  CONSTRAINT [FK_varelinje_handel] FOREIGN KEY([handel_nr])
REFERENCES [dbo].[handel] ([handel_nr])
GO

ALTER TABLE [dbo].[varelinje] CHECK CONSTRAINT [FK_varelinje_handel]
GO

ALTER TABLE [dbo].[varelinje]  WITH CHECK ADD  CONSTRAINT [FK_varelinje_vare] FOREIGN KEY([vare_nr])
REFERENCES [dbo].[vare] ([vare_nr])
GO

ALTER TABLE [dbo].[varelinje] CHECK CONSTRAINT [FK_varelinje_vare]
GO

/****** Object:  Table [dbo].[bonus] ******/
CREATE TABLE [dbo].[bonus](
	[handel_nr] [int] NOT NULL,
	[varegruppe_nr] [smallint] NOT NULL,
	[bonus_bel] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_bonus] PRIMARY KEY CLUSTERED 
(
	[handel_nr] ASC,
	[varegruppe_nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[bonus]  WITH CHECK ADD  CONSTRAINT [FK_bonus_handel] FOREIGN KEY([handel_nr])
REFERENCES [dbo].[handel] ([handel_nr])
GO

ALTER TABLE [dbo].[bonus] CHECK CONSTRAINT [FK_bonus_handel]
GO

ALTER TABLE [dbo].[bonus]  WITH CHECK ADD  CONSTRAINT [FK_bonus_varegruppe] FOREIGN KEY([varegruppe_nr])
REFERENCES [dbo].[varegruppe] ([varegruppe_nr])
GO

ALTER TABLE [dbo].[bonus] CHECK CONSTRAINT [FK_bonus_varegruppe]
GO

/** Setter identity_insert til on for å tillate eksplisitte verdier for IDENTITY i tabell hanel */

set identity_insert handel on;




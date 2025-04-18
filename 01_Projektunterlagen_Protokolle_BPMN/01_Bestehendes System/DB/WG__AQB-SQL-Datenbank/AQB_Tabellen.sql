USE [AQB]
GO
/****** Object:  Table [dbo].[T_Ansprechpartner]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Ansprechpartner](
	[Ansprechp_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ansprechp_Antragsteller_ID] [int] NULL,
	[Ansprechp_Anschreiben] [bit] NOT NULL,
	[Ansprechp_Hauptanspr] [bit] NOT NULL,
	[Ansprechp_Anrede] [nvarchar](4) NULL,
	[Ansprechp_Titel] [nvarchar](20) NULL,
	[Ansprechp_Nachname] [nvarchar](30) NULL,
	[Ansprechp_Vorname] [nvarchar](30) NULL,
	[Ansprechp_Funktion] [nvarchar](50) NULL,
	[Ansprechp_Telefon] [nvarchar](20) NULL,
	[Ansprechp_Mobil] [nvarchar](30) NULL,
	[Ansprechp_Fax] [nvarchar](20) NULL,
	[Ansprechp_E_Mail] [nvarchar](100) NULL,
	[Ansprechp_Erfasser] [nvarchar](50) NULL,
	[Ansprechp_Erfassungsdatum] [datetime] NULL,
	[Ansprechp_Geaendert_von] [nvarchar](50) NULL,
	[Ansprechp_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Ansprechpartner] PRIMARY KEY CLUSTERED 
(
	[Ansprechp_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Antraege]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Antraege](
	[Antrag_ID] [int] IDENTITY(1,1) NOT NULL,
	[Antrag_Antragsteller_ID] [int] NULL,
	[Antrag_Jahr] [nvarchar](4) NULL,
	[Antrag_Durchfuehrungszeitraum_Beginn] [datetime] NULL,
	[Antrag_Durchfuehrungszeitraum_Ende] [datetime] NULL,
	[Antrag_Sachb_ID] [int] NULL,
	[Antrag_Inaussichtstellung_Datum] [datetime] NULL,
	[Antrag_Wiedervorlage_Datum] [datetime] NULL,
	[Antrag_Abgeschlossen] [bit] NOT NULL,
	[Antrag_Erfasser] [nvarchar](50) NULL,
	[Antrag_Erfassungsdatum] [datetime] NULL,
	[Antrag_Geaendert_von] [nvarchar](50) NULL,
	[Antrag_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Antraege] PRIMARY KEY CLUSTERED 
(
	[Antrag_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_T_Antraege] UNIQUE NONCLUSTERED 
(
	[Antrag_Antragsteller_ID] ASC,
	[Antrag_Jahr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Antraege_Detail]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Antraege_Detail](
	[Antrag_Detail_Antrag_ID] [int] NOT NULL,
	[Antrag_Detail_lfd_Nr] [tinyint] NOT NULL,
	[Antrag_Detail_Antragsart] [tinyint] NULL,
	[Antrag_Detail_Antragsdatum] [datetime] NULL,
	[Antrag_Detail_Eingangsdatum] [datetime] NULL,
	[Antrag_Detail_Zuwendungsbescheid_Datum] [datetime] NULL,
	[Antrag_Detail_Aenderungsbescheid_Datum] [datetime] NULL,
	[Antrag_Detail_Buchungsaenderung] [datetime] NULL,
	[Antrag_Detail_Bestandskraft] [bit] NOT NULL,
	[Antrag_Detail_Sachb_ID] [int] NULL,
	[Antrag_Detail_Massnahmeart_1] [bit] NOT NULL,
	[Antrag_Detail_Massnahmeart_2] [bit] NOT NULL,
	[Antrag_Detail_Massnahmeart_3] [bit] NOT NULL,
	[Antrag_Detail_Massnahmeart_4] [bit] NOT NULL,
	[Antrag_Detail_Massnahmeart_5] [bit] NOT NULL,
	[Antrag_Detail_Bemerkung] [nvarchar](255) NULL,
	[Antrag_Detail_Sachbericht_Ende] [datetime] NULL,
	[Antrag_Detail_Erfasser] [nvarchar](50) NULL,
	[Antrag_Detail_Erfassungsdatum] [datetime] NULL,
	[Antrag_Detail_Geaendert_von] [nvarchar](50) NULL,
	[Antrag_Detail_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Antraege_Detail] PRIMARY KEY CLUSTERED 
(
	[Antrag_Detail_Antrag_ID] ASC,
	[Antrag_Detail_lfd_Nr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Antraege_Nachweise]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Antraege_Nachweise](
	[Antrag_Nachweis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Antrag_Nachweis_Antrag_ID] [int] NULL,
	[Antrag_Nachweis_Antrag_Jahr] [nvarchar](4) NULL,
	[Antrag_Nachweis_Nachweis_ID] [int] NULL,
	[Antrag_Nachweis_Abgabefrist_Datum] [datetime] NULL,
	[Antrag_Nachweis_Verlaengerung_Abgabefrist_Datum] [datetime] NULL,
	[Antrag_Nachweis_Eingangsdatum] [datetime] NULL,
	[Antrag_Nachweis_korrekt] [bit] NOT NULL,
	[Antrag_Nachweis_unzureichend] [bit] NOT NULL,
	[Antrag_Nachweis_Sachb_ID] [int] NULL,
	[Antrag_Nachweis_Bemerkung] [nvarchar](200) NULL,
	[Antrag_Nachweis_Erfasser] [nvarchar](50) NULL,
	[Antrag_Nachweis_Erfassungsdatum] [datetime] NULL,
	[Antrag_Nachweis_Geaendert_von] [nvarchar](50) NULL,
	[Antrag_Nachweis_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Antraege_Nachweise] PRIMARY KEY CLUSTERED 
(
	[Antrag_Nachweis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Antragsteller]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Antragsteller](
	[Antragsteller_ID] [int] IDENTITY(1,1) NOT NULL,
	[Antragsteller_Kontext] [nvarchar](5) NULL,
	[Antragsteller_Landkreis_ID] [int] NULL,
	[Antragsteller_Kuerzel] [nvarchar](8) NULL,
	[Antragsteller_Name] [nvarchar](255) NULL,
	[Antragsteller_Anschreiben_Name_1] [nvarchar](255) NULL,
	[Antragsteller_Anschreiben_Name_2] [nvarchar](255) NULL,
	[Antragsteller_Strasse] [nvarchar](50) NULL,
	[Antragsteller_Plz] [nvarchar](5) NULL,
	[Antragsteller_Ort] [nvarchar](40) NULL,
	[Antragsteller_IBAN] [nvarchar](22) NULL,
	[Antragsteller_BIC] [nvarchar](11) NULL,
	[Antragsteller_Bank] [nvarchar](50) NULL,
	[Antragsteller_Kreditoren_Nr] [nvarchar](20) NULL,
	[Antragsteller_Strategie_aus_Jahr] [nvarchar](4) NULL,
	[Antragsteller_Erfasser] [nvarchar](50) NULL,
	[Antragsteller_Erfassungsdatum] [datetime] NULL,
	[Antragsteller_Geaendert_von] [nvarchar](50) NULL,
	[Antragsteller_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Antragsteller] PRIMARY KEY CLUSTERED 
(
	[Antragsteller_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Arbeitslosmeldung]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Arbeitslosmeldung](
	[Arbeitslosmeld_ID] [int] IDENTITY(1,1) NOT NULL,
	[Arbeitslosmeld_Text] [nvarchar](100) NULL,
	[Arbeitslosmeld_Erfasser] [nvarchar](50) NULL,
	[Arbeitslosmeld_Erfassungsdatum] [datetime] NULL,
	[Arbeitslosmeld_Geaendert_von] [nvarchar](50) NULL,
	[Arbeitslosmeld_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Arbeitslosmeldung] PRIMARY KEY CLUSTERED 
(
	[Arbeitslosmeld_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Austrittsgruende]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Austrittsgruende](
	[Austrittsgrund_ID] [int] IDENTITY(1,1) NOT NULL,
	[Austrittsgrund_Bezeichnung] [nvarchar](50) NULL,
	[Austrittsgrund_Erfasser] [nvarchar](50) NULL,
	[Austrittsgrund_Erfassungsdatum] [datetime] NULL,
	[Austrittsgrund_Geaendert_von] [nvarchar](50) NULL,
	[Austrittsgrund_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Austrittsgruende] PRIMARY KEY CLUSTERED 
(
	[Austrittsgrund_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Auswertung_Datenselektion]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Auswertung_Datenselektion](
	[Auswert_ID] [int] IDENTITY(1,1) NOT NULL,
	[Auswert_Kontext] [nvarchar](5) NULL,
	[Auswert_Kuerzel] [nvarchar](8) NULL,
	[Auswert_Antrag_Jahr_von] [nvarchar](4) NULL,
	[Auswert_Antrag_Jahr_bis] [nvarchar](4) NULL,
	[Auswert_Jahr] [nvarchar](4) NULL,
 CONSTRAINT [PK_T_Auswertung_Datenselektion] PRIMARY KEY CLUSTERED 
(
	[Auswert_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Auswertungen]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Auswertungen](
	[Auswertung_ID] [int] IDENTITY(1,1) NOT NULL,
	[Auswertung_Bezeichnung] [nvarchar](100) NULL,
	[Auswertung_Abfrage] [nvarchar](100) NULL,
	[Auswertung_Kategorie_ID] [int] NULL,
	[Auswertung_Kontext] [bit] NOT NULL,
	[Auswertung_Kuerzel] [bit] NOT NULL,
	[Auswertung_Antrag_Jahr] [bit] NOT NULL,
	[Auswertung_Jahr] [bit] NOT NULL,
	[Auswertung_Erfasser] [nvarchar](50) NULL,
	[Auswertung_Erfassungsdatum] [datetime] NULL,
	[Auswertung_Geaendert_von] [nvarchar](50) NULL,
	[Auswertung_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Auswertungen] PRIMARY KEY CLUSTERED 
(
	[Auswertung_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Auswertungskategorien]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Auswertungskategorien](
	[Ausw_Kategorie_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ausw_Kategorie_Text] [nvarchar](150) NULL,
	[Ausw_Kategorie_Erfasser] [nvarchar](50) NULL,
	[Ausw_Kategorie_Erfassungsdatum] [datetime] NULL,
	[Ausw_Kategorie_Geaendert_von] [nvarchar](50) NULL,
	[Ausw_Kategorie_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Auswertungskategorien] PRIMARY KEY CLUSTERED 
(
	[Ausw_Kategorie_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Benachteiligungsarten]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Benachteiligungsarten](
	[Benachteiligungsart_ID] [int] IDENTITY(1,1) NOT NULL,
	[Benachteiligungsart_Text] [nvarchar](50) NULL,
	[Benachteiligungsart_Erfasser] [nvarchar](50) NULL,
	[Benachteiligungsart_Erfassungsdatum] [datetime] NULL,
	[Benachteiligungsart_Geaendert_von] [nvarchar](50) NULL,
	[Benachteiligungsart_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Benachteiligungsarten] PRIMARY KEY CLUSTERED 
(
	[Benachteiligungsart_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Bildungsstand]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Bildungsstand](
	[Bildungsstand_ID] [int] IDENTITY(1,1) NOT NULL,
	[Bildungsstand_Text] [nvarchar](150) NULL,
	[Bildungsstand_Erfasser] [nvarchar](50) NULL,
	[Bildungsstand_Erfassungsdatum] [datetime] NULL,
	[Bildungsstand_Geaendert_von] [nvarchar](50) NULL,
	[Bildungsstand_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Bildungsstand] PRIMARY KEY CLUSTERED 
(
	[Bildungsstand_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Erwerbstaetigkeit]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Erwerbstaetigkeit](
	[Erwerbstaetigkeit_ID] [int] IDENTITY(1,1) NOT NULL,
	[Erwerbstaetigkeit_Text] [nvarchar](100) NULL,
	[Erwerbstaetigkeit_Erfasser] [nvarchar](50) NULL,
	[Erwerbstaetigkeit_Erfassungsdatum] [datetime] NULL,
	[Erwerbstaetigkeit_Geaendert_von] [nvarchar](50) NULL,
	[Erwerbstaetigkeit_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Erwerbstaetigkeit] PRIMARY KEY CLUSTERED 
(
	[Erwerbstaetigkeit_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Excel_Kofinanzierung]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Excel_Kofinanzierung](
	[Antragsteller_Kuerzel] [nvarchar](7) NOT NULL,
	[Antrag_Jahr] [nvarchar](4) NOT NULL,
	[Sonstige_oeffentliche_Mittel] [money] NULL,
	[Bundesagentur_fuer_Arbeit] [money] NULL,
	[Andere_Bundesmittel] [money] NULL,
	[Kommunale_Mittel] [money] NULL,
	[Private_Mittel] [money] NULL,
	[Projekteinnahmen_Projekterloese] [money] NULL,
	[Landesmittel_Gesamt] [money] NULL,
	[Auszahlungen_Gesamt] [money] NULL,
 CONSTRAINT [PK_T_Excel_Kofinanzierung] PRIMARY KEY CLUSTERED 
(
	[Antragsteller_Kuerzel] ASC,
	[Antrag_Jahr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Foerdermittel]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Foerdermittel](
	[Foerdermittel_ID] [int] IDENTITY(1,1) NOT NULL,
	[Foerdermittel_Bezeichnung] [nvarchar](50) NULL,
	[Foerdermittel_Erfasser] [nvarchar](50) NULL,
	[Foerdermittel_Erfassungsdatum] [datetime] NULL,
	[Foerdermittel_Geaendert_von] [nvarchar](50) NULL,
	[Foerdermittel_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Foerdermittel] PRIMARY KEY CLUSTERED 
(
	[Foerdermittel_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Gebietskoerperschaften]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Gebietskoerperschaften](
	[Gebietskoerp_Kuerzel] [nvarchar](8) NOT NULL,
	[Gebietskoerp_Bezeichnung] [nvarchar](50) NULL,
	[Gebietskoerp_Regierungsbezirk_ID] [int] NULL,
	[Gebietskoerp_Verwaltungsgericht_ID] [int] NULL,
	[Gebietskoerp_Erfasser] [nvarchar](50) NULL,
	[Gebietskoerp_Erfassungsdatum] [datetime] NULL,
	[Gebietskoerp_Geaendert_von] [nvarchar](50) NULL,
	[Gebietskoerp_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Gebietskoerperschaften] PRIMARY KEY CLUSTERED 
(
	[Gebietskoerp_Kuerzel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Hausadressen]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Hausadressen](
	[Hausadresse_ID] [int] IDENTITY(1,1) NOT NULL,
	[Hausadresse_Internet] [nvarchar](50) NULL,
	[Hausadresse_Strasse] [nvarchar](50) NULL,
	[Hausadresse_Ort] [nvarchar](50) NULL,
	[Hausadresse_PLZ] [nvarchar](5) NULL,
	[Hausadresse_Dienststellen_Nr] [nvarchar](4) NULL,
	[Hausadresse_Erfasser] [nvarchar](50) NULL,
	[Hausadresse_Erfassungsdatum] [datetime] NULL,
	[Hausadresse_Geaendert_von] [nvarchar](50) NULL,
	[Hausadresse_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Hausadressen] PRIMARY KEY CLUSTERED 
(
	[Hausadresse_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Haushalt_Auszahlungen]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Haushalt_Auszahlungen](
	[Haushalt_Auszahl_Antrag_ID] [int] NOT NULL,
	[Haushalt_Auszahl_Rate] [tinyint] NOT NULL,
	[Haushalt_Auszahl_Foerdermittelart] [nvarchar](2) NULL,
	[Haushalt_Auszahl_Jahr] [nvarchar](4) NULL,
	[Haushalt_Auszahl_Betrag] [money] NULL,
	[Haushalt_Auszahl_Auszahlungsdatum] [datetime] NULL,
	[Haushalt_Auszahl_Storno] [bit] NOT NULL,
	[Haushalt_Auszahl_Bemerkung] [nvarchar](255) NULL,
	[Haushalt_Auszahl_Erfasser] [nvarchar](50) NULL,
	[Haushalt_Auszahl_Erfassungsdatum] [datetime] NULL,
	[Haushalt_Auszahl_Geaendert_von] [nvarchar](50) NULL,
	[Haushalt_Auszahl_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Haushalt_Auszahlungen] PRIMARY KEY CLUSTERED 
(
	[Haushalt_Auszahl_Antrag_ID] ASC,
	[Haushalt_Auszahl_Rate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Haushalt_Finanzierungsplan]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Haushalt_Finanzierungsplan](
	[Haushalt_Finanz_Plan_Massnahme_ID] [int] NOT NULL,
	[Haushalt_Finanz_Plan_Foerdermittelart] [nvarchar](2) NULL,
	[Haushalt_Finanz_Plan_Jahr] [nvarchar](4) NOT NULL,
	[Haushalt_Finanz_Plan_Betrag] [money] NULL,
	[Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge] [money] NULL,
	[Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge] [money] NULL,
	[Haushalt_Finanz_Plan_Erfasser] [nvarchar](50) NULL,
	[Haushalt_Finanz_Plan_Erfassungsdatum] [datetime] NULL,
	[Haushalt_Finanz_Plan_Geaendert_von] [nvarchar](50) NULL,
	[Haushalt_Finanz_Plan_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Haushalt_Finanzierungsplan] PRIMARY KEY CLUSTERED 
(
	[Haushalt_Finanz_Plan_Massnahme_ID] ASC,
	[Haushalt_Finanz_Plan_Jahr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Haushalt_Kofinanzierung]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Haushalt_Kofinanzierung](
	[Haushalt_Kofinanz_Massnahme_ID] [int] NOT NULL,
	[Haushalt_Kofinanz_Foerdermittel_ID] [int] NOT NULL,
	[Haushalt_Kofinanz_Betrag] [money] NULL,
	[Haushalt_Kofinanz_Erfasser] [nvarchar](50) NULL,
	[Haushalt_Kofinanz_Erfassungsdatum] [datetime] NULL,
	[Haushalt_Kofinanz_Geaendert_von] [nvarchar](50) NULL,
	[Haushalt_Kofinanz_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Haushalt_Kofinanzierung] PRIMARY KEY CLUSTERED 
(
	[Haushalt_Kofinanz_Massnahme_ID] ASC,
	[Haushalt_Kofinanz_Foerdermittel_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Haushalt_Verteilung_Landesmittel]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel](
	[Haushalt_Verteil_Antrag_ID] [int] NOT NULL,
	[Haushalt_Verteil_Zeitpunkt_ID] [int] NOT NULL,
	[Haushalt_Verteil_Foerdermittelart] [nvarchar](2) NULL,
	[Haushalt_Verteil_Jahr] [nvarchar](4) NOT NULL,
	[Haushalt_Verteil_Allgemeine_Mittel] [money] NULL,
	[Haushalt_Verteil_Sprachfoerd_Fluechtlinge] [money] NULL,
	[Haushalt_Verteil_Qualifizierung_Fluechtlinge] [money] NULL,
	[Haushalt_Verteil_Sozialwirtschaft_integriert] [money] NULL,
	[Haushalt_Verteil_Erfasser] [nvarchar](50) NULL,
	[Haushalt_Verteil_Erfassungsdatum] [datetime] NULL,
	[Haushalt_Verteil_Geaendert_von] [nvarchar](50) NULL,
	[Haushalt_Verteil_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Haushalt_Verteilung_Landesmittel] PRIMARY KEY CLUSTERED 
(
	[Haushalt_Verteil_Antrag_ID] ASC,
	[Haushalt_Verteil_Zeitpunkt_ID] ASC,
	[Haushalt_Verteil_Jahr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand](
	[Haushalt_Stand_Antrag_ID] [int] NOT NULL,
	[Haushalt_Stand_Zeitpunkt_ID] [int] NOT NULL,
	[Haushalt_Stand_Datum] [datetime] NULL,
	[Haushalt_Stand_Erfasser] [nvarchar](50) NULL,
	[Haushalt_Stand_Erfassungsdatum] [datetime] NULL,
	[Haushalt_Stand_Geaendert_von] [nvarchar](50) NULL,
	[Haushalt_Stand_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Haushalt_Verteilung_Landesmittel_Stand] PRIMARY KEY CLUSTERED 
(
	[Haushalt_Stand_Antrag_ID] ASC,
	[Haushalt_Stand_Zeitpunkt_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Haushaltssituation]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Haushaltssituation](
	[Haushaltssituation_ID] [int] IDENTITY(1,1) NOT NULL,
	[Haushaltssituation_Text] [nvarchar](100) NULL,
	[Haushaltssituation_Erfasser] [nvarchar](50) NULL,
	[Haushaltssituation_Erfassungsdatum] [datetime] NULL,
	[Haushaltssituation_Geaendert_von] [nvarchar](50) NULL,
	[Haushaltssituation_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Haushaltssituation] PRIMARY KEY CLUSTERED 
(
	[Haushaltssituation_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Kontext]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Kontext](
	[Kontext] [nvarchar](5) NOT NULL,
	[Kontext_Bezeichnung] [nvarchar](100) NULL,
	[Kontext_Erfasser] [nvarchar](50) NULL,
	[Kontext_Erfassungsdatum] [datetime] NULL,
	[Kontext_Geaendert_von] [nvarchar](50) NULL,
	[Kontext_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Kontext] PRIMARY KEY CLUSTERED 
(
	[Kontext] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Landkreise]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Landkreise](
	[Landkreis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Landkreis_Bezeichnung] [nvarchar](150) NULL,
	[Landkreis_Erfasser] [nvarchar](50) NULL,
	[Landkreis_Erfassungsdatum] [datetime] NULL,
	[Landkreis_Geaendert_von] [nvarchar](50) NULL,
	[Landkreis_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Landkreise] PRIMARY KEY CLUSTERED 
(
	[Landkreis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Leistungsbezug_SGB]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Leistungsbezug_SGB](
	[Leistungsbezug_ID] [int] IDENTITY(1,1) NOT NULL,
	[Leistungsbezug_Text] [nvarchar](100) NULL,
	[Leistungsbezug_Erfasser] [nvarchar](50) NULL,
	[Leistungsbezug_Erfassungsdatum] [datetime] NULL,
	[Leistungsbezug_Geaendert_von] [nvarchar](50) NULL,
	[Leistungsbezug_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Leistungsbezug_SGB] PRIMARY KEY CLUSTERED 
(
	[Leistungsbezug_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Massnahmearten]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Massnahmearten](
	[Massnahmeart_ID] [int] IDENTITY(1,1) NOT NULL,
	[Massnahmeart_Bezeichnung] [nvarchar](100) NULL,
	[Massnahmeart_Erfasser] [nvarchar](50) NULL,
	[Massnahmeart_Erfassungsdatum] [datetime] NULL,
	[Massnahmeart_Geaendert_von] [nvarchar](50) NULL,
	[Massnahmeart_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Massnahmearten] PRIMARY KEY CLUSTERED 
(
	[Massnahmeart_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Massnahmen]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Massnahmen](
	[Massnahme_ID] [int] IDENTITY(1,1) NOT NULL,
	[Massnahme_Antrag_Detail_Antrag_ID] [int] NULL,
	[Massnahme_Antrag_Detail_lfd_Nr] [tinyint] NULL,
	[Massnahme_Massnahmeart_ID] [int] NULL,
	[Massnahme_Nr] [int] NULL,
	[Massnahme_Aktenzeichen] [nvarchar](21) NULL,
	[Massnahme_Bezeichnung] [nvarchar](255) NULL,
	[Massnahme_Kurzbeschreibung] [nvarchar](max) NULL,
	[Massnahme_Beginn] [datetime] NULL,
	[Massnahme_Ende] [datetime] NULL,
	[Massnahme_Digitales_Lernen] [bit] NOT NULL,
	[Massnahme_Mittel_Vergabe] [bit] NOT NULL,
	[Massnahme_Mittel_Zuwendung] [bit] NOT NULL,
	[Massnahme_Durchgaenge] [tinyint] NULL,
	[Massnahme_Ausbildung] [tinyint] NULL,
	[Massnahme_Massn_Ziel_ID] [int] NULL,
	[Massnahme_Zielgruppe_ID] [int] NULL,
	[Massnahme_Anzahl_Plaetze_geplant] [smallint] NULL,
	[Massnahme_Anzahl_Plaetze_aktuell] [smallint] NULL,
	[Massnahme_Anzahl_Teilnehmer_geplant] [smallint] NULL,
	[Massnahme_Anzahl_Teilnehmer_aktuell] [smallint] NULL,
	[Massnahme_Verweildauer_Tage] [smallint] NULL,
	[Massnahme_Verweildauer_Wochen] [smallint] NULL,
	[Massnahme_Verweildauer_Monate] [smallint] NULL,
	[Massnahme_Monitoring] [bit] NOT NULL,
	[Massnahme_Jahresmeldung] [nvarchar](4) NULL,
	[Massnahme_Monitoring_Importdatum] [datetime] NULL,
	[Massnahme_Abschluss_gemeldet] [bit] NOT NULL,
	[Massnahme_Monitoring_abgeschlossen] [bit] NOT NULL,
	[Massnahme_Erfasser] [nvarchar](50) NULL,
	[Massnahme_Erfassungsdatum] [datetime] NULL,
	[Massnahme_Geaendert_von] [nvarchar](50) NULL,
	[Massnahme_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Massnahmen] PRIMARY KEY CLUSTERED 
(
	[Massnahme_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Massnahmen_Ausbildungsberufe]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Massnahmen_Ausbildungsberufe](
	[Massn_Ausbild_Massnahme_ID] [int] NOT NULL,
	[Massn_Ausbild_Ausbildungsberuf] [nvarchar](100) NOT NULL,
	[Massn_Ausbild_Erfasser] [nvarchar](50) NULL,
	[Massn_Ausbild_Erfassungsdatum] [datetime] NULL,
	[Massn_Ausbild_Geaendert_von] [nvarchar](50) NULL,
	[Massn_Ausbild_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Massnahmen_Ausbildungsberufe] PRIMARY KEY CLUSTERED 
(
	[Massn_Ausbild_Massnahme_ID] ASC,
	[Massn_Ausbild_Ausbildungsberuf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Massnahmen_Projekttraeger]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Massnahmen_Projekttraeger](
	[Massn_Projekttr_Massnahme_ID] [int] NOT NULL,
	[Massn_Projekttr_Projekttraeger_ID] [int] NOT NULL,
	[Massn_Projekttr_Erfasser] [nvarchar](50) NULL,
	[Massn_Projekttr_Erfassungsdatum] [datetime] NULL,
	[Massn_Projekttr_Geaendert_von] [nvarchar](50) NULL,
	[Massn_Projekttr_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Massnahmen_Projekttraeger] PRIMARY KEY CLUSTERED 
(
	[Massn_Projekttr_Massnahme_ID] ASC,
	[Massn_Projekttr_Projekttraeger_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Massnahmenziele]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Massnahmenziele](
	[Massn_Ziel_ID] [int] IDENTITY(1,1) NOT NULL,
	[Massn_Ziel_Bezeichnung] [nvarchar](50) NULL,
	[Massn_Ziel_Erfasser] [nvarchar](50) NULL,
	[Massn_Ziel_Erfassungsdatum] [datetime] NULL,
	[Massn_Ziel_Geaendert_von] [nvarchar](50) NULL,
	[Massn_Ziel_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Massnahmenziele] PRIMARY KEY CLUSTERED 
(
	[Massn_Ziel_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Nachweise]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Nachweise](
	[Nachweis_ID] [int] IDENTITY(1,1) NOT NULL,
	[Nachweis_Bezeichnung] [nvarchar](100) NULL,
	[Nachweis_Erfasser] [nvarchar](50) NULL,
	[Nachweis_Erfassungsdatum] [datetime] NULL,
	[Nachweis_Geaendert_von] [nvarchar](50) NULL,
	[Nachweis_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Nachweise] PRIMARY KEY CLUSTERED 
(
	[Nachweis_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Projekttraeger]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Projekttraeger](
	[Projekttraeger_ID] [int] IDENTITY(1,1) NOT NULL,
	[Projekttraeger_Name] [nvarchar](100) NULL,
	[Projekttraeger_Strasse] [nvarchar](50) NULL,
	[Projekttraeger_Plz] [nvarchar](5) NULL,
	[Projekttraeger_Ort] [nvarchar](40) NULL,
	[Projekttraeger_Erfasser] [nvarchar](50) NULL,
	[Projekttraeger_Erfassungsdatum] [datetime] NULL,
	[Projekttraeger_Geaendert_von] [nvarchar](50) NULL,
	[Projekttraeger_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Projekttraeger] PRIMARY KEY CLUSTERED 
(
	[Projekttraeger_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Regierungsbezirke]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Regierungsbezirke](
	[Regierungsbezirk_ID] [int] IDENTITY(1,1) NOT NULL,
	[Regierungsbezirk_Bezeichnung] [nvarchar](50) NULL,
	[Regierungsbezirk_Kuerzel] [nvarchar](2) NULL,
	[Regierungsbezirk_Erfasser] [nvarchar](50) NULL,
	[Regierungsbezirk_Erfassungsdatum] [datetime] NULL,
	[Regierungsbezirk_Geaendert_von] [nvarchar](50) NULL,
	[Regierungsbezirk_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Regierungsbezirke] PRIMARY KEY CLUSTERED 
(
	[Regierungsbezirk_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Sachbearbeiter]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Sachbearbeiter](
	[Sachb_ID] [int] IDENTITY(1,1) NOT NULL,
	[Sachb_Anrede] [nvarchar](4) NULL,
	[Sachb_Vorname] [nvarchar](30) NULL,
	[Sachb_Nachname] [nvarchar](50) NULL,
	[Sachb_Telefon] [nvarchar](25) NULL,
	[Sachb_Fax] [nvarchar](25) NULL,
	[Sachb_E_Mail] [nvarchar](100) NULL,
	[Sachb_Hausadresse_ID] [int] NULL,
	[Sachb_UserID] [nvarchar](20) NULL,
	[Sachb_Erfasser] [nvarchar](50) NULL,
	[Sachb_Erfassungsdatum] [datetime] NULL,
	[Sachb_Geaendert_von] [nvarchar](50) NULL,
	[Sachb_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Sachbearbeiter] PRIMARY KEY CLUSTERED 
(
	[Sachb_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Schreiben]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Schreiben](
	[Schreiben_ID] [int] IDENTITY(1,1) NOT NULL,
	[Schreiben_Bezeichnung] [nvarchar](100) NULL,
	[Schreiben_Dateiname] [nvarchar](100) NULL,
	[Schreiben_Abfrage] [nvarchar](50) NULL,
	[Schreiben_Kategorie] [nvarchar](1) NULL,
	[Schreiben_Erfasser] [nvarchar](50) NULL,
	[Schreiben_Erfassungsdatum] [datetime] NULL,
	[Schreiben_Geaendert_von] [nvarchar](50) NULL,
	[Schreiben_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Schreiben] PRIMARY KEY CLUSTERED 
(
	[Schreiben_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Schulbesuch]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Schulbesuch](
	[Schulbesuch_ID] [int] IDENTITY(1,1) NOT NULL,
	[Schulbesuch_Text] [nvarchar](100) NULL,
	[Schulbesuch_Erfasser] [nvarchar](50) NULL,
	[Schulbesuch_Erfassungsdatum] [datetime] NULL,
	[Schulbesuch_Geaendert_von] [nvarchar](50) NULL,
	[Schulbesuch_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Schulbesuch] PRIMARY KEY CLUSTERED 
(
	[Schulbesuch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Staatsangehoerigkeiten]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Staatsangehoerigkeiten](
	[Staatsangeh_Schluessel] [nvarchar](3) NOT NULL,
	[Staatsangeh_Suchbegriff] [nvarchar](50) NULL,
	[Staatsangeh_Bezeichnung] [nvarchar](50) NULL,
	[Staatsangeh_Erfasser] [nvarchar](50) NULL,
	[Staatsangeh_Erfassungsdatum] [datetime] NULL,
	[Staatsangeh_Geaendert_von] [nvarchar](50) NULL,
	[Staatsangeh_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Staatsangehoerigkeiten] PRIMARY KEY CLUSTERED 
(
	[Staatsangeh_Schluessel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Teilnehmer_Import]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Teilnehmer_Import](
	[Teiln_Massnahme_ID] [int] NOT NULL,
	[Teiln_Teilnehmer_ID] [nvarchar](50) NOT NULL,
	[Teiln_Geschlecht] [nvarchar](1) NULL,
	[Teiln_Geburtsdatum] [datetime] NULL,
	[Teiln_Staatsangeh_Schluessel] [nvarchar](3) NULL,
	[Teiln_Wohnort_Kreiskennzeichen] [nvarchar](5) NULL,
	[Teiln_Migrationshintergrund] [nvarchar](4) NULL,
	[Teiln_Schwerbehinderung] [nvarchar](4) NULL,
	[Teiln_Bildungsstand_ID] [int] NULL,
	[Teiln_Schulbesuch_ID] [int] NULL,
	[Teiln_Arbeitslosmeld_ID] [int] NULL,
	[Teiln_Erwerbstaetigkeit_ID] [int] NULL,
	[Teiln_Leistungsbezug_SGB_ID] [int] NULL,
	[Teiln_Haushaltssituation_ID] [int] NULL,
	[Teiln_Eintrittsdatum] [datetime] NULL,
	[Teiln_Austrittsdatum] [datetime] NULL,
	[Teiln_Austrittsgrund_ID] [int] NULL,
	[Teiln_Verbleib_ID] [int] NULL,
	[Teiln_Pruefung_bestanden] [nvarchar](4) NULL,
	[Teiln_Letzte_Jahresmeldung] [nvarchar](4) NULL,
	[Teiln_Jahresmeldung_erfolgt] [nvarchar](4) NULL,
 CONSTRAINT [PK_T_Teilnehmer_Import] PRIMARY KEY CLUSTERED 
(
	[Teiln_Massnahme_ID] ASC,
	[Teiln_Teilnehmer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Teilnehmer_Import_Protokoll]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Teilnehmer_Import_Protokoll](
	[Prot_Massnahme_ID] [int] NOT NULL,
	[Prot_Anzahl_vor_Import] [int] NULL,
	[Prot_Anzahl_nach_Import] [int] NULL,
 CONSTRAINT [PK_T_Teilnehmer_Import_Protokoll] PRIMARY KEY CLUSTERED 
(
	[Prot_Massnahme_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Teilnehmer_Monitoring]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Teilnehmer_Monitoring](
	[Teiln_Massnahme_ID] [int] NOT NULL,
	[Teiln_Projekttraeger] [nvarchar](150) NULL,
	[Teiln_Projekttraeger_ID] [int] NULL,
	[Teiln_Teilnehmer_ID] [nvarchar](50) NOT NULL,
	[Teiln_Wohnort_Kreiskennzeichen] [nvarchar](5) NULL,
	[Teiln_Geschlecht] [nvarchar](1) NULL,
	[Teiln_Geburtsdatum] [datetime] NULL,
	[Teiln_Staatsangeh_Schluessel] [nvarchar](3) NULL,
	[Teiln_Migrationshintergrund] [bit] NOT NULL,
	[Teiln_Schwerbehinderung] [bit] NOT NULL,
	[Teiln_Eintrittsdatum] [datetime] NULL,
	[Teiln_Bildungsstand_ID] [int] NULL,
	[Teiln_Schulbesuch_ID] [int] NULL,
	[Teiln_Arbeitslosmeld_ID] [int] NULL,
	[Teiln_Erwerbstaetigkeit_ID] [int] NULL,
	[Teiln_Leistungsbezug_SGB_ID] [int] NULL,
	[Teiln_Haushaltssituation_ID] [int] NULL,
	[Teiln_Austrittsdatum] [datetime] NULL,
	[Teiln_Verbleib_ID] [int] NULL,
	[Teiln_Austrittsgrund_ID] [int] NULL,
	[Teiln_Pruefung_bestanden] [bit] NOT NULL,
	[Teiln_Erfasser] [nvarchar](50) NULL,
	[Teiln_Erfassungsdatum] [datetime] NULL,
	[Teiln_Geaendert_von] [nvarchar](50) NULL,
	[Teiln_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Teilnehmer_Monitoring] PRIMARY KEY CLUSTERED 
(
	[Teiln_Massnahme_ID] ASC,
	[Teiln_Teilnehmer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Verbleib]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Verbleib](
	[Verbleib_ID] [int] IDENTITY(1,1) NOT NULL,
	[Verbleib_Text] [nvarchar](200) NULL,
	[Verbleib_Massnahmeart_1] [bit] NOT NULL,
	[Verbleib_Massnahmeart_2] [bit] NOT NULL,
	[Verbleib_Massnahmeart_3] [bit] NOT NULL,
	[Verbleib_Massnahmeart_4] [bit] NOT NULL,
	[Verbleib_Erfasser] [nvarchar](50) NULL,
	[Verbleib_Erfassungsdatum] [datetime] NULL,
	[Verbleib_Geaendert_von] [nvarchar](50) NULL,
	[Verbleib_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Verbleib] PRIMARY KEY CLUSTERED 
(
	[Verbleib_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Verwaltungsgerichte]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Verwaltungsgerichte](
	[Verwaltungsgericht_ID] [int] IDENTITY(1,1) NOT NULL,
	[Verwaltungsgericht] [nvarchar](30) NULL,
	[Verwaltungsgericht_Plz] [nvarchar](5) NULL,
	[Verwaltungsgericht_Strasse] [nvarchar](30) NULL,
	[Verwaltungsgericht_Erfasser] [nvarchar](50) NULL,
	[Verwaltungsgericht_Erfassungsdatum] [datetime] NULL,
	[Verwaltungsgericht_Geaendert_von] [nvarchar](50) NULL,
	[Verwaltungsgericht_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Verwaltungsgerichte] PRIMARY KEY CLUSTERED 
(
	[Verwaltungsgericht_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Wohnorte]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Wohnorte](
	[Wohnort_ID] [int] IDENTITY(1,1) NOT NULL,
	[Wohnort_Bezeichnung] [nvarchar](50) NULL,
	[Wohnort_Kreiskennzeichen] [nvarchar](5) NULL,
	[Wohnort_Erfasser] [nvarchar](50) NULL,
	[Wohnort_Erfassungsdatum] [datetime] NULL,
	[Wohnort_Geaendert_von] [nvarchar](50) NULL,
	[Wohnort_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Wohnorte] PRIMARY KEY CLUSTERED 
(
	[Wohnort_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Wohnort_Kreiskennzeichen] UNIQUE NONCLUSTERED 
(
	[Wohnort_Kreiskennzeichen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Zeitpunkte]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Zeitpunkte](
	[Zeitpunkt_ID] [int] IDENTITY(1,1) NOT NULL,
	[Zeitpunkt_Bezeichnung] [nvarchar](50) NULL,
	[Zeitpunkt_Erfasser] [nvarchar](50) NULL,
	[Zeitpunkt_Erfassungsdatum] [datetime] NULL,
	[Zeitpunkt_Geaendert_von] [nvarchar](50) NULL,
	[Zeitpunkt_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Zeitpunkte] PRIMARY KEY CLUSTERED 
(
	[Zeitpunkt_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Zielgruppen]    Script Date: 11.09.2024 10:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Zielgruppen](
	[Zielgruppe_ID] [int] IDENTITY(1,1) NOT NULL,
	[Zielgruppe_Bezeichnung] [nvarchar](100) NULL,
	[Zielgruppe_Erfasser] [nvarchar](50) NULL,
	[Zielgruppe_Erfassungsdatum] [datetime] NULL,
	[Zielgruppe_Geaendert_von] [nvarchar](50) NULL,
	[Zielgruppe_Aenderungsdatum] [datetime] NULL,
 CONSTRAINT [PK_T_Zielgruppen] PRIMARY KEY CLUSTERED 
(
	[Zielgruppe_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[T_Ansprechpartner] ADD  CONSTRAINT [DF_T_Ansprechpartner_Ansprechp_Anschreiben]  DEFAULT ((0)) FOR [Ansprechp_Anschreiben]
GO
ALTER TABLE [dbo].[T_Ansprechpartner] ADD  CONSTRAINT [DF_T_Ansprechpartner_Ansprechp_Hauptanspr]  DEFAULT ((0)) FOR [Ansprechp_Hauptanspr]
GO
ALTER TABLE [dbo].[T_Antraege] ADD  CONSTRAINT [DF_T_Antraege_Antrag_Abgeschlossen]  DEFAULT ((0)) FOR [Antrag_Abgeschlossen]
GO
ALTER TABLE [dbo].[T_Antraege_Detail] ADD  CONSTRAINT [DF_T_Antraege_Detail_Antrag_Detail_Bestandskraft]  DEFAULT ((0)) FOR [Antrag_Detail_Bestandskraft]
GO
ALTER TABLE [dbo].[T_Antraege_Detail] ADD  CONSTRAINT [DF_T_Antraege_Detail_Antrag_Detail_Massnahmeart_1]  DEFAULT ((0)) FOR [Antrag_Detail_Massnahmeart_1]
GO
ALTER TABLE [dbo].[T_Antraege_Detail] ADD  CONSTRAINT [DF_T_Antraege_Detail_Antrag_Detail_Massnahmeart_2]  DEFAULT ((0)) FOR [Antrag_Detail_Massnahmeart_2]
GO
ALTER TABLE [dbo].[T_Antraege_Detail] ADD  CONSTRAINT [DF_T_Antraege_Detail_Antrag_Detail_Massnahmeart_3]  DEFAULT ((0)) FOR [Antrag_Detail_Massnahmeart_3]
GO
ALTER TABLE [dbo].[T_Antraege_Detail] ADD  CONSTRAINT [DF_T_Antraege_Detail_Antrag_Detail_Massnahmeart_4]  DEFAULT ((0)) FOR [Antrag_Detail_Massnahmeart_4]
GO
ALTER TABLE [dbo].[T_Antraege_Detail] ADD  CONSTRAINT [DF_T_Antraege_Detail_Antrag_Detail_Massnahmeart_5]  DEFAULT ((0)) FOR [Antrag_Detail_Massnahmeart_5]
GO
ALTER TABLE [dbo].[T_Antraege_Nachweise] ADD  CONSTRAINT [DF_T_Antraege_Nachweise_Antrag_Nachweis_korrekt]  DEFAULT ((0)) FOR [Antrag_Nachweis_korrekt]
GO
ALTER TABLE [dbo].[T_Antraege_Nachweise] ADD  CONSTRAINT [DF_T_Antraege_Nachweise_Antrag_Nachweis_unzureichend]  DEFAULT ((0)) FOR [Antrag_Nachweis_unzureichend]
GO
ALTER TABLE [dbo].[T_Auswertungen] ADD  CONSTRAINT [DF_T_Auswertungen_Auswertung_Kontext]  DEFAULT ((0)) FOR [Auswertung_Kontext]
GO
ALTER TABLE [dbo].[T_Auswertungen] ADD  CONSTRAINT [DF_T_Auswertungen_Auswertung_Kuerzel]  DEFAULT ((0)) FOR [Auswertung_Kuerzel]
GO
ALTER TABLE [dbo].[T_Auswertungen] ADD  CONSTRAINT [DF_T_Auswertungen_Auswertung_Jahr]  DEFAULT ((0)) FOR [Auswertung_Antrag_Jahr]
GO
ALTER TABLE [dbo].[T_Auswertungen] ADD  CONSTRAINT [DF_T_Auswertungen_Auswertung_Jahr_1]  DEFAULT ((0)) FOR [Auswertung_Jahr]
GO
ALTER TABLE [dbo].[T_Haushalt_Auszahlungen] ADD  CONSTRAINT [DF_T_Haushalt_Auszahlungen_Haushalt_Auszahl_Storno]  DEFAULT ((0)) FOR [Haushalt_Auszahl_Storno]
GO
ALTER TABLE [dbo].[T_Massnahmen] ADD  CONSTRAINT [DF_T_Massnahmen_Massnahme_Digitales_Lernen]  DEFAULT ((0)) FOR [Massnahme_Digitales_Lernen]
GO
ALTER TABLE [dbo].[T_Massnahmen] ADD  CONSTRAINT [DF_T_Massnahmen_Massnahme_Mittel_Vergabe]  DEFAULT ((0)) FOR [Massnahme_Mittel_Vergabe]
GO
ALTER TABLE [dbo].[T_Massnahmen] ADD  CONSTRAINT [DF_T_Massnahmen_Massnahme_Mittel_Zuwendung]  DEFAULT ((0)) FOR [Massnahme_Mittel_Zuwendung]
GO
ALTER TABLE [dbo].[T_Massnahmen] ADD  CONSTRAINT [DF_T_Massnahmen_Massnahme_Monitoring]  DEFAULT ((0)) FOR [Massnahme_Monitoring]
GO
ALTER TABLE [dbo].[T_Massnahmen] ADD  CONSTRAINT [DF_T_Massnahmen_Massnahme_Abschluss_gemeldet]  DEFAULT ((0)) FOR [Massnahme_Abschluss_gemeldet]
GO
ALTER TABLE [dbo].[T_Massnahmen] ADD  CONSTRAINT [DF_T_Massnahmen_Massnahme_Monitoring_abgeschlossen]  DEFAULT ((0)) FOR [Massnahme_Monitoring_abgeschlossen]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] ADD  CONSTRAINT [DF_T_Teilnehmer_Monitoring_Teiln_Migrationshintergrund]  DEFAULT ((0)) FOR [Teiln_Migrationshintergrund]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] ADD  CONSTRAINT [DF_T_Teilnehmer_Monitoring_Teiln_Schwerbehinderung]  DEFAULT ((0)) FOR [Teiln_Schwerbehinderung]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] ADD  CONSTRAINT [DF_T_Teilnehmer_Monitoring_Teiln_Pruefung_bestanden]  DEFAULT ((0)) FOR [Teiln_Pruefung_bestanden]
GO
ALTER TABLE [dbo].[T_Verbleib] ADD  CONSTRAINT [DF_T_Verbleib_Verbleib_Massnahmeart_1]  DEFAULT ((0)) FOR [Verbleib_Massnahmeart_1]
GO
ALTER TABLE [dbo].[T_Verbleib] ADD  CONSTRAINT [DF_T_Verbleib_Verbleib_Massnahmeart_2]  DEFAULT ((0)) FOR [Verbleib_Massnahmeart_2]
GO
ALTER TABLE [dbo].[T_Verbleib] ADD  CONSTRAINT [DF_T_Verbleib_Verbleib_Massnahmeart_3]  DEFAULT ((0)) FOR [Verbleib_Massnahmeart_3]
GO
ALTER TABLE [dbo].[T_Verbleib] ADD  CONSTRAINT [DF_T_Verbleib_Verbleib_Massnahmeart_4]  DEFAULT ((0)) FOR [Verbleib_Massnahmeart_4]
GO
ALTER TABLE [dbo].[T_Ansprechpartner]  WITH CHECK ADD  CONSTRAINT [FK_T_Ansprechpartner_T_Antragsteller] FOREIGN KEY([Ansprechp_Antragsteller_ID])
REFERENCES [dbo].[T_Antragsteller] ([Antragsteller_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Ansprechpartner] CHECK CONSTRAINT [FK_T_Ansprechpartner_T_Antragsteller]
GO
ALTER TABLE [dbo].[T_Antraege]  WITH CHECK ADD  CONSTRAINT [FK_T_Antraege_T_Antragsteller] FOREIGN KEY([Antrag_Antragsteller_ID])
REFERENCES [dbo].[T_Antragsteller] ([Antragsteller_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Antraege] CHECK CONSTRAINT [FK_T_Antraege_T_Antragsteller]
GO
ALTER TABLE [dbo].[T_Antraege]  WITH CHECK ADD  CONSTRAINT [FK_T_Antraege_T_Sachbearbeiter] FOREIGN KEY([Antrag_Sachb_ID])
REFERENCES [dbo].[T_Sachbearbeiter] ([Sachb_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Antraege] CHECK CONSTRAINT [FK_T_Antraege_T_Sachbearbeiter]
GO
ALTER TABLE [dbo].[T_Antraege_Detail]  WITH CHECK ADD  CONSTRAINT [FK_T_Antraege_Detail_T_Antraege] FOREIGN KEY([Antrag_Detail_Antrag_ID])
REFERENCES [dbo].[T_Antraege] ([Antrag_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Antraege_Detail] CHECK CONSTRAINT [FK_T_Antraege_Detail_T_Antraege]
GO
ALTER TABLE [dbo].[T_Antraege_Detail]  WITH CHECK ADD  CONSTRAINT [FK_T_Antraege_Detail_T_Sachbearbeiter] FOREIGN KEY([Antrag_Detail_Sachb_ID])
REFERENCES [dbo].[T_Sachbearbeiter] ([Sachb_ID])
GO
ALTER TABLE [dbo].[T_Antraege_Detail] CHECK CONSTRAINT [FK_T_Antraege_Detail_T_Sachbearbeiter]
GO
ALTER TABLE [dbo].[T_Antraege_Nachweise]  WITH CHECK ADD  CONSTRAINT [FK_T_Antraege_Nachweise_T_Antraege] FOREIGN KEY([Antrag_Nachweis_Antrag_ID])
REFERENCES [dbo].[T_Antraege] ([Antrag_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Antraege_Nachweise] CHECK CONSTRAINT [FK_T_Antraege_Nachweise_T_Antraege]
GO
ALTER TABLE [dbo].[T_Antraege_Nachweise]  WITH CHECK ADD  CONSTRAINT [FK_T_Antraege_Nachweise_T_Nachweise] FOREIGN KEY([Antrag_Nachweis_Nachweis_ID])
REFERENCES [dbo].[T_Nachweise] ([Nachweis_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Antraege_Nachweise] CHECK CONSTRAINT [FK_T_Antraege_Nachweise_T_Nachweise]
GO
ALTER TABLE [dbo].[T_Antragsteller]  WITH CHECK ADD  CONSTRAINT [FK_T_Antragsteller_T_Gebietskoerperschaften] FOREIGN KEY([Antragsteller_Kuerzel])
REFERENCES [dbo].[T_Gebietskoerperschaften] ([Gebietskoerp_Kuerzel])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Antragsteller] CHECK CONSTRAINT [FK_T_Antragsteller_T_Gebietskoerperschaften]
GO
ALTER TABLE [dbo].[T_Antragsteller]  WITH CHECK ADD  CONSTRAINT [FK_T_Antragsteller_T_Kontext] FOREIGN KEY([Antragsteller_Kontext])
REFERENCES [dbo].[T_Kontext] ([Kontext])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Antragsteller] CHECK CONSTRAINT [FK_T_Antragsteller_T_Kontext]
GO
ALTER TABLE [dbo].[T_Antragsteller]  WITH CHECK ADD  CONSTRAINT [FK_T_Antragsteller_T_Landkreise] FOREIGN KEY([Antragsteller_Landkreis_ID])
REFERENCES [dbo].[T_Landkreise] ([Landkreis_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Antragsteller] CHECK CONSTRAINT [FK_T_Antragsteller_T_Landkreise]
GO
ALTER TABLE [dbo].[T_Auswertungen]  WITH CHECK ADD  CONSTRAINT [FK_T_Auswertungen_T_Auswertungskategorien] FOREIGN KEY([Auswertung_Kategorie_ID])
REFERENCES [dbo].[T_Auswertungskategorien] ([Ausw_Kategorie_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Auswertungen] CHECK CONSTRAINT [FK_T_Auswertungen_T_Auswertungskategorien]
GO
ALTER TABLE [dbo].[T_Gebietskoerperschaften]  WITH CHECK ADD  CONSTRAINT [FK_T_Gebietskoerperschaften_T_Regierungsbezirke] FOREIGN KEY([Gebietskoerp_Regierungsbezirk_ID])
REFERENCES [dbo].[T_Regierungsbezirke] ([Regierungsbezirk_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Gebietskoerperschaften] CHECK CONSTRAINT [FK_T_Gebietskoerperschaften_T_Regierungsbezirke]
GO
ALTER TABLE [dbo].[T_Gebietskoerperschaften]  WITH CHECK ADD  CONSTRAINT [FK_T_Gebietskoerperschaften_T_Verwaltungsgerichte] FOREIGN KEY([Gebietskoerp_Verwaltungsgericht_ID])
REFERENCES [dbo].[T_Verwaltungsgerichte] ([Verwaltungsgericht_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Gebietskoerperschaften] CHECK CONSTRAINT [FK_T_Gebietskoerperschaften_T_Verwaltungsgerichte]
GO
ALTER TABLE [dbo].[T_Haushalt_Auszahlungen]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Auszahlungen_T_Antraege] FOREIGN KEY([Haushalt_Auszahl_Antrag_ID])
REFERENCES [dbo].[T_Antraege] ([Antrag_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Auszahlungen] CHECK CONSTRAINT [FK_T_Haushalt_Auszahlungen_T_Antraege]
GO
ALTER TABLE [dbo].[T_Haushalt_Finanzierungsplan]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Finanzierungsplan_T_Massnahmen] FOREIGN KEY([Haushalt_Finanz_Plan_Massnahme_ID])
REFERENCES [dbo].[T_Massnahmen] ([Massnahme_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Finanzierungsplan] CHECK CONSTRAINT [FK_T_Haushalt_Finanzierungsplan_T_Massnahmen]
GO
ALTER TABLE [dbo].[T_Haushalt_Kofinanzierung]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Kofinanzierung_T_Foerdermittel] FOREIGN KEY([Haushalt_Kofinanz_Foerdermittel_ID])
REFERENCES [dbo].[T_Foerdermittel] ([Foerdermittel_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Kofinanzierung] CHECK CONSTRAINT [FK_T_Haushalt_Kofinanzierung_T_Foerdermittel]
GO
ALTER TABLE [dbo].[T_Haushalt_Kofinanzierung]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Kofinanzierung_T_Massnahmen] FOREIGN KEY([Haushalt_Kofinanz_Massnahme_ID])
REFERENCES [dbo].[T_Massnahmen] ([Massnahme_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Kofinanzierung] CHECK CONSTRAINT [FK_T_Haushalt_Kofinanzierung_T_Massnahmen]
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_T_Antraege] FOREIGN KEY([Haushalt_Verteil_Antrag_ID])
REFERENCES [dbo].[T_Antraege] ([Antrag_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel] CHECK CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_T_Antraege]
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_T_Haushalt_Verteilung_Landesmittel_Stand] FOREIGN KEY([Haushalt_Verteil_Antrag_ID], [Haushalt_Verteil_Zeitpunkt_ID])
REFERENCES [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand] ([Haushalt_Stand_Antrag_ID], [Haushalt_Stand_Zeitpunkt_ID])
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel] CHECK CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_T_Haushalt_Verteilung_Landesmittel_Stand]
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_T_Zeitpunkte] FOREIGN KEY([Haushalt_Verteil_Zeitpunkt_ID])
REFERENCES [dbo].[T_Zeitpunkte] ([Zeitpunkt_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel] CHECK CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_T_Zeitpunkte]
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_Stand_T_Antraege] FOREIGN KEY([Haushalt_Stand_Antrag_ID])
REFERENCES [dbo].[T_Antraege] ([Antrag_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand] CHECK CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_Stand_T_Antraege]
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand]  WITH CHECK ADD  CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_Stand_T_Zeitpunkte] FOREIGN KEY([Haushalt_Stand_Zeitpunkt_ID])
REFERENCES [dbo].[T_Zeitpunkte] ([Zeitpunkt_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Haushalt_Verteilung_Landesmittel_Stand] CHECK CONSTRAINT [FK_T_Haushalt_Verteilung_Landesmittel_Stand_T_Zeitpunkte]
GO
ALTER TABLE [dbo].[T_Massnahmen]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_T_Antraege_Detail] FOREIGN KEY([Massnahme_Antrag_Detail_Antrag_ID], [Massnahme_Antrag_Detail_lfd_Nr])
REFERENCES [dbo].[T_Antraege_Detail] ([Antrag_Detail_Antrag_ID], [Antrag_Detail_lfd_Nr])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen] CHECK CONSTRAINT [FK_T_Massnahmen_T_Antraege_Detail]
GO
ALTER TABLE [dbo].[T_Massnahmen]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_T_Massnahmearten] FOREIGN KEY([Massnahme_Massnahmeart_ID])
REFERENCES [dbo].[T_Massnahmearten] ([Massnahmeart_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen] CHECK CONSTRAINT [FK_T_Massnahmen_T_Massnahmearten]
GO
ALTER TABLE [dbo].[T_Massnahmen]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_T_Massnahmenziele] FOREIGN KEY([Massnahme_Massn_Ziel_ID])
REFERENCES [dbo].[T_Massnahmenziele] ([Massn_Ziel_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen] CHECK CONSTRAINT [FK_T_Massnahmen_T_Massnahmenziele]
GO
ALTER TABLE [dbo].[T_Massnahmen]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_T_Zielgruppen] FOREIGN KEY([Massnahme_Zielgruppe_ID])
REFERENCES [dbo].[T_Zielgruppen] ([Zielgruppe_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen] CHECK CONSTRAINT [FK_T_Massnahmen_T_Zielgruppen]
GO
ALTER TABLE [dbo].[T_Massnahmen_Ausbildungsberufe]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_Ausbildungsberufe_T_Massnahmen] FOREIGN KEY([Massn_Ausbild_Massnahme_ID])
REFERENCES [dbo].[T_Massnahmen] ([Massnahme_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen_Ausbildungsberufe] CHECK CONSTRAINT [FK_T_Massnahmen_Ausbildungsberufe_T_Massnahmen]
GO
ALTER TABLE [dbo].[T_Massnahmen_Projekttraeger]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_Projekttraeger_T_Massnahmen] FOREIGN KEY([Massn_Projekttr_Massnahme_ID])
REFERENCES [dbo].[T_Massnahmen] ([Massnahme_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen_Projekttraeger] CHECK CONSTRAINT [FK_T_Massnahmen_Projekttraeger_T_Massnahmen]
GO
ALTER TABLE [dbo].[T_Massnahmen_Projekttraeger]  WITH CHECK ADD  CONSTRAINT [FK_T_Massnahmen_Projekttraeger_T_Projekttraeger] FOREIGN KEY([Massn_Projekttr_Projekttraeger_ID])
REFERENCES [dbo].[T_Projekttraeger] ([Projekttraeger_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Massnahmen_Projekttraeger] CHECK CONSTRAINT [FK_T_Massnahmen_Projekttraeger_T_Projekttraeger]
GO
ALTER TABLE [dbo].[T_Sachbearbeiter]  WITH CHECK ADD  CONSTRAINT [FK_T_Sachbearbeiter_T_Hausadressen] FOREIGN KEY([Sachb_Hausadresse_ID])
REFERENCES [dbo].[T_Hausadressen] ([Hausadresse_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Sachbearbeiter] CHECK CONSTRAINT [FK_T_Sachbearbeiter_T_Hausadressen]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Arbeitslosmeldung] FOREIGN KEY([Teiln_Arbeitslosmeld_ID])
REFERENCES [dbo].[T_Arbeitslosmeldung] ([Arbeitslosmeld_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Arbeitslosmeldung]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Austrittsgruende] FOREIGN KEY([Teiln_Austrittsgrund_ID])
REFERENCES [dbo].[T_Austrittsgruende] ([Austrittsgrund_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Austrittsgruende]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Bildungsstand] FOREIGN KEY([Teiln_Bildungsstand_ID])
REFERENCES [dbo].[T_Bildungsstand] ([Bildungsstand_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Bildungsstand]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Erwerbstaetigkeit] FOREIGN KEY([Teiln_Erwerbstaetigkeit_ID])
REFERENCES [dbo].[T_Erwerbstaetigkeit] ([Erwerbstaetigkeit_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Erwerbstaetigkeit]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Haushaltssituation] FOREIGN KEY([Teiln_Haushaltssituation_ID])
REFERENCES [dbo].[T_Haushaltssituation] ([Haushaltssituation_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Haushaltssituation]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Leistungsbezug_SGB] FOREIGN KEY([Teiln_Leistungsbezug_SGB_ID])
REFERENCES [dbo].[T_Leistungsbezug_SGB] ([Leistungsbezug_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Leistungsbezug_SGB]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Massnahmen] FOREIGN KEY([Teiln_Massnahme_ID])
REFERENCES [dbo].[T_Massnahmen] ([Massnahme_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Massnahmen]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Schulbesuch] FOREIGN KEY([Teiln_Schulbesuch_ID])
REFERENCES [dbo].[T_Schulbesuch] ([Schulbesuch_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Schulbesuch]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Staatsangehoerigkeiten] FOREIGN KEY([Teiln_Staatsangeh_Schluessel])
REFERENCES [dbo].[T_Staatsangehoerigkeiten] ([Staatsangeh_Schluessel])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Staatsangehoerigkeiten]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Verbleib] FOREIGN KEY([Teiln_Verbleib_ID])
REFERENCES [dbo].[T_Verbleib] ([Verbleib_ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Verbleib]
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring]  WITH CHECK ADD  CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Wohnorte] FOREIGN KEY([Teiln_Wohnort_Kreiskennzeichen])
REFERENCES [dbo].[T_Wohnorte] ([Wohnort_Kreiskennzeichen])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[T_Teilnehmer_Monitoring] CHECK CONSTRAINT [FK_T_Teilnehmer_Monitoring_T_Wohnorte]
GO

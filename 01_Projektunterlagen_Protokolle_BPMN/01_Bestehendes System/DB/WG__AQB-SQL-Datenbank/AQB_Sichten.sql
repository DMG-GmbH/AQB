USE [AQB]
GO
/****** Object:  View [dbo].[S_Alle_Antraege_Massnahmearten]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Alle_Antraege_Massnahmearten]
AS
SELECT        dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID, dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr, dbo.T_Antraege.Antrag_Jahr, dbo.T_Massnahmearten.Massnahmeart_ID
FROM            dbo.T_Massnahmearten CROSS JOIN
                         dbo.T_Antraege INNER JOIN
                         dbo.T_Antraege_Detail ON dbo.T_Antraege.Antrag_ID = dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID
GO
/****** Object:  View [dbo].[S_Haushalt_Finanzierungsplan_Massnahmen_UA]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Finanzierungsplan_Massnahmen_UA]
AS
SELECT S_Alle_Antraege_Massnahmearten.Antrag_Detail_Antrag_ID, S_Alle_Antraege_Massnahmearten.Antrag_Detail_lfd_Nr, 
S_Alle_Antraege_Massnahmearten.Massnahmeart_ID, T_Massnahmen.Massnahme_Massnahmeart_ID, 
Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr],[Haushalt_Finanz_Plan_Betrag],Null)) AS HH_Betrag, 
Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+1,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE1_Betrag, 
Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+2,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE2_Betrag, 
Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+3,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE3_Betrag, 
Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+4,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE4_Betrag
FROM (S_Alle_Antraege_Massnahmearten LEFT JOIN T_Massnahmen ON 
(S_Alle_Antraege_Massnahmearten.Antrag_Detail_lfd_Nr = T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr) AND 
(S_Alle_Antraege_Massnahmearten.Antrag_Detail_Antrag_ID = T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID) AND 
(S_Alle_Antraege_Massnahmearten.Massnahmeart_ID = T_Massnahmen.Massnahme_Massnahmeart_ID)) LEFT JOIN 
T_Haushalt_Finanzierungsplan ON T_Massnahmen.Massnahme_ID = T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID
GROUP BY S_Alle_Antraege_Massnahmearten.Antrag_Detail_Antrag_ID, 
S_Alle_Antraege_Massnahmearten.Antrag_Detail_lfd_Nr, 
S_Alle_Antraege_Massnahmearten.Massnahmeart_ID, T_Massnahmen.Massnahme_Massnahmeart_ID;
GO
/****** Object:  View [dbo].[S_Haushalt_Finanzierungsplan_Massnahmen]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Finanzierungsplan_Massnahmen]
AS
SELECT        TOP (100) PERCENT dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr, 
                         dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Massnahmeart_ID, 
                         dbo.T_Massnahmearten.Massnahmeart_Bezeichnung, SUM(dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Betrag) AS Kofinanz_Betrag, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.HH_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE1_Betrag, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE2_Betrag, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE3_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE4_Betrag
FROM            dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA LEFT OUTER JOIN
                         dbo.T_Massnahmen ON dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr AND 
                         dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID AND 
                         dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Massnahmeart_ID = dbo.T_Massnahmen.Massnahme_Massnahmeart_ID LEFT OUTER JOIN
                         dbo.T_Massnahmearten ON dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Massnahmeart_ID = dbo.T_Massnahmearten.Massnahmeart_ID LEFT OUTER JOIN
                         dbo.T_Haushalt_Kofinanzierung ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Massnahme_ID
GROUP BY dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr, dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, 
                         dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.Massnahmeart_ID, dbo.T_Massnahmearten.Massnahmeart_Bezeichnung, 
                         dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.HH_Betrag, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE1_Betrag, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE2_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE3_Betrag, dbo.S_Haushalt_Finanzierungsplan_Massnahmen_UA.VE4_Betrag
GO
/****** Object:  View [dbo].[S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA]
AS
SELECT T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr],[Haushalt_Finanz_Plan_Betrag],Null)) AS HH_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr],[Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge],Null)) AS HH_Betrag_Sprachfoerd_Fluechtl, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr],[Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge],Null)) AS HH_Betrag_Qualifizierung_Fluechtl, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+1,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE1_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+1,[Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge],Null)) AS VE1_Betrag_Sprachfoerd_Fluechtl, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+1,[Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge],Null)) AS VE1_Betrag_Qualifizierung_Fluechtl, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+2,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE2_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+3,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE3_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+4,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE4_Betrag
FROM (T_Antraege INNER JOIN T_Massnahmen ON T_Antraege.Antrag_ID = T_Massnahmen.[Massnahme_Antrag_Detail_Antrag_ID]) INNER JOIN T_Haushalt_Finanzierungsplan ON T_Massnahmen.Massnahme_ID = T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID
GROUP BY T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID;

GO
/****** Object:  View [dbo].[S_Haushalt_Finanzierungsplan_Einzelmassnahmen]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Finanzierungsplan_Einzelmassnahmen]
AS
SELECT        dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Massnahmeart_ID, 
                         dbo.T_Massnahmen.Massnahme_Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung, SUM(dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Betrag) AS Kofinanz_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Sprachfoerd_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag, 
                         CAST(ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, 0) + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl, 0) 
                         + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl, 0) + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, 0) 
                         + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Sprachfoerd_Fluechtl, 0) + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl, 0) 
                         + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, 0) + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, 0) 
                         + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag, 0) AS Money) AS Massnahme_Foerdersumme
FROM            dbo.T_Massnahmearten RIGHT OUTER JOIN
                         dbo.T_Antraege_Detail INNER JOIN
                         dbo.T_Massnahmen LEFT OUTER JOIN
                         dbo.T_Haushalt_Kofinanzierung ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Massnahme_ID LEFT OUTER JOIN
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA ON dbo.T_Massnahmen.Massnahme_ID = dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.Haushalt_Finanz_Plan_Massnahme_ID ON 
                         dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr AND dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID ON 
                         dbo.T_Massnahmearten.Massnahmeart_ID = dbo.T_Massnahmen.Massnahme_Massnahmeart_ID
GROUP BY dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Massnahmeart_ID, 
                         dbo.T_Massnahmen.Massnahme_Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Sprachfoerd_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag
GO
/****** Object:  View [dbo].[S_Haushalt_Finanzierung_UA]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Finanzierung_UA]
AS
SELECT S_Alle_Antraege_Massnahmearten.Antrag_Detail_Antrag_ID, S_Alle_Antraege_Massnahmearten.Antrag_Detail_lfd_Nr, S_Alle_Antraege_Massnahmearten.Massnahmeart_ID, T_Massnahmen.Massnahme_Massnahmeart_ID, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr],[Haushalt_Finanz_Plan_Betrag],Null)) AS HH_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+1,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE1_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+2,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE2_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+3,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE3_Betrag, Sum(IIf([Haushalt_Finanz_Plan_Jahr]=[Antrag_Jahr]+4,[Haushalt_Finanz_Plan_Betrag],Null)) AS VE4_Betrag
FROM (S_Alle_Antraege_Massnahmearten LEFT JOIN T_Massnahmen ON (S_Alle_Antraege_Massnahmearten.Antrag_Detail_lfd_Nr = T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr) AND (S_Alle_Antraege_Massnahmearten.Antrag_Detail_Antrag_ID = T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID) AND (S_Alle_Antraege_Massnahmearten.Massnahmeart_ID = T_Massnahmen.Massnahme_Massnahmeart_ID)) LEFT JOIN T_Haushalt_Finanzierungsplan ON T_Massnahmen.Massnahme_ID = T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID
GROUP BY S_Alle_Antraege_Massnahmearten.Antrag_Detail_Antrag_ID, S_Alle_Antraege_Massnahmearten.Antrag_Detail_lfd_Nr, S_Alle_Antraege_Massnahmearten.Massnahmeart_ID, T_Massnahmen.Massnahme_Massnahmeart_ID;
GO
/****** Object:  View [dbo].[S_Verteilung_Landesmittel_letzter_Stand]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Verteilung_Landesmittel_letzter_Stand]
AS
SELECT        Haushalt_Verteil_Antrag_ID, MAX(Haushalt_Verteil_Zeitpunkt_ID) AS Letzter_Zeitpunkt_ID
FROM            dbo.T_Haushalt_Verteilung_Landesmittel
GROUP BY Haushalt_Verteil_Antrag_ID
GO
/****** Object:  View [dbo].[S_Haushalt_Verteilung_Landesmittel_Antrag]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Verteilung_Landesmittel_Antrag]
AS
SELECT T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID, Max(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr],[Haushalt_Verteil_Foerdermittelart] + [Haushalt_Verteil_Jahr],'')) AS Rate_1_Bezeichnung, Max(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+1,[Haushalt_Verteil_Foerdermittelart] + [Haushalt_Verteil_Jahr],'')) AS Rate_2_Bezeichnung, Max(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+2,[Haushalt_Verteil_Foerdermittelart] + [Haushalt_Verteil_Jahr],'')) AS Rate_3_Bezeichnung, Max(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+3,[Haushalt_Verteil_Foerdermittelart] + [Haushalt_Verteil_Jahr],'')) AS Rate_4_Bezeichnung, Max(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+4,[Haushalt_Verteil_Foerdermittelart] + [Haushalt_Verteil_Jahr],'')) AS Rate_5_Bezeichnung, Sum(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr],IsNull([Haushalt_Verteil_Allgemeine_Mittel],0)+IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert],0),Null)) AS Rate_1_Betrag, Sum(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+1,IsNull([Haushalt_Verteil_Allgemeine_Mittel],0)+IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert],0),Null)) AS Rate_2_Betrag, Sum(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+2,IsNull([Haushalt_Verteil_Allgemeine_Mittel],0)+IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert],0),Null)) AS Rate_3_Betrag, Sum(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+3,IsNull([Haushalt_Verteil_Allgemeine_Mittel],0)+IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert],0),Null)) AS Rate_4_Betrag, Sum(IIf([Haushalt_Verteil_Jahr]=[Antrag_Jahr]+4,IsNull([Haushalt_Verteil_Allgemeine_Mittel],0)+IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge],0)+IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert],0),Null)) AS Rate_5_Betrag
FROM (T_Haushalt_Verteilung_Landesmittel INNER JOIN T_Antraege ON T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID = T_Antraege.Antrag_ID) INNER JOIN S_Verteilung_Landesmittel_letzter_Stand ON (T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Zeitpunkt_ID = S_Verteilung_Landesmittel_letzter_Stand.Letzter_Zeitpunkt_ID) AND (T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID = S_Verteilung_Landesmittel_letzter_Stand.Haushalt_Verteil_Antrag_ID)
GROUP BY T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID;    
GO
/****** Object:  View [dbo].[S_Liste_Massnahmen]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Liste_Massnahmen]
AS
SELECT        T_Antragsteller.Antragsteller_ID, T_Antragsteller.Antragsteller_Kuerzel, T_Antragsteller.Antragsteller_Name, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Plz, T_Antragsteller.Antragsteller_Ort, 
                         LTrim(RTrim(IsNull([Antragsteller_Plz],'') + ' ' + IsNull([Antragsteller_Ort],''))) AS Antragsteller_Plz_Ort, [Antragsteller_Name] + IIf([Antragsteller_Ort] > '', ', ' + [Antragsteller_Ort], '') AS Antragsteller, 
                         T_Regierungsbezirke.Regierungsbezirk_Bezeichnung, T_Antraege.Antrag_ID, T_Antraege.Antrag_Jahr, T_Antraege.Antrag_Sachb_ID, T_Antraege.Antrag_Wiedervorlage_Datum, T_Antraege.Antrag_Abgeschlossen, 
                         T_Antraege_Detail.Antrag_Detail_Antragsdatum, T_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum, T_Antraege_Detail.Antrag_Detail_Aenderungsbescheid_Datum, 
                         IIf([Antrag_Detail_Aenderungsbescheid_Datum] > '', [Antrag_Detail_Aenderungsbescheid_Datum], [Antrag_Detail_Zuwendungsbescheid_Datum]) AS Antrag_Detail_Bescheid_Datum, T_Sachbearbeiter.Sachb_Nachname, 
                         T_Sachbearbeiter.Sachb_Vorname, IIf([Antrag_Sachb_ID] > 0, LTrim(RTrim(IsNull([Sachb_Nachname],'') + ', ' + IsNull([Sachb_Vorname],''))), '') AS Sachb_Name, T_Antraege.Antrag_Durchfuehrungszeitraum_Beginn, 
                         T_Antraege.Antrag_Durchfuehrungszeitraum_Ende, T_Antraege_Detail.Antrag_Detail_Massnahmeart_1, T_Antraege_Detail.Antrag_Detail_Massnahmeart_2, T_Antraege_Detail.Antrag_Detail_Massnahmeart_3, 
                         T_Antraege_Detail.Antrag_Detail_Massnahmeart_4, T_Massnahmen.Massnahme_ID, T_Massnahmen.Massnahme_Massnahmeart_ID, T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, 
                         T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, T_Massnahmen.Massnahme_Aktenzeichen, T_Massnahmen.Massnahme_Bezeichnung, T_Massnahmen.Massnahme_Beginn, T_Massnahmen.Massnahme_Ende, 
                         dbo.F_Projekttraeger([T_Massnahmen].[Massnahme_ID], ' | ') AS Massnahme_Projekttraeger, T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant, T_Massnahmen.Massnahme_Anzahl_Teilnehmer_aktuell, 
                         T_Massnahmen.Massnahme_Monitoring, S_Haushalt_Finanzierungsplan_Einzelmassnahmen.Massnahme_Foerdersumme
FROM            (T_Regierungsbezirke RIGHT JOIN
                         T_Gebietskoerperschaften ON T_Regierungsbezirke.Regierungsbezirk_ID = T_Gebietskoerperschaften.Gebietskoerp_Regierungsbezirk_ID) RIGHT JOIN
                         ((T_Sachbearbeiter RIGHT JOIN
                         (T_Antragsteller INNER JOIN
                         T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) ON T_Sachbearbeiter.Sachb_ID = T_Antraege.Antrag_Sachb_ID) INNER JOIN
                         (T_Antraege_Detail INNER JOIN
                         (T_Massnahmen LEFT JOIN
                         S_Haushalt_Finanzierungsplan_Einzelmassnahmen ON T_Massnahmen.Massnahme_ID = S_Haushalt_Finanzierungsplan_Einzelmassnahmen.Massnahme_ID) ON 
                         (T_Antraege_Detail.Antrag_Detail_lfd_Nr = T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr) AND (T_Antraege_Detail.Antrag_Detail_Antrag_ID = T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID)) ON 
                         T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID) ON T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel;
GO
/****** Object:  View [dbo].[S_Auswertung_Landesmittel_UA]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Landesmittel_UA]
AS
SELECT        T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, T_Antraege.Antrag_Jahr, T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Jahr, 
                         IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr], [Haushalt_Finanz_Plan_Betrag], NULL) AS HH_Betrag, IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr], [Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge], NULL) 
                         AS HH_Betrag_Sprachfoerd_Fluechtlinge, IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr], [Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge], NULL) AS HH_Betrag_Qualifizierung_Fluechtlinge, 
                         IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr] + 1, [Haushalt_Finanz_Plan_Betrag], NULL) AS VE1_Betrag, IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr] + 1, [Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge], NULL) 
                         AS VE1_Betrag_Sprachfoerd_Fluechtlinge, IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr] + 1, [Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge], NULL) AS VE1_Betrag_Qualifizierung_Fluechtlinge, 
                         IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr] + 2, [Haushalt_Finanz_Plan_Betrag], NULL) AS VE2_Betrag, IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr] + 3, [Haushalt_Finanz_Plan_Betrag], NULL) AS VE3_Betrag, 
                         IIf([Haushalt_Finanz_Plan_Jahr] = [Antrag_Jahr] + 4, [Haushalt_Finanz_Plan_Betrag], NULL) AS VE4_Betrag
FROM            T_Antraege INNER JOIN
                         ((T_Antraege_Detail INNER JOIN
                         T_Massnahmen ON (T_Antraege_Detail.Antrag_Detail_lfd_Nr = T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr) AND (T_Antraege_Detail.Antrag_Detail_Antrag_ID = T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID)) 
                         LEFT JOIN
                         T_Haushalt_Finanzierungsplan ON T_Massnahmen.Massnahme_ID = T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID) ON T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID;
GO
/****** Object:  View [dbo].[S_Auswertung_Landesmittel]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Landesmittel]
AS
SELECT        Massnahme_Antrag_Detail_Antrag_ID, Massnahme_Antrag_Detail_lfd_Nr, Antrag_Jahr, SUM(HH_Betrag) AS HH_Betrag, SUM(HH_Betrag_Sprachfoerd_Fluechtlinge) AS HH_Betrag_Sprachfoerd_Fluechtlinge, 
                         SUM(HH_Betrag_Qualifizierung_Fluechtlinge) AS HH_Betrag_Qualifizierung_Fluechtlinge, SUM(VE1_Betrag) AS VE1_Betrag, SUM(VE1_Betrag_Sprachfoerd_Fluechtlinge) AS VE1_Betrag_Sprachfoerd_Fluechtlinge, 
                         SUM(VE1_Betrag_Qualifizierung_Fluechtlinge) AS VE1_Betrag_Qualifizierung_Fluechtlinge, SUM(VE2_Betrag) AS VE2_Betrag, SUM(VE3_Betrag) AS VE3_Betrag, SUM(VE4_Betrag) AS VE4_Betrag
FROM            dbo.S_Auswertung_Landesmittel_UA
GROUP BY Massnahme_Antrag_Detail_Antrag_ID, Massnahme_Antrag_Detail_lfd_Nr, Antrag_Jahr
GO
/****** Object:  View [dbo].[S_Auswertung_Verteilung_Landesmittel]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Verteilung_Landesmittel]
AS
SELECT        T_Antraege.Antrag_ID, T_Antraege.Antrag_Antragsteller_ID, T_Antraege.Antrag_Jahr, T_Antraege.Antrag_Jahr AS HH_Jahr, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr], IsNull([Haushalt_Verteil_Allgemeine_Mittel], 0) 
                         + IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge], 0) + IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge], 0) + IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert], 0), NULL)) AS HH_Verteil_Betrag, 
                         Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr], [Haushalt_Verteil_Allgemeine_Mittel], NULL)) AS HH_Verteil_Allgemeine_Mittel, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr], 
                         [Haushalt_Verteil_Sprachfoerd_Fluechtlinge], NULL)) AS HH_Verteil_Sprachfoerd_Fluechtlinge, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr], [Haushalt_Verteil_Qualifizierung_Fluechtlinge], NULL)) 
                         AS HH_Verteil_Qualifizierung_Fluechtlinge, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr], [Haushalt_Verteil_Sozialwirtschaft_integriert], NULL)) AS HH_Verteil_Sozialwirtschaft_integriert, [Antrag_Jahr] + 1 AS VE1_Jahr, 
                         Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 1, IsNull([Haushalt_Verteil_Allgemeine_Mittel], 0) + IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge], 0) + IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge], 0) 
                         + IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert], 0), NULL)) AS VE1_Verteil_Betrag, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 1, [Haushalt_Verteil_Allgemeine_Mittel], NULL)) AS VE1_Verteil_Allgemeine_Mittel, 
                         Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 1, [Haushalt_Verteil_Sprachfoerd_Fluechtlinge], NULL)) AS VE1_Verteil_Sprachfoerd_Fluechtlinge, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 1, 
                         [Haushalt_Verteil_Qualifizierung_Fluechtlinge], NULL)) AS VE1_Verteil_Qualifizierung_Fluechtlinge, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 1, [Haushalt_Verteil_Sozialwirtschaft_integriert], NULL)) 
                         AS VE1_Verteil_Sozialwirtschaft_integriert, [Antrag_Jahr] + 2 AS VE2_Jahr, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 2, IsNull([Haushalt_Verteil_Allgemeine_Mittel], 0) + IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge], 
                         0) + IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge], 0) + IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert], 0), NULL)) AS VE2_Verteil_Betrag, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 2, 
                         [Haushalt_Verteil_Allgemeine_Mittel], NULL)) AS VE2_Verteil_Allgemeine_Mittel, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 2, [Haushalt_Verteil_Sozialwirtschaft_integriert], NULL)) 
                         AS VE2_Verteil_Sozialwirtschaft_integriert, [Antrag_Jahr] + 3 AS VE3_Jahr, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 3, IsNull([Haushalt_Verteil_Allgemeine_Mittel], 0) + IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge], 
                         0) + IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge], 0) + IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert], 0), NULL)) AS VE3_Verteil_Betrag, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 3, 
                         [Haushalt_Verteil_Allgemeine_Mittel], NULL)) AS VE3_Verteil_Allgemeine_Mittel, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 3, [Haushalt_Verteil_Sozialwirtschaft_integriert], NULL)) 
                         AS VE3_Verteil_Sozialwirtschaft_integriert, [Antrag_Jahr] + 4 AS VE4_Jahr, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 4, IsNull([Haushalt_Verteil_Allgemeine_Mittel], 0) + IsNull([Haushalt_Verteil_Sprachfoerd_Fluechtlinge], 
                         0) + IsNull([Haushalt_Verteil_Qualifizierung_Fluechtlinge], 0) + IsNull([Haushalt_Verteil_Sozialwirtschaft_integriert], 0), NULL)) AS VE4_Verteil_Betrag, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 4, 
                         [Haushalt_Verteil_Allgemeine_Mittel], NULL)) AS VE4_Verteil_Allgemeine_Mittel, Sum(IIf([Haushalt_Verteil_Jahr] = [Antrag_Jahr] + 4, [Haushalt_Verteil_Sozialwirtschaft_integriert], NULL)) 
                         AS VE4_Verteil_Sozialwirtschaft_integriert
FROM            (T_Antraege INNER JOIN
                         T_Haushalt_Verteilung_Landesmittel ON T_Antraege.Antrag_ID = T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID) INNER JOIN
                         S_Verteilung_Landesmittel_letzter_Stand ON (T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID = S_Verteilung_Landesmittel_letzter_Stand.Haushalt_Verteil_Antrag_ID) AND 
                         (T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Zeitpunkt_ID = S_Verteilung_Landesmittel_letzter_Stand.Letzter_Zeitpunkt_ID)
GROUP BY T_Antraege.Antrag_ID, T_Antraege.Antrag_Antragsteller_ID, T_Antraege.Antrag_Jahr, [Antrag_Jahr] + 1, [Antrag_Jahr] + 2, [Antrag_Jahr] + 3, [Antrag_Jahr] + 4, T_Antraege.Antrag_Jahr;
GO
/****** Object:  View [dbo].[S_Auswertung_Verteilung_Landesmittel_Gesamt]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Verteilung_Landesmittel_Gesamt]
AS
SELECT        dbo.T_Antraege.Antrag_ID, SUM(ISNULL(dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Allgemeine_Mittel, 0) + ISNULL(dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Sprachfoerd_Fluechtlinge, 0) 
                         + ISNULL(dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Qualifizierung_Fluechtlinge, 0) + ISNULL(dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Sozialwirtschaft_integriert, 0)) 
                         AS Haushalt_Verteil_Betrag
FROM            dbo.T_Antraege INNER JOIN
                         dbo.T_Haushalt_Verteilung_Landesmittel ON dbo.T_Antraege.Antrag_ID = dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID INNER JOIN
                         dbo.S_Verteilung_Landesmittel_letzter_Stand ON dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Zeitpunkt_ID = dbo.S_Verteilung_Landesmittel_letzter_Stand.Letzter_Zeitpunkt_ID AND 
                         dbo.T_Haushalt_Verteilung_Landesmittel.Haushalt_Verteil_Antrag_ID = dbo.S_Verteilung_Landesmittel_letzter_Stand.Haushalt_Verteil_Antrag_ID
GROUP BY dbo.T_Antraege.Antrag_ID
GO
/****** Object:  View [dbo].[S_Auswertung_Auszahlungen_Gesamt]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Auszahlungen_Gesamt]
AS
SELECT        Haushalt_Auszahl_Antrag_ID, SUM(Haushalt_Auszahl_Betrag) AS Haushalt_Auszahl_Betrag
FROM            dbo.T_Haushalt_Auszahlungen
WHERE        (Haushalt_Auszahl_Storno = 0) AND (Haushalt_Auszahl_Auszahlungsdatum > '')
GROUP BY Haushalt_Auszahl_Antrag_ID
GO
/****** Object:  View [dbo].[S_Auszahlungen_Kontierungsbeleg_Anlage]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auszahlungen_Kontierungsbeleg_Anlage]
AS
SELECT        TOP (100) PERCENT dbo.T_Antraege.Antrag_ID, 'AQB' + RIGHT(dbo.T_Antraege.Antrag_Jahr, 2) + '-' + dbo.T_Antragsteller.Antragsteller_Kuerzel AS AZ, 
                         dbo.S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Betrag AS Gesamtfoerderbetrag, dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Betrag, dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Auszahlungsdatum, 
                         dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Jahr, dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Rate
FROM            dbo.T_Antragsteller INNER JOIN
                         dbo.T_Antraege ON dbo.T_Antragsteller.Antragsteller_ID = dbo.T_Antraege.Antrag_Antragsteller_ID INNER JOIN
                         dbo.T_Haushalt_Auszahlungen INNER JOIN
                         dbo.S_Auswertung_Auszahlungen_Gesamt ON dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Antrag_ID = dbo.S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Antrag_ID ON 
                         dbo.T_Antraege.Antrag_ID = dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Antrag_ID
WHERE        (dbo.T_Haushalt_Auszahlungen.Haushalt_Auszahl_Storno = 0)
GO
/****** Object:  View [dbo].[S_Hauptansprechpartner_UA]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Hauptansprechpartner_UA]
AS
SELECT DISTINCT TOP (100) PERCENT Ansprechp_Antragsteller_ID, Ansprechp_Hauptanspr, Ansprechp_ID
FROM            dbo.T_Ansprechpartner
GO
/****** Object:  View [dbo].[S_Hauptansprechpartner]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Hauptansprechpartner]
AS
SELECT DISTINCT Ansprechp_Antragsteller_ID, MIN(Ansprechp_ID) AS Ansprechp_ID
FROM            dbo.S_Hauptansprechpartner_UA
GROUP BY Ansprechp_Antragsteller_ID
GO
/****** Object:  View [dbo].[S_Antraege_Detail]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Antraege_Detail]
AS
SELECT T_Antragsteller.Antragsteller_Kuerzel, [Antragsteller_Kuerzel] + ' - ' + [Antragsteller_Name] + IIf([Antragsteller_Ort]>'',', ' + [Antragsteller_Ort],'') AS Antragsteller, T_Antraege.*, T_Antraege_Detail.*, 'HH' + CAST([Antrag_Jahr] AS Char(4)) AS Antrag_Jahr_HH, 'HH' + CAST([Antrag_Jahr] AS Char(4)) + ' Sprache Flüchtl.' AS Antrag_Jahr_HH_Sprachfoerd_Fluechtl, 'HH' + CAST([Antrag_Jahr] AS Char(4)) + ' Qualifiz. Flüchtl.' AS Antrag_Jahr_HH_Qualifizierung_Fluechtl, 'VE' + 
CAST([Antrag_Jahr]+1 AS Char(4)) AS Antrag_Jahr_VE1, 'VE' + CAST([Antrag_Jahr]+1 AS Char(4)) + ' Sprache Flüchtl.' AS Antrag_Jahr_VE1_Sprachfoerd_Fluechtl, 
'VE' + CAST([Antrag_Jahr]+1 AS Char(4)) + ' Qualifiz. Flüchtl.' AS Antrag_Jahr_VE1_Qualifizierung_Fluechtl, 
'VE' + CAST([Antrag_Jahr]+2 AS Char(4)) AS Antrag_Jahr_VE2, 'VE' + CAST([Antrag_Jahr]+3 AS Char(4)) AS Antrag_Jahr_VE3, 
'VE' + CAST([Antrag_Jahr]+4 AS Char(4)) AS Antrag_Jahr_VE4
FROM (T_Antragsteller INNER JOIN T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) LEFT JOIN T_Antraege_Detail ON T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID;    
GO
/****** Object:  View [dbo].[S_Anzahl_Plaetze_Teilnehmer]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Anzahl_Plaetze_Teilnehmer]
AS
SELECT        Massnahme_Antrag_Detail_Antrag_ID, Massnahme_Antrag_Detail_lfd_Nr, Massnahme_Massnahmeart_ID, SUM(Massnahme_Anzahl_Plaetze_geplant) AS Anzahl_Plaetze_geplant, SUM(Massnahme_Anzahl_Plaetze_aktuell) 
                         AS Anzahl_Plaetze_aktuell, SUM(Massnahme_Anzahl_Teilnehmer_geplant) AS Anzahl_Teilnehmer_geplant, SUM(Massnahme_Anzahl_Teilnehmer_aktuell) AS Anzahl_Teilnehmer_aktuell
FROM            dbo.T_Massnahmen
GROUP BY Massnahme_Antrag_Detail_Antrag_ID, Massnahme_Antrag_Detail_lfd_Nr, Massnahme_Massnahmeart_ID
GO
/****** Object:  View [dbo].[S_Checkliste]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Checkliste]
AS
SELECT S_Antraege_Detail.Antragsteller_Kuerzel AS Kuerzel, T_Gebietskoerperschaften.Gebietskoerp_Bezeichnung AS Zuwendungsempfaenger, S_Hauptansprechpartner.Ansprechp_ID, 
T_Ansprechpartner.Ansprechp_Nachname, T_Ansprechpartner.Ansprechp_Vorname, T_Ansprechpartner.Ansprechp_Titel, 
LTrim(RTrim([Ansprechp_Nachname] + IIf([Ansprechp_Titel]>'' Or [Ansprechp_Vorname]>'',', ','') + IIf([Ansprechp_Titel]>'',[Ansprechp_Titel] + ' ','') + 
IIf([Ansprechp_Vorname]>'',[Ansprechp_Vorname],''))) AS Ansprechp_Name, 
T_Ansprechpartner.Ansprechp_Telefon, T_Ansprechpartner.Ansprechp_E_Mail, S_Antraege_Detail.Antrag_Jahr, S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID, 
S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr, S_Antraege_Detail.Antrag_Durchfuehrungszeitraum_Beginn AS Beginn, 
S_Antraege_Detail.Antrag_Durchfuehrungszeitraum_Ende AS Ende, S_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum AS Zuwendungsbescheid, 
Right([Antrag_Jahr_HH],4) AS Jahr_HH, Right([Antrag_Jahr_VE1],4) AS Jahr_VE1, Right([Antrag_Jahr_VE2],4) AS Jahr_VE2, Right([Antrag_Jahr_VE3],4) AS Jahr_VE3, 
Right([Antrag_Jahr_VE4],4) AS Jahr_VE4, Format(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[HH_Betrag]),'#,##0.00') AS HH_Betrag, 
Format(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE1_Betrag]),'#,##0.00') AS VE1_Betrag, 
Format(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE2_Betrag]),'#,##0.00') AS VE2_Betrag, 
Format(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE3_Betrag]),'#,##0.00') AS VE3_Betrag, 
Format(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE4_Betrag]),'#,##0.00') AS VE4_Betrag, 
Format(IsNull(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[HH_Betrag]),0)+
IsNull(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE1_Betrag]),0)+
IsNull(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE2_Betrag]),0)+
IsNull(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE3_Betrag]),0)+
IsNull(Sum([S_Haushalt_Finanzierungsplan_Massnahmen_UA].[VE4_Betrag]),0),'#,##0.00') AS Gesamtbetrag, 
Format(Sum(IIf([Massnahmeart_ID]=1,[Anzahl_Plaetze_geplant],0)),' #,###') AS Plaetze_geplant_M1, 
Format(Sum(IIf([Massnahmeart_ID]=2,[Anzahl_Plaetze_geplant],0)),' #,###') AS Plaetze_geplant_M2, 
Format(Sum(IIf([Massnahmeart_ID]=3,[Anzahl_Plaetze_geplant],0)),' #,###') AS Plaetze_geplant_M3, 
Format(Sum(IIf([Massnahmeart_ID]=4,[Anzahl_Plaetze_geplant],0)),' #,###') AS Plaetze_geplant_M4, 
Format(Sum(IIf([Massnahmeart_ID]=5,[Anzahl_Plaetze_geplant],0)),' #,###') AS Plaetze_geplant_M5, 
Format(Sum(IIf([Massnahmeart_ID]=1,[Anzahl_Plaetze_aktuell],0)),' #,###') AS Plaetze_aktuell_M1, 
Format(Sum(IIf([Massnahmeart_ID]=2,[Anzahl_Plaetze_aktuell],0)),' #,###') AS Plaetze_aktuell_M2, 
Format(Sum(IIf([Massnahmeart_ID]=3,[Anzahl_Plaetze_aktuell],0)),' #,###') AS Plaetze_aktuell_M3, 
Format(Sum(IIf([Massnahmeart_ID]=4,[Anzahl_Plaetze_aktuell],0)),' #,###') AS Plaetze_aktuell_M4, 
Format(Sum(IIf([Massnahmeart_ID]=5,[Anzahl_Plaetze_aktuell],0)),' #,###') AS Plaetze_aktuell_M5, 
Format(Sum(IIf([Massnahmeart_ID]=1,[Anzahl_Teilnehmer_geplant],0)),' #,###') AS Teilnehm_geplant_M1, 
Format(Sum(IIf([Massnahmeart_ID]=2,[Anzahl_Teilnehmer_geplant],0)),' #,###') AS Teilnehm_geplant_M2, 
Format(Sum(IIf([Massnahmeart_ID]=3,[Anzahl_Teilnehmer_geplant],0)),' #,###') AS Teilnehm_geplant_M3, 
Format(Sum(IIf([Massnahmeart_ID]=4,[Anzahl_Teilnehmer_geplant],0)),' #,###') AS Teilnehm_geplant_M4, 
Format(Sum(IIf([Massnahmeart_ID]=5,[Anzahl_Teilnehmer_geplant],0)),' #,###') AS Teilnehm_geplant_M5, 
Format(Sum(IIf([Massnahmeart_ID]=1,[Anzahl_Teilnehmer_aktuell],0)),' #,###') AS Teilnehm_aktuell_M1, 
Format(Sum(IIf([Massnahmeart_ID]=2,[Anzahl_Teilnehmer_aktuell],0)),' #,###') AS Teilnehm_aktuell_M2, 
Format(Sum(IIf([Massnahmeart_ID]=3,[Anzahl_Teilnehmer_aktuell],0)),' #,###') AS Teilnehm_aktuell_M3, 
Format(Sum(IIf([Massnahmeart_ID]=4,[Anzahl_Teilnehmer_aktuell],0)),' #,###') AS Teilnehm_aktuell_M4, 
Format(Sum(IIf([Massnahmeart_ID]=5,[Anzahl_Teilnehmer_aktuell],0)),' #,###') AS Teilnehm_aktuell_M5
FROM ((((S_Antraege_Detail LEFT JOIN T_Gebietskoerperschaften ON S_Antraege_Detail.Antragsteller_Kuerzel = T_Gebietskoerperschaften.Gebietskoerp_Kuerzel) 
LEFT JOIN S_Haushalt_Finanzierungsplan_Massnahmen_UA ON (S_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID) 
AND (S_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr)) 
LEFT JOIN S_Anzahl_Plaetze_Teilnehmer ON (S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr = 
S_Anzahl_Plaetze_Teilnehmer.Massnahme_Antrag_Detail_lfd_Nr) AND (S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID = 
S_Anzahl_Plaetze_Teilnehmer.Massnahme_Antrag_Detail_Antrag_ID) AND (S_Haushalt_Finanzierungsplan_Massnahmen_UA.Massnahmeart_ID = 
S_Anzahl_Plaetze_Teilnehmer.Massnahme_Massnahmeart_ID)) LEFT JOIN S_Hauptansprechpartner ON 
S_Antraege_Detail.Antrag_Antragsteller_ID = S_Hauptansprechpartner.Ansprechp_Antragsteller_ID) 
LEFT JOIN T_Ansprechpartner ON S_Hauptansprechpartner.[Ansprechp_ID] = T_Ansprechpartner.Ansprechp_ID
GROUP BY S_Antraege_Detail.Antragsteller_Kuerzel, T_Gebietskoerperschaften.Gebietskoerp_Bezeichnung, S_Hauptansprechpartner.Ansprechp_ID, 
T_Ansprechpartner.Ansprechp_Nachname, T_Ansprechpartner.Ansprechp_Vorname, T_Ansprechpartner.Ansprechp_Titel, 
LTrim(RTrim([Ansprechp_Nachname] + IIf([Ansprechp_Titel]>'' Or [Ansprechp_Vorname]>'',', ','') + IIf([Ansprechp_Titel]>'',[Ansprechp_Titel] + ' ','') + 
IIf([Ansprechp_Vorname]>'',[Ansprechp_Vorname],''))), T_Ansprechpartner.Ansprechp_Telefon, 
T_Ansprechpartner.Ansprechp_E_Mail, S_Antraege_Detail.Antrag_Jahr, S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_Antrag_ID, 
S_Haushalt_Finanzierungsplan_Massnahmen_UA.Antrag_Detail_lfd_Nr, S_Antraege_Detail.Antrag_Durchfuehrungszeitraum_Beginn, 
S_Antraege_Detail.Antrag_Durchfuehrungszeitraum_Ende, S_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum, 
Right([Antrag_Jahr_HH],4), Right([Antrag_Jahr_VE1],4), Right([Antrag_Jahr_VE2],4), Right([Antrag_Jahr_VE3],4), Right([Antrag_Jahr_VE4],4);


GO
/****** Object:  View [dbo].[S_Excel_Finanzierungsplan]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Excel_Finanzierungsplan]
AS
SELECT        dbo.T_Antragsteller.Antragsteller_Kuerzel + '-' + dbo.T_Antraege.Antrag_Jahr AS Gruppe, dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Massnahmen.Massnahme_Aktenzeichen, 
                         dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.F_Projekttraeger(dbo.T_Massnahmen.Massnahme_ID, '; ') AS Projekttraeger, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag, 
                         CAST(ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, 0) + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, 0) 
                         + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, 0) + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, 0) 
                         + ISNULL(dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag, 0) AS MONEY) AS Landesmittel, SUM(dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Betrag) AS Kofinanz_Betrag
FROM            dbo.T_Massnahmearten RIGHT OUTER JOIN
                         dbo.T_Antragsteller INNER JOIN
                         dbo.T_Antraege ON dbo.T_Antragsteller.Antragsteller_ID = dbo.T_Antraege.Antrag_Antragsteller_ID INNER JOIN
                         dbo.T_Antraege_Detail INNER JOIN
                         dbo.T_Massnahmen LEFT OUTER JOIN
                         dbo.T_Haushalt_Kofinanzierung ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Massnahme_ID LEFT OUTER JOIN
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA ON dbo.T_Massnahmen.Massnahme_ID = dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.Haushalt_Finanz_Plan_Massnahme_ID ON 
                         dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr AND dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID ON 
                         dbo.T_Antraege.Antrag_ID = dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID ON dbo.T_Massnahmearten.Massnahmeart_ID = dbo.T_Massnahmen.Massnahme_Massnahmeart_ID
WHERE        (dbo.T_Antraege.Antrag_Abgeschlossen = 0)
GROUP BY dbo.T_Antragsteller.Antragsteller_Kuerzel + '-' + dbo.T_Antraege.Antrag_Jahr, dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Massnahmen.Massnahme_Aktenzeichen, 
                         dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.F_Projekttraeger(dbo.T_Massnahmen.Massnahme_ID, '; '), dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag
GO
/****** Object:  View [dbo].[S_Auswertung_Landesmittel_Gesamt]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Landesmittel_Gesamt]
AS
SELECT        TOP (100) PERCENT dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, SUM(dbo.T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Betrag) 
                         AS Haushalt_Finanz_Plan_Betrag
FROM            dbo.T_Massnahmen LEFT OUTER JOIN
                         dbo.T_Haushalt_Finanzierungsplan ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID
GROUP BY dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr
HAVING        (dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID IS NOT NULL)
GO
/****** Object:  View [dbo].[S_Excel_Kofinanzierung]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Excel_Kofinanzierung]
AS
SELECT        dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Foerdermittel.Foerdermittel_Bezeichnung, dbo.S_Auswertung_Landesmittel_Gesamt.Haushalt_Finanz_Plan_Betrag AS Landesmittel_Gesamt, 
                         dbo.S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Betrag AS Auszahlungen_Gesamt, SUM(dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Betrag) AS Haushalt_Kofinanz_Betrag
FROM            dbo.T_Antragsteller INNER JOIN
                         dbo.T_Antraege LEFT OUTER JOIN
                         dbo.S_Auswertung_Auszahlungen_Gesamt ON dbo.T_Antraege.Antrag_ID = dbo.S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Antrag_ID ON 
                         dbo.T_Antragsteller.Antragsteller_ID = dbo.T_Antraege.Antrag_Antragsteller_ID LEFT OUTER JOIN
                         dbo.T_Antraege_Detail LEFT OUTER JOIN
                         dbo.T_Massnahmen LEFT OUTER JOIN
                         dbo.S_Auswertung_Landesmittel_Gesamt ON dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID = dbo.S_Auswertung_Landesmittel_Gesamt.Massnahme_Antrag_Detail_Antrag_ID AND 
                         dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr = dbo.S_Auswertung_Landesmittel_Gesamt.Massnahme_Antrag_Detail_lfd_Nr ON 
                         dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr AND 
                         dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID LEFT OUTER JOIN
                         dbo.T_Foerdermittel RIGHT OUTER JOIN
                         dbo.T_Haushalt_Kofinanzierung ON dbo.T_Foerdermittel.Foerdermittel_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Foerdermittel_ID ON 
                         dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Massnahme_ID ON dbo.T_Antraege.Antrag_ID = dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID
WHERE        (dbo.T_Antraege.Antrag_Abgeschlossen = 0)
GROUP BY dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Foerdermittel.Foerdermittel_Bezeichnung, dbo.S_Auswertung_Landesmittel_Gesamt.Haushalt_Finanz_Plan_Betrag, 
                         dbo.S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Betrag
GO
/****** Object:  View [dbo].[S_Massnahmen_fuer_Zielvereinbarung]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Massnahmen_fuer_Zielvereinbarung]
AS
SELECT        dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Aktenzeichen AS Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung AS Bezeichnung, 
                         dbo.F_Projekttraeger(dbo.T_Massnahmen.Massnahme_ID, NCHAR(13) + NCHAR(10)) AS Projektträger, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag AS [HH-Betrag], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl AS [HH-Betrag Sprachförderung Flüchtlinge], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl AS [HH-Betrag Qualifizierung Flüchtlinge], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag AS [VE1-Betrag], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Sprachfoerd_Fluechtl AS [VE1-Betrag Sprachförderung Flüchtlinge], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl AS [VE1-Betrag Qualifizierung Flüchtlinge], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag AS [VE2-Betrag], dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag AS [VE3-Betrag], 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag AS [VE4-Betrag], SUM(dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Betrag) AS [Betrag Kofinanzierung], 
                         dbo.T_Massnahmen.Massnahme_Beginn AS [Beginn der Maßnahme], dbo.T_Massnahmen.Massnahme_Ende AS [Ende der Maßnahme], dbo.T_Massnahmen.Massnahme_Anzahl_Plaetze_geplant AS [Anzahl Plätze geplant], 
                         dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant AS [Anzahl Teilnehmer geplant], dbo.T_Massnahmenziele.Massn_Ziel_Bezeichnung AS Maßnahmenziel, 
                         dbo.T_Zielgruppen.Zielgruppe_Bezeichnung AS Zielgruppe, dbo.T_Massnahmen.Massnahme_Kurzbeschreibung AS Kurzbeschreibung, dbo.T_Antragsteller.Antragsteller_Kontext, dbo.T_Antragsteller.Antragsteller_Kuerzel, 
                         dbo.T_Antraege.Antrag_Jahr
FROM            dbo.T_Massnahmearten RIGHT OUTER JOIN
                         dbo.T_Antragsteller INNER JOIN
                         dbo.T_Antraege ON dbo.T_Antragsteller.Antragsteller_ID = dbo.T_Antraege.Antrag_Antragsteller_ID INNER JOIN
                         dbo.T_Antraege_Detail INNER JOIN
                         dbo.T_Massnahmenziele INNER JOIN
                         dbo.T_Zielgruppen INNER JOIN
                         dbo.T_Massnahmen LEFT OUTER JOIN
                         dbo.T_Haushalt_Kofinanzierung ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Massnahme_ID LEFT OUTER JOIN
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA ON dbo.T_Massnahmen.Massnahme_ID = dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.Haushalt_Finanz_Plan_Massnahme_ID ON 
                         dbo.T_Zielgruppen.Zielgruppe_ID = dbo.T_Massnahmen.Massnahme_Zielgruppe_ID ON dbo.T_Massnahmenziele.Massn_Ziel_ID = dbo.T_Massnahmen.Massnahme_Massn_Ziel_ID ON 
                         dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID AND dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr ON 
                         dbo.T_Antraege.Antrag_ID = dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID ON dbo.T_Massnahmearten.Massnahmeart_ID = dbo.T_Massnahmen.Massnahme_Massnahmeart_ID
GROUP BY dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.F_Projekttraeger(dbo.T_Massnahmen.Massnahme_ID, NCHAR(13) + NCHAR(10)), 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Sprachfoerd_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.HH_Betrag_Qualifizierung_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Sprachfoerd_Fluechtl, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE1_Betrag_Qualifizierung_Fluechtl, 
                         dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE2_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE3_Betrag, dbo.S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA.VE4_Betrag, 
                         dbo.T_Massnahmen.Massnahme_Beginn, dbo.T_Massnahmen.Massnahme_Ende, dbo.T_Massnahmen.Massnahme_Anzahl_Plaetze_geplant, dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant, 
                         dbo.T_Massnahmenziele.Massn_Ziel_Bezeichnung, dbo.T_Zielgruppen.Zielgruppe_Bezeichnung, dbo.T_Massnahmen.Massnahme_Kurzbeschreibung, dbo.T_Antragsteller.Antragsteller_Kontext, 
                         dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr
GO
/****** Object:  View [dbo].[S_Schreiben_Belege]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Schreiben_Belege]
AS
SELECT T_Antragsteller.Antragsteller_ID, T_Antraege_Detail.Antrag_Detail_Antrag_ID, T_Antraege_Detail.Antrag_Detail_lfd_Nr, 
T_Antragsteller.Antragsteller_Kuerzel, T_Gebietskoerperschaften.Gebietskoerp_Bezeichnung AS Antragsteller, T_Antragsteller.Antragsteller_Name, 
T_Antragsteller.Antragsteller_Anschreiben_Name_1 AS Antragsteller_Name1, T_Antragsteller.Antragsteller_Anschreiben_Name_2 AS Antragsteller_Name2, 
T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Plz, T_Antragsteller.Antragsteller_Ort, T_Antragsteller.Antragsteller_IBAN, 
T_Antragsteller.Antragsteller_BIC, T_Antragsteller.Antragsteller_Bank, T_Antragsteller.Antragsteller_Kreditoren_Nr, 
'AQB' + Right([T_Antraege].[Antrag_Jahr],2) + '-' + [Antragsteller_Kuerzel] AS Aktenzeichen, 
'AQB ' + [T_Antraege].[Antrag_Jahr] + ' - ' + [Antragsteller_Kuerzel] AS Aktenzeichen_lang, T_Antraege.Antrag_Jahr AS Programm_Jahr, 
LTrim(RTrim(IIf([Sachb_Vorname]>'',[Sachb_Vorname],IIf([Sachb_Anrede]>'',[Sachb_Anrede],'')) + ' ' + [Sachb_Nachname])) AS Sachbearbeiter, 
T_Sachbearbeiter.Sachb_Telefon, T_Sachbearbeiter.Sachb_Fax, T_Sachbearbeiter.Sachb_E_Mail, 
IIf(IsDate([Antrag_Durchfuehrungszeitraum_Beginn])=1,Format([Antrag_Durchfuehrungszeitraum_Beginn],'dd/MM/yyyy'),Null) AS Durchfuehrung_Beginn, 
IIf(IsDate([Antrag_Durchfuehrungszeitraum_Ende])=1,Format([Antrag_Durchfuehrungszeitraum_Ende],'dd/MM/yyyy'),Null) AS Durchfuehrung_Ende, 
IIf(IsDate([Antrag_Detail_Antragsdatum])=1,Format([Antrag_Detail_Antragsdatum],'dd/MM/yyyy'),Null) AS Antragsdatum, 
Format([Antrag_Detail_Zuwendungsbescheid_Datum],'dd/MM/yyyy') AS Zuwendungsbescheid_Datum, 
Format([Antrag_Detail_Aenderungsbescheid_Datum],'dd/MM/yyyy') AS Aenderungsbescheid_Datum, 
S_Auswertung_Verteilung_Landesmittel.HH_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[HH_Verteil_Betrag],'#,##0.00') AS HH_Verteil_Betrag, 
S_Auswertung_Verteilung_Landesmittel.VE1_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[VE1_Verteil_Betrag],'#,##0.00') AS VE1_Verteil_Betrag, 
S_Auswertung_Verteilung_Landesmittel.VE2_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[VE2_Verteil_Betrag],'#,##0.00') AS VE2_Verteil_Betrag, 
S_Auswertung_Verteilung_Landesmittel.VE3_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[VE3_Verteil_Betrag],'#,##0.00') AS VE3_Verteil_Betrag, 
S_Auswertung_Verteilung_Landesmittel.VE4_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[VE4_Verteil_Betrag],'#,##0.00') AS VE4_Verteil_Betrag
FROM T_Gebietskoerperschaften RIGHT JOIN ((T_Antragsteller LEFT JOIN (T_Antraege LEFT JOIN S_Auswertung_Verteilung_Landesmittel ON 
T_Antraege.Antrag_ID = S_Auswertung_Verteilung_Landesmittel.Antrag_ID) ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) 
LEFT JOIN (T_Sachbearbeiter RIGHT JOIN T_Antraege_Detail ON T_Sachbearbeiter.Sachb_ID = T_Antraege_Detail.Antrag_Detail_Sachb_ID) ON 
T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID) ON T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel;
GO
/****** Object:  View [dbo].[S_Auswertung_Kofinanzierung_Gesamt]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Kofinanzierung_Gesamt]
AS
SELECT        dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, SUM(dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Betrag) AS Haushalt_Kofinanz_Betrag
FROM            dbo.T_Massnahmen LEFT OUTER JOIN
                         dbo.T_Haushalt_Kofinanzierung ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Kofinanzierung.Haushalt_Kofinanz_Massnahme_ID
GROUP BY dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr
GO
/****** Object:  View [dbo].[S_Schreiben_Bescheid]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Schreiben_Bescheid]
AS
SELECT T_Antragsteller.Antragsteller_ID, T_Antraege_Detail.Antrag_Detail_Antrag_ID, T_Antraege_Detail.Antrag_Detail_lfd_Nr, T_Antragsteller.Antragsteller_Anschreiben_Name_1 AS Antragsteller_Name1, 
                  T_Antragsteller.Antragsteller_Anschreiben_Name_2 AS Antragsteller_Name2, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Ort, T_Antragsteller.Antragsteller_Plz, T_Ansprechpartner.Ansprechp_ID, 
                  IIf(T_Ansprechpartner.[Ansprechp_Titel] > '', T_Ansprechpartner.[Ansprechp_Titel] + ' ', '') + IIf(T_Ansprechpartner.[Ansprechp_Vorname] > '', T_Ansprechpartner.[Ansprechp_Vorname] + ' ', IIf(T_Ansprechpartner.[Ansprechp_Anrede] > '', 
                  T_Ansprechpartner.[Ansprechp_Anrede], '')) + T_Ansprechpartner.[Ansprechp_Nachname] AS Ansprechp_Name, IIf(T_Ansprechpartner.[Ansprechp_Anrede] > '', IIf(T_Ansprechpartner.[Ansprechp_Anrede] = 'Herr', 'Sehr geehrter Herr ', 
                  'Sehr geehrte Frau ') + IIf(T_Ansprechpartner.[Ansprechp_Titel] > '', T_Ansprechpartner.[Ansprechp_Titel] + ' ', '') + T_Ansprechpartner.[Ansprechp_Nachname], 'Sehr geehrte Damen und Herren') AS Ansprechp_Briefanrede, 
                  'AQB' + RIGHT([T_Antraege].[Antrag_Jahr], 2) + '-' + T_Antragsteller.[Antragsteller_Kuerzel] AS Aktenzeichen, T_Antraege.Antrag_Jahr AS Programm_Jahr, LTrim(RTrim(IIf(T_Sachbearbeiter.[Sachb_Vorname] > '', 
                  T_Sachbearbeiter.[Sachb_Vorname], IIf(T_Sachbearbeiter.[Sachb_Anrede] > '', T_Sachbearbeiter.[Sachb_Anrede], '')) + ' ' + T_Sachbearbeiter.[Sachb_Nachname])) AS Sachbearbeiter, T_Sachbearbeiter.Sachb_Telefon, 
                  T_Sachbearbeiter.Sachb_Fax, T_Sachbearbeiter.Sachb_E_Mail, T_Hausadressen.Hausadresse_Internet AS Haus_Internet, 
                  IIF(T_Hausadressen.[Hausadresse_ID]>0,T_Hausadressen.[Hausadresse_Strasse] + ', ' + T_Hausadressen.[Hausadresse_Plz] + ' ' + T_Hausadressen.[Hausadresse_Ort],Null) AS Haus_Besucheranschrift, IIf(IsDate(T_Antraege.[Antrag_Durchfuehrungszeitraum_Beginn]) = 1, 
                  Format(T_Antraege.[Antrag_Durchfuehrungszeitraum_Beginn], 'dd/ MMMM yyyy'), NULL) AS Durchfuehrung_Beginn, IIf(IsDate(T_Antraege.[Antrag_Durchfuehrungszeitraum_Ende]) = 1, 
                  Format(T_Antraege.[Antrag_Durchfuehrungszeitraum_Ende], 'dd/ MMMM yyyy'), NULL) AS Durchfuehrung_Ende, IIf(IsDate(T_Antraege_Detail.[Antrag_Detail_Antragsdatum]) = 1, Format(T_Antraege_Detail.[Antrag_Detail_Antragsdatum], 
                  'dd/ MMMM yyyy'), NULL) AS Antragsdatum, T_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum AS Zuwendungsbescheid_Datum, 
                  T_Antraege_Detail.Antrag_Detail_Aenderungsbescheid_Datum AS Aenderungsbescheid_Datum, IIf(S_Auswertung_Landesmittel_Gesamt.[Haushalt_Finanz_Plan_Betrag] IS NOT NULL, 
                  Format(S_Auswertung_Landesmittel_Gesamt.[Haushalt_Finanz_Plan_Betrag], 'C'), '') AS Landesmittel_gesamt, IIf(S_Auswertung_Landesmittel.[HH_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[HH_Betrag], 'C') 
                  + ' aus Mitteln des Haushaltsjahres ' + Cast([T_Antraege].[Antrag_Jahr] AS char(4)), '') AS Landesmittel_HH, IIf(S_Auswertung_Landesmittel.[VE1_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE1_Betrag], 'C') 
                  + ' aus Mitteln der Verpflichtungsermächtigung ' + Cast([T_Antraege].[Antrag_Jahr] + 1 AS char(4)), '') AS Landesmittel_VE1, IIf(S_Auswertung_Landesmittel.[VE2_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE2_Betrag], 
                  'C') + ' aus Mitteln der Verpflichtungsermächtigung ' + Cast([T_Antraege].[Antrag_Jahr] + 2 AS char(4)), '') AS Landesmittel_VE2, IIf(S_Auswertung_Landesmittel.[VE3_Betrag] IS NOT NULL, 
                  Format(S_Auswertung_Landesmittel.[VE3_Betrag], 'C') + ' aus Mitteln der Verpflichtungsermächtigung ' + Cast([T_Antraege].[Antrag_Jahr] + 3 AS char(4)), '') AS Landesmittel_VE3, 
                  IIf(S_Auswertung_Landesmittel.[VE4_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE4_Betrag], 'C') + ' aus Mitteln der Verpflichtungsermächtigung ' + Cast([T_Antraege].[Antrag_Jahr] + 4 AS char(4)), '') 
                  AS Landesmittel_VE4, IIf(S_Auswertung_Kofinanzierung_Gesamt.[Haushalt_Kofinanz_Betrag] IS NOT NULL, Format(S_Auswertung_Kofinanzierung_Gesamt.[Haushalt_Kofinanz_Betrag], 'C'), '') AS Kofinanzierung_gesamt, 
                  Format(IsNull(S_Auswertung_Landesmittel_Gesamt.[Haushalt_Finanz_Plan_Betrag], 0) + IsNull(S_Auswertung_Kofinanzierung_Gesamt.[Haushalt_Kofinanz_Betrag], 0), 'C') AS Mittel_gesamt, 
                  T_Verwaltungsgerichte.Verwaltungsgericht AS Verwaltungsgericht, S_Auswertung_Landesmittel.HH_Betrag_Sprachfoerd_Fluechtlinge, S_Auswertung_Landesmittel.HH_Betrag_Qualifizierung_Fluechtlinge, 
                  IIF(Sum(IsNull(S_Auswertung_Landesmittel.[HH_Betrag_Sprachfoerd_Fluechtlinge], 0) + IsNull(S_Auswertung_Landesmittel.[HH_Betrag_Qualifizierung_Fluechtlinge], 0)) = 0, NULL, 
                  Sum(IsNull(S_Auswertung_Landesmittel.[HH_Betrag_Sprachfoerd_Fluechtlinge], 0) + IsNull(S_Auswertung_Landesmittel.[HH_Betrag_Qualifizierung_Fluechtlinge], 0))) AS Fluechtlingsmittel_gesamt
FROM     (T_Verwaltungsgerichte RIGHT JOIN
                  T_Gebietskoerperschaften ON T_Verwaltungsgerichte.Verwaltungsgericht_ID = T_Gebietskoerperschaften.Gebietskoerp_Verwaltungsgericht_ID) INNER JOIN
                  (((T_Antragsteller INNER JOIN
                  T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) INNER JOIN
                  (T_Hausadressen RIGHT JOIN
                  (T_Sachbearbeiter RIGHT JOIN
                  (((T_Antraege_Detail LEFT JOIN
                  S_Auswertung_Landesmittel_Gesamt ON (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Landesmittel_Gesamt.Massnahme_Antrag_Detail_lfd_Nr) AND 
                  (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Landesmittel_Gesamt.Massnahme_Antrag_Detail_Antrag_ID)) LEFT JOIN
                  S_Auswertung_Landesmittel ON (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Landesmittel.Massnahme_Antrag_Detail_lfd_Nr) AND 
                  (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Landesmittel.Massnahme_Antrag_Detail_Antrag_ID)) LEFT JOIN
                  S_Auswertung_Kofinanzierung_Gesamt ON (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Kofinanzierung_Gesamt.Massnahme_Antrag_Detail_Antrag_ID) AND 
                  (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Kofinanzierung_Gesamt.Massnahme_Antrag_Detail_lfd_Nr)) ON T_Sachbearbeiter.Sachb_ID = T_Antraege_Detail.Antrag_Detail_Sachb_ID) ON 
                  T_Hausadressen.Hausadresse_ID = T_Sachbearbeiter.Sachb_Hausadresse_ID) ON T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID) INNER JOIN
                  T_Ansprechpartner ON T_Antragsteller.Antragsteller_ID = T_Ansprechpartner.Ansprechp_Antragsteller_ID) ON T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel
GROUP BY T_Antragsteller.Antragsteller_ID, T_Antraege_Detail.Antrag_Detail_Antrag_ID, T_Antraege_Detail.Antrag_Detail_lfd_Nr, T_Antragsteller.Antragsteller_Anschreiben_Name_1, T_Antragsteller.Antragsteller_Anschreiben_Name_2, 
                  T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Ort, T_Antragsteller.Antragsteller_Plz, T_Ansprechpartner.Ansprechp_ID, IIf(T_Ansprechpartner.[Ansprechp_Titel] > '', T_Ansprechpartner.[Ansprechp_Titel] + ' ', '') 
                  + IIf(T_Ansprechpartner.[Ansprechp_Vorname] > '', T_Ansprechpartner.[Ansprechp_Vorname] + ' ', IIf(T_Ansprechpartner.[Ansprechp_Anrede] > '', T_Ansprechpartner.[Ansprechp_Anrede], '')) 
                  + T_Ansprechpartner.[Ansprechp_Nachname], IIf(T_Ansprechpartner.[Ansprechp_Anrede] > '', IIf(T_Ansprechpartner.[Ansprechp_Anrede] = 'Herr', 'Sehr geehrter Herr ', 'Sehr geehrte Frau ') + IIf(T_Ansprechpartner.[Ansprechp_Titel] > '', 
                  T_Ansprechpartner.[Ansprechp_Titel] + ' ', '') + T_Ansprechpartner.[Ansprechp_Nachname], 'Sehr geehrte Damen und Herren'), 'AQB' + RIGHT([T_Antraege].[Antrag_Jahr], 2) + '-' + [Antragsteller_Kuerzel], T_Antraege.Antrag_Jahr, 
                  LTrim(RTrim(IIf(T_Sachbearbeiter.[Sachb_Vorname] > '', T_Sachbearbeiter.[Sachb_Vorname], IIf(T_Sachbearbeiter.[Sachb_Anrede] > '', T_Sachbearbeiter.[Sachb_Anrede], '')) + ' ' + T_Sachbearbeiter.[Sachb_Nachname])), 
                  T_Sachbearbeiter.Sachb_Telefon, T_Sachbearbeiter.Sachb_Fax, T_Sachbearbeiter.Sachb_E_Mail, T_Hausadressen.Hausadresse_Internet, 
                  IIF(T_Hausadressen.[Hausadresse_ID]>0,T_Hausadressen.[Hausadresse_Strasse] + ', ' + T_Hausadressen.[Hausadresse_Plz] + ' ' + T_Hausadressen.[Hausadresse_Ort],Null), IIf(IsDate(T_Antraege.[Antrag_Durchfuehrungszeitraum_Beginn]) = 1, 
                  Format(T_Antraege.[Antrag_Durchfuehrungszeitraum_Beginn], 'dd/ MMMM yyyy'), NULL), IIf(IsDate(T_Antraege.[Antrag_Durchfuehrungszeitraum_Ende]) = 1, Format(T_Antraege.[Antrag_Durchfuehrungszeitraum_Ende], 
                  'dd/ MMMM yyyy'), NULL), IIf(IsDate(T_Antraege_Detail.[Antrag_Detail_Antragsdatum]) = 1, Format(T_Antraege_Detail.[Antrag_Detail_Antragsdatum], 'dd/ MMMM yyyy'), NULL), 
                  T_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum, T_Antraege_Detail.Antrag_Detail_Aenderungsbescheid_Datum, IIf(S_Auswertung_Landesmittel_Gesamt.[Haushalt_Finanz_Plan_Betrag] IS NOT NULL, 
                  Format(S_Auswertung_Landesmittel_Gesamt.[Haushalt_Finanz_Plan_Betrag], 'C'), ''), IIf(S_Auswertung_Landesmittel.[HH_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[HH_Betrag], 'C') 
                  + ' aus Mitteln des Haushaltsjahres ' + CAST([T_Antraege].[Antrag_Jahr] AS char(4)), ''), IIf(S_Auswertung_Landesmittel.[VE1_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE1_Betrag], 'C') 
                  + ' aus Mitteln der Verpflichtungsermächtigung ' + CAST([T_Antraege].[Antrag_Jahr] + 1 AS char(4)), ''), IIf(S_Auswertung_Landesmittel.[VE2_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE2_Betrag], 'C') 
                  + ' aus Mitteln der Verpflichtungsermächtigung ' + CAST([T_Antraege].[Antrag_Jahr] + 2 AS char(4)), ''), IIf(S_Auswertung_Landesmittel.[VE3_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE3_Betrag], 'C') 
                  + ' aus Mitteln der Verpflichtungsermächtigung ' + CAST([T_Antraege].[Antrag_Jahr] + 3 AS char(4)), ''), IIf(S_Auswertung_Landesmittel.[VE4_Betrag] IS NOT NULL, Format(S_Auswertung_Landesmittel.[VE4_Betrag], 'C') 
                  + ' aus Mitteln der Verpflichtungsermächtigung ' + CAST([T_Antraege].[Antrag_Jahr] + 4 AS char(4)), ''), IIf(S_Auswertung_Kofinanzierung_Gesamt.[Haushalt_Kofinanz_Betrag] IS NOT NULL, 
                  Format(S_Auswertung_Kofinanzierung_Gesamt.[Haushalt_Kofinanz_Betrag], 'C'), ''), Format(IsNull(S_Auswertung_Landesmittel_Gesamt.[Haushalt_Finanz_Plan_Betrag], 0) 
                  + IsNull(S_Auswertung_Kofinanzierung_Gesamt.[Haushalt_Kofinanz_Betrag], 0), 'C'), T_Verwaltungsgerichte.Verwaltungsgericht, S_Auswertung_Landesmittel.HH_Betrag_Sprachfoerd_Fluechtlinge, 
                  S_Auswertung_Landesmittel.HH_Betrag_Qualifizierung_Fluechtlinge, T_Ansprechpartner.Ansprechp_Anschreiben
HAVING (((T_Ansprechpartner.Ansprechp_Anschreiben) = 1));
GO
/****** Object:  View [dbo].[S_Auswertung_Anzahl_Plaetze_und_Teilnehmer]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Anzahl_Plaetze_und_Teilnehmer]
AS
SELECT        Massnahme_Antrag_Detail_Antrag_ID AS Antrag_Detail_Antrag_ID, Massnahme_Antrag_Detail_lfd_Nr AS Antrag_Detail_lfd_Nr, SUM(Massnahme_Anzahl_Plaetze_geplant) AS Summe_Anzahl_Plaetze_geplant, 
                         SUM(Massnahme_Anzahl_Plaetze_aktuell) AS Summe_Anzahl_Plaetze_aktuell, SUM(Massnahme_Anzahl_Teilnehmer_geplant) AS Summe_Anzahl_Teilnehmer_geplant, SUM(Massnahme_Anzahl_Teilnehmer_aktuell) 
                         AS Summe_Anzahl_Teilnehmer_aktuell
FROM            dbo.T_Massnahmen
GROUP BY Massnahme_Antrag_Detail_Antrag_ID, Massnahme_Antrag_Detail_lfd_Nr
HAVING        (Massnahme_Antrag_Detail_Antrag_ID IS NOT NULL) AND (Massnahme_Antrag_Detail_lfd_Nr IS NOT NULL)
GO
/****** Object:  View [dbo].[S_Auswertung_Auszahlungen]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Auszahlungen]
AS
SELECT T_Antraege.Antrag_ID, T_Antraege.Antrag_Antragsteller_ID, T_Antraege.Antrag_Jahr, T_Antraege.Antrag_Jahr AS HH_Jahr, 
Sum(IIf([Haushalt_Auszahl_Jahr]=[Antrag_Jahr],[Haushalt_Auszahl_Betrag],Null)) AS HH_Auszahlung_Betrag, 
[Antrag_Jahr]+1 AS VE1_Jahr, 
Sum(IIf([Haushalt_Auszahl_Jahr]=[Antrag_Jahr]+1,[Haushalt_Auszahl_Betrag],Null)) AS VE1_Auszahlung_Betrag, 
[Antrag_Jahr]+2 AS VE2_Jahr, 
Sum(IIf([Haushalt_Auszahl_Jahr]=[Antrag_Jahr]+2,[Haushalt_Auszahl_Betrag],Null)) AS VE2_Auszahlung_Betrag, 
[Antrag_Jahr]+3 AS VE3_Jahr, 
Sum(IIf([Haushalt_Auszahl_Jahr]=[Antrag_Jahr]+3,[Haushalt_Auszahl_Betrag],Null)) AS VE3_Auszahlung_Betrag, 
[Antrag_Jahr]+4 AS VE4_Jahr, 
Sum(IIf([Haushalt_Auszahl_Jahr]=[Antrag_Jahr]+4,[Haushalt_Auszahl_Betrag],Null)) AS VE4_Auszahlung_Betrag
FROM T_Antraege INNER JOIN T_Haushalt_Auszahlungen ON T_Antraege.Antrag_ID = T_Haushalt_Auszahlungen.Haushalt_Auszahl_Antrag_ID
WHERE T_Haushalt_Auszahlungen.Haushalt_Auszahl_Storno=0 AND [Haushalt_Auszahl_Auszahlungsdatum]>''
GROUP BY T_Antraege.Antrag_ID, T_Antraege.Antrag_Antragsteller_ID, T_Antraege.Antrag_Jahr, [Antrag_Jahr]+1, [Antrag_Jahr]+2, [Antrag_Jahr]+3, [Antrag_Jahr]+4, T_Antraege.Antrag_Jahr;


GO
/****** Object:  View [dbo].[S_Schreiben_Daten]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Schreiben_Daten]
AS
SELECT        T_Antragsteller.Antragsteller_ID, T_Antraege_Detail.Antrag_Detail_Antrag_ID, T_Antraege_Detail.Antrag_Detail_lfd_Nr, T_Antragsteller.Antragsteller_Kuerzel, 
                         T_Gebietskoerperschaften.Gebietskoerp_Bezeichnung AS Antragsteller, T_Antragsteller.Antragsteller_Name, T_Antragsteller.Antragsteller_Anschreiben_Name_1 AS Antragsteller_Name1, 
                         T_Antragsteller.Antragsteller_Anschreiben_Name_2 AS Antragsteller_Name2, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Plz, T_Antragsteller.Antragsteller_Ort, T_Antragsteller.Antragsteller_IBAN, 
                         T_Antragsteller.Antragsteller_BIC, T_Antragsteller.Antragsteller_Bank, T_Antragsteller.Antragsteller_Kreditoren_Nr, T_Antragsteller.Antragsteller_Strategie_aus_Jahr, 'AQB' + RIGHT([T_Antraege].[Antrag_Jahr], 2) 
                         + '-' + T_Antragsteller.[Antragsteller_Kuerzel] AS Aktenzeichen, IIF([T_Verwaltungsgerichte].Verwaltungsgericht_ID > 0, 
                         [T_Verwaltungsgerichte].[Verwaltungsgericht] + ', ' + [T_Verwaltungsgerichte].[Verwaltungsgericht_Strasse] + ', ' + [T_Verwaltungsgerichte].[Verwaltungsgericht_Plz] + ' ' + [T_Verwaltungsgerichte].[Verwaltungsgericht], NULL) 
                         AS Verwaltungsgericht, T_Antraege.Antrag_Jahr, LTrim(RTrim(IIf(T_Sachbearbeiter.[Sachb_Vorname] > '', T_Sachbearbeiter.[Sachb_Vorname], IIf(T_Sachbearbeiter.[Sachb_Anrede] > '', T_Sachbearbeiter.[Sachb_Anrede], '')) 
                         + ' ' + T_Sachbearbeiter.[Sachb_Nachname])) AS Sachbearbeiter, T_Sachbearbeiter.Sachb_Telefon, T_Sachbearbeiter.Sachb_Fax, T_Sachbearbeiter.Sachb_E_Mail, 
                         IIf(IsDate(T_Antraege.[Antrag_Durchfuehrungszeitraum_Beginn]) = 1, Format(T_Antraege.[Antrag_Durchfuehrungszeitraum_Beginn], 'dd/MM/yyyy'), NULL) AS Durchfuehrung_Beginn, 
                         IIf(IsDate(T_Antraege.[Antrag_Durchfuehrungszeitraum_Ende]) = 1, Format(T_Antraege.[Antrag_Durchfuehrungszeitraum_Ende], 'dd/MM/yyyy'), NULL) AS Durchfuehrung_Ende, 
                         IIf(IsDate(T_Antraege_Detail.[Antrag_Detail_Antragsdatum]) = 1, Format(T_Antraege_Detail.[Antrag_Detail_Antragsdatum], 'dd/MM/yyyy'), NULL) AS Antragsdatum, 
                         T_Antraege.Antrag_Inaussichtstellung_Datum AS Inaussichtstellung_Datum, Format(T_Antraege_Detail.[Antrag_Detail_Zuwendungsbescheid_Datum], 'dd/MM/yyyy') AS Zuwendungsbescheid_Datum, 
                         Format(T_Antraege_Detail.[Antrag_Detail_Aenderungsbescheid_Datum], 'dd/MM/yyyy') AS Aenderungsbescheid_Datum, S_Auswertung_Verteilung_Landesmittel.HH_Jahr, 
                         Format([S_Auswertung_Verteilung_Landesmittel].[HH_Verteil_Betrag], '#,##0.00') AS HH_Verteil_Betrag, S_Auswertung_Landesmittel.HH_Betrag, S_Auswertung_Landesmittel.HH_Betrag_Sprachfoerd_Fluechtlinge, 
                         S_Auswertung_Landesmittel.HH_Betrag_Qualifizierung_Fluechtlinge, S_Auswertung_Auszahlungen.HH_Auszahlung_Betrag, S_Auswertung_Verteilung_Landesmittel.VE1_Jahr, 
                         Format([S_Auswertung_Verteilung_Landesmittel].[VE1_Verteil_Betrag], '#,##0.00') AS VE1_Verteil_Betrag, S_Auswertung_Landesmittel.VE1_Betrag, S_Auswertung_Landesmittel.VE1_Betrag_Sprachfoerd_Fluechtlinge, 
                         S_Auswertung_Landesmittel.VE1_Betrag_Qualifizierung_Fluechtlinge, S_Auswertung_Auszahlungen.VE1_Auszahlung_Betrag, S_Auswertung_Verteilung_Landesmittel.VE2_Jahr, 
                         Format([S_Auswertung_Verteilung_Landesmittel].[VE2_Verteil_Betrag], '#,##0.00') AS VE2_Verteil_Betrag, S_Auswertung_Landesmittel.VE2_Betrag, S_Auswertung_Auszahlungen.VE2_Auszahlung_Betrag, 
                         S_Auswertung_Verteilung_Landesmittel.VE3_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[VE3_Verteil_Betrag], '#,##0.00') AS VE3_Verteil_Betrag, S_Auswertung_Landesmittel.VE3_Betrag, 
                         S_Auswertung_Auszahlungen.VE3_Auszahlung_Betrag, S_Auswertung_Verteilung_Landesmittel.VE4_Jahr, Format([S_Auswertung_Verteilung_Landesmittel].[VE4_Verteil_Betrag], '#,##0.00') AS VE4_Verteil_Betrag, 
                         S_Auswertung_Landesmittel.VE4_Betrag, S_Auswertung_Auszahlungen.VE4_Auszahlung_Betrag, S_Auswertung_Verteilung_Landesmittel_Gesamt.Haushalt_Verteil_Betrag AS Verteilung_Landesmittel_Gesamt, 
                         S_Auswertung_Landesmittel_Gesamt.Haushalt_Finanz_Plan_Betrag AS Landesmittel_Gesamt, S_Auswertung_Kofinanzierung_Gesamt.Haushalt_Kofinanz_Betrag AS Kofinanzierung_Gesamt, 
                         IIF(IsNull(S_Auswertung_Landesmittel_Gesamt.Haushalt_Finanz_Plan_Betrag, 0) + IsNull(S_Auswertung_Kofinanzierung_Gesamt.Haushalt_Kofinanz_Betrag, 0) = 0, NULL, 
                         IsNull(S_Auswertung_Landesmittel_Gesamt.Haushalt_Finanz_Plan_Betrag, 0) + IsNull(S_Auswertung_Kofinanzierung_Gesamt.Haushalt_Kofinanz_Betrag, 0)) AS Foerderung_Gesamt, 
                         S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Betrag AS Auszahlung_Gesamt, S_Auswertung_Anzahl_Plaetze_und_Teilnehmer.Summe_Anzahl_Plaetze_geplant, 
                         S_Auswertung_Anzahl_Plaetze_und_Teilnehmer.Summe_Anzahl_Plaetze_aktuell, S_Auswertung_Anzahl_Plaetze_und_Teilnehmer.Summe_Anzahl_Teilnehmer_geplant, 
                         S_Auswertung_Anzahl_Plaetze_und_Teilnehmer.Summe_Anzahl_Teilnehmer_aktuell
FROM            ((T_Verwaltungsgerichte RIGHT JOIN
                         T_Gebietskoerperschaften ON T_Verwaltungsgerichte.Verwaltungsgericht_ID = T_Gebietskoerperschaften.Gebietskoerp_Verwaltungsgericht_ID) RIGHT JOIN
                         (T_Antragsteller LEFT JOIN
                         (((T_Antraege LEFT JOIN
                         S_Auswertung_Verteilung_Landesmittel ON T_Antraege.Antrag_ID = S_Auswertung_Verteilung_Landesmittel.Antrag_ID) LEFT JOIN
                         S_Auswertung_Verteilung_Landesmittel_Gesamt ON T_Antraege.Antrag_ID = S_Auswertung_Verteilung_Landesmittel_Gesamt.Antrag_ID) LEFT JOIN
                         S_Auswertung_Auszahlungen ON T_Antraege.Antrag_ID = S_Auswertung_Auszahlungen.Antrag_ID) ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) ON 
                         T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel) LEFT JOIN
                         (T_Sachbearbeiter RIGHT JOIN
                         (((((T_Antraege_Detail LEFT JOIN
                         S_Auswertung_Landesmittel_Gesamt ON (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Landesmittel_Gesamt.Massnahme_Antrag_Detail_Antrag_ID) AND 
                         (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Landesmittel_Gesamt.Massnahme_Antrag_Detail_lfd_Nr)) LEFT JOIN
                         S_Auswertung_Kofinanzierung_Gesamt ON (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Kofinanzierung_Gesamt.Massnahme_Antrag_Detail_Antrag_ID) AND 
                         (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Kofinanzierung_Gesamt.Massnahme_Antrag_Detail_lfd_Nr)) LEFT JOIN
                         S_Auswertung_Auszahlungen_Gesamt ON T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Auszahlungen_Gesamt.Haushalt_Auszahl_Antrag_ID) LEFT JOIN
                         S_Auswertung_Anzahl_Plaetze_und_Teilnehmer ON (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Anzahl_Plaetze_und_Teilnehmer.Antrag_Detail_Antrag_ID) AND 
                         (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Anzahl_Plaetze_und_Teilnehmer.Antrag_Detail_lfd_Nr)) LEFT JOIN
                         S_Auswertung_Landesmittel ON (T_Antraege_Detail.Antrag_Detail_Antrag_ID = S_Auswertung_Landesmittel.Massnahme_Antrag_Detail_Antrag_ID) AND 
                         (T_Antraege_Detail.Antrag_Detail_lfd_Nr = S_Auswertung_Landesmittel.Massnahme_Antrag_Detail_lfd_Nr)) ON T_Sachbearbeiter.Sachb_ID = T_Antraege_Detail.Antrag_Detail_Sachb_ID) ON 
                         T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID;
GO
/****** Object:  View [dbo].[S_Auswertung_Massnahmen_UA]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Massnahmen_UA]
AS
SELECT        dbo.T_Massnahmen.Massnahme_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Leistungsbezug_SGB_ID, dbo.T_Verbleib.Verbleib_ID, dbo.T_Verbleib.Verbleib_Text, dbo.T_Austrittsgruende.Austrittsgrund_ID, 
                         dbo.T_Austrittsgruende.Austrittsgrund_Bezeichnung, COUNT(dbo.T_Teilnehmer_Monitoring.Teiln_Teilnehmer_ID) AS Anzahl_Teilnehmer
FROM            dbo.T_Teilnehmer_Monitoring INNER JOIN
                         dbo.T_Massnahmen ON dbo.T_Teilnehmer_Monitoring.Teiln_Massnahme_ID = dbo.T_Massnahmen.Massnahme_ID LEFT OUTER JOIN
                         dbo.T_Austrittsgruende ON dbo.T_Teilnehmer_Monitoring.Teiln_Austrittsgrund_ID = dbo.T_Austrittsgruende.Austrittsgrund_ID LEFT OUTER JOIN
                         dbo.T_Verbleib ON dbo.T_Teilnehmer_Monitoring.Teiln_Verbleib_ID = dbo.T_Verbleib.Verbleib_ID
GROUP BY dbo.T_Massnahmen.Massnahme_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Leistungsbezug_SGB_ID, dbo.T_Verbleib.Verbleib_ID, dbo.T_Verbleib.Verbleib_Text, dbo.T_Austrittsgruende.Austrittsgrund_ID, 
                         dbo.T_Austrittsgruende.Austrittsgrund_Bezeichnung
GO
/****** Object:  View [dbo].[S_Auswertung_Massnahmen]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Auswertung_Massnahmen]
AS
SELECT        dbo.T_Antragsteller.Antragsteller_Kontext, dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Aktenzeichen, 
                         dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.T_Massnahmen.Massnahme_Beginn, dbo.T_Massnahmen.Massnahme_Ende, SUM(dbo.T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Betrag) 
                         AS Haushalt_Finanz_Plan_Betrag, SUM(dbo.T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge) AS Haushalt_Finanz_Plan_Sprachfoerd_Fluechtlinge, 
                         SUM(dbo.T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge) AS Haushalt_Finanz_Plan_Qualifizierung_Fluechtlinge, dbo.T_Massnahmen.Massnahme_Anzahl_Plaetze_geplant, 
                         dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant, dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_aktuell, dbo.T_Massnahmen.Massnahme_Durchgaenge, dbo.T_Massnahmen.Massnahme_Monitoring, 
                         dbo.T_Massnahmen.Massnahme_Monitoring_Importdatum, dbo.T_Massnahmen.Massnahme_Abschluss_gemeldet, dbo.S_Auswertung_Massnahmen_UA.Teiln_Leistungsbezug_SGB_ID, 
                         dbo.S_Auswertung_Massnahmen_UA.Verbleib_ID, dbo.S_Auswertung_Massnahmen_UA.Verbleib_Text, dbo.S_Auswertung_Massnahmen_UA.Anzahl_Teilnehmer, dbo.S_Auswertung_Massnahmen_UA.Austrittsgrund_ID, 
                         dbo.S_Auswertung_Massnahmen_UA.Austrittsgrund_Bezeichnung, 1 AS Auswert_ID
FROM            dbo.T_Antragsteller INNER JOIN
                         dbo.T_Antraege ON dbo.T_Antragsteller.Antragsteller_ID = dbo.T_Antraege.Antrag_Antragsteller_ID INNER JOIN
                         dbo.T_Antraege_Detail ON dbo.T_Antraege.Antrag_ID = dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID INNER JOIN
                         dbo.T_Massnahmen ON dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID AND 
                         dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr INNER JOIN
                         dbo.T_Haushalt_Finanzierungsplan ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Haushalt_Finanzierungsplan.Haushalt_Finanz_Plan_Massnahme_ID INNER JOIN
                         dbo.S_Auswertung_Massnahmen_UA ON dbo.T_Massnahmen.Massnahme_ID = dbo.S_Auswertung_Massnahmen_UA.Massnahme_ID
GROUP BY dbo.T_Antragsteller.Antragsteller_Kontext, dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Aktenzeichen, 
                         dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.T_Massnahmen.Massnahme_Beginn, dbo.T_Massnahmen.Massnahme_Ende, dbo.T_Massnahmen.Massnahme_Anzahl_Plaetze_geplant, 
                         dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant, dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_aktuell, dbo.T_Massnahmen.Massnahme_Durchgaenge, dbo.T_Massnahmen.Massnahme_Monitoring, 
                         dbo.T_Massnahmen.Massnahme_Monitoring_Importdatum, dbo.T_Massnahmen.Massnahme_Abschluss_gemeldet, dbo.S_Auswertung_Massnahmen_UA.Teiln_Leistungsbezug_SGB_ID, 
                         dbo.S_Auswertung_Massnahmen_UA.Verbleib_ID, dbo.S_Auswertung_Massnahmen_UA.Verbleib_Text, dbo.S_Auswertung_Massnahmen_UA.Anzahl_Teilnehmer, dbo.S_Auswertung_Massnahmen_UA.Austrittsgrund_ID, 
                         dbo.S_Auswertung_Massnahmen_UA.Austrittsgrund_Bezeichnung
HAVING        (dbo.T_Massnahmen.Massnahme_Monitoring = 1)
GO
/****** Object:  View [dbo].[S_Alle_Aktenzeichen_eines_Antragstellers]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Alle_Aktenzeichen_eines_Antragstellers]
AS
SELECT        dbo.T_Antragsteller.Antragsteller_ID, dbo.T_Antragsteller.Antragsteller_Kontext, dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antraege.Antrag_Jahr, dbo.T_Massnahmen.Massnahme_ID, 
                         dbo.T_Massnahmen.Massnahme_Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.F_Projekttraeger(dbo.T_Massnahmen.Massnahme_ID, NCHAR(13) + NCHAR(10)) AS Massnahme_Projekttraeger, 
                         dbo.T_Massnahmen.Massnahme_Beginn, dbo.T_Massnahmen.Massnahme_Ende
FROM            dbo.T_Antragsteller INNER JOIN
                         dbo.T_Antraege ON dbo.T_Antragsteller.Antragsteller_ID = dbo.T_Antraege.Antrag_Antragsteller_ID INNER JOIN
                         dbo.T_Antraege_Detail INNER JOIN
                         dbo.T_Massnahmen ON dbo.T_Antraege_Detail.Antrag_Detail_lfd_Nr = dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr AND 
                         dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID = dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID ON dbo.T_Antraege.Antrag_ID = dbo.T_Antraege_Detail.Antrag_Detail_Antrag_ID
GO
/****** Object:  View [dbo].[S_Antraege]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Antraege]
AS
SELECT T_Antragsteller.Antragsteller_ID, T_Antragsteller.Antragsteller_Kuerzel, [Antragsteller_Kuerzel] + ' - ' + [Antragsteller_Name] + 
IIf([Antragsteller_Ort]>'',', ' + [Antragsteller_Ort],'') AS Antragsteller, T_Antraege.*, 
'HH' + CAST([Antrag_Jahr] As Char(4)) AS Antrag_Jahr_HH, 'VE' + CAST([Antrag_Jahr]+1 As Char(4)) AS Antrag_Jahr_VE1, 'VE' + CAST([Antrag_Jahr]+2  As Char(4)) AS Antrag_Jahr_VE2, 
'VE' + CAST([Antrag_Jahr]+3 As Char(4)) AS Antrag_Jahr_VE3, 'VE' + CAST([Antrag_Jahr]+4 As Char(4)) AS Antrag_Jahr_VE4, 
IIf([Antrag_Sachb_ID]>0,[Sachb_Nachname] + ', ' + [Sachb_Vorname],'') AS Sachbearbeiter
FROM T_Sachbearbeiter RIGHT JOIN (T_Antragsteller INNER JOIN T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) ON 
T_Sachbearbeiter.Sachb_ID = T_Antraege.Antrag_Sachb_ID;
GO
/****** Object:  View [dbo].[S_Anzahl_Teilnehmer_aktuell]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Anzahl_Teilnehmer_aktuell]
AS
SELECT        Teiln_Massnahme_ID, COUNT(Teiln_Teilnehmer_ID) AS Anzahl_Teilnehmende
FROM            dbo.T_Teilnehmer_Monitoring
GROUP BY Teiln_Massnahme_ID
GO
/****** Object:  View [dbo].[S_Finanzierungsplan]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Finanzierungsplan]
AS
SELECT dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, dbo.T_Massnahmen.Massnahme_Massnahmeart_ID, 
                  dbo.T_Massnahmen.Massnahme_Nr, dbo.T_Massnahmen.Massnahme_Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.T_Massnahmen.Massnahme_Kurzbeschreibung, dbo.T_Massnahmen.Massnahme_Beginn, 
                  dbo.T_Massnahmen.Massnahme_Ende, dbo.T_Massnahmen.Massnahme_Digitales_Lernen, dbo.T_Massnahmen.Massnahme_Mittel_Vergabe, dbo.T_Massnahmen.Massnahme_Mittel_Zuwendung, 
                  dbo.T_Massnahmen.Massnahme_Durchgaenge, dbo.T_Massnahmen.Massnahme_Ausbildung, dbo.T_Massnahmen.Massnahme_Massn_Ziel_ID, dbo.T_Massnahmen.Massnahme_Zielgruppe_ID, 
                  dbo.T_Massnahmen.Massnahme_Anzahl_Plaetze_geplant, dbo.T_Massnahmen.Massnahme_Anzahl_Plaetze_aktuell, dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant, 
                  dbo.T_Massnahmen.Massnahme_Anzahl_Teilnehmer_aktuell, dbo.T_Massnahmen.Massnahme_Verweildauer_Tage, dbo.T_Massnahmen.Massnahme_Verweildauer_Wochen, dbo.T_Massnahmen.Massnahme_Verweildauer_Monate, 
                  dbo.T_Massnahmen.Massnahme_Monitoring, dbo.T_Massnahmen.Massnahme_Jahresmeldung, dbo.T_Massnahmen.Massnahme_Monitoring_Importdatum, dbo.T_Massnahmen.Massnahme_Abschluss_gemeldet, 
                  dbo.T_Massnahmen.Massnahme_Monitoring_abgeschlossen, dbo.T_Massnahmen.Massnahme_Erfasser, dbo.T_Massnahmen.Massnahme_Erfassungsdatum, dbo.T_Massnahmen.Massnahme_Geaendert_von, 
                  dbo.T_Massnahmen.Massnahme_Aenderungsdatum, dbo.T_Massnahmearten.Massnahmeart_Bezeichnung, dbo.F_Projekttraeger(dbo.T_Massnahmen.Massnahme_ID, N' | ') AS Projekttraeger, dbo.T_Antraege.Antrag_Jahr
FROM     dbo.T_Massnahmearten INNER JOIN
                  dbo.T_Massnahmen INNER JOIN
                  dbo.T_Antraege ON dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID = dbo.T_Antraege.Antrag_ID ON dbo.T_Massnahmearten.Massnahmeart_ID = dbo.T_Massnahmen.Massnahme_Massnahmeart_ID
GO
/****** Object:  View [dbo].[S_Haushalt_Kofinanzierung]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Haushalt_Kofinanzierung]
AS
SELECT        Haushalt_Kofinanz_Massnahme_ID, SUM(Haushalt_Kofinanz_Betrag) AS Haushalt_Kofinanz_Betrag
FROM            dbo.T_Haushalt_Kofinanzierung
GROUP BY Haushalt_Kofinanz_Massnahme_ID
GO
/****** Object:  View [dbo].[S_LIste_Antraege]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_LIste_Antraege]
AS
SELECT        T_Antragsteller.Antragsteller_ID, T_Antragsteller.Antragsteller_Kuerzel, T_Antragsteller.Antragsteller_Name, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Plz, T_Antragsteller.Antragsteller_Ort, 
                         LTrim(RTrim(IsNull([Antragsteller_Plz],'') + ' ' + IsNull([Antragsteller_Ort],''))) AS Antragsteller_Plz_Ort, [Antragsteller_Name] + IIf([Antragsteller_Ort] > '', ', ' + [Antragsteller_Ort], '') AS Antragsteller, 
                         T_Regierungsbezirke.Regierungsbezirk_Bezeichnung, T_Antraege.Antrag_ID, 'AQB' + RIGHT([Antrag_Jahr], 2) + '-' + [Antragsteller_Kuerzel] AS Antrag_Aktenzeichen, T_Antraege.Antrag_Jahr, 
                         T_Antraege.Antrag_Wiedervorlage_Datum, T_Antraege.Antrag_Abgeschlossen, T_Sachbearbeiter.Sachb_Nachname, T_Sachbearbeiter.Sachb_Vorname, IIf([Antrag_Sachb_ID] > '0', 
                         LTrim(RTrim(IsNull([Sachb_Nachname],'') + ', ' + IsNull([Sachb_Vorname],''))), '') AS Sachb_Name, T_Antraege.Antrag_Durchfuehrungszeitraum_Beginn, T_Antraege.Antrag_Durchfuehrungszeitraum_Ende
FROM            T_Regierungsbezirke RIGHT JOIN
                         (T_Gebietskoerperschaften RIGHT JOIN
                         (T_Sachbearbeiter RIGHT JOIN
                         (T_Antragsteller INNER JOIN
                         T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) ON T_Sachbearbeiter.Sachb_ID = T_Antraege.Antrag_Sachb_ID) ON 
                         T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel) ON T_Regierungsbezirke.Regierungsbezirk_ID = T_Gebietskoerperschaften.Gebietskoerp_Regierungsbezirk_ID;
GO
/****** Object:  View [dbo].[S_Liste_Antraege_Detail]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Liste_Antraege_Detail]
AS
SELECT        T_Antragsteller.Antragsteller_ID, T_Antragsteller.Antragsteller_Kuerzel, T_Antragsteller.Antragsteller_Name, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Plz, T_Antragsteller.Antragsteller_Ort, 
                         LTrim(RTrim(IsNull([Antragsteller_Plz],'') + ' ' + IsNull([Antragsteller_Ort],''))) AS Antragsteller_Plz_Ort, [Antragsteller_Name] + IIf([Antragsteller_Ort] > '', ', ' + [Antragsteller_Ort], '') AS Antragsteller, 
                         T_Regierungsbezirke.Regierungsbezirk_Bezeichnung, T_Antraege.Antrag_ID, T_Antraege.Antrag_Jahr, T_Antraege.Antrag_Sachb_ID, T_Antraege.Antrag_Wiedervorlage_Datum, T_Antraege.Antrag_Abgeschlossen, 
                         T_Antraege_Detail.Antrag_Detail_lfd_Nr, T_Antraege_Detail.Antrag_Detail_Antragsdatum, T_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum, T_Antraege_Detail.Antrag_Detail_Aenderungsbescheid_Datum, 
                         T_Sachbearbeiter.Sachb_Nachname, T_Sachbearbeiter.Sachb_Vorname, IIf([Antrag_Sachb_ID] > '0', LTrim(RTrim(IsNull([Sachb_Nachname],'') + ', ' + IsNull([Sachb_Vorname],''))), '') AS Sachb_Name, 
                         T_Antraege.Antrag_Durchfuehrungszeitraum_Beginn, T_Antraege.Antrag_Durchfuehrungszeitraum_Ende, T_Antraege_Detail.Antrag_Detail_Massnahmeart_1, T_Antraege_Detail.Antrag_Detail_Massnahmeart_2, 
                         T_Antraege_Detail.Antrag_Detail_Massnahmeart_3, T_Antraege_Detail.Antrag_Detail_Massnahmeart_4, T_Antraege_Detail.Antrag_Detail_Massnahmeart_5
FROM            T_Regierungsbezirke RIGHT JOIN
                         ((T_Gebietskoerperschaften RIGHT JOIN
                         (T_Sachbearbeiter RIGHT JOIN
                         (T_Antragsteller INNER JOIN
                         T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) ON T_Sachbearbeiter.Sachb_ID = T_Antraege.Antrag_Sachb_ID) ON 
                         T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel) INNER JOIN
                         T_Antraege_Detail ON T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID) ON T_Regierungsbezirke.Regierungsbezirk_ID = T_Gebietskoerperschaften.Gebietskoerp_Regierungsbezirk_ID;
GO
/****** Object:  View [dbo].[S_Liste_Antragsteller]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Liste_Antragsteller]
AS
SELECT        dbo.T_Antragsteller.Antragsteller_ID, dbo.T_Antragsteller.Antragsteller_Kuerzel, dbo.T_Antragsteller.Antragsteller_Name, dbo.T_Antragsteller.Antragsteller_Strasse, dbo.T_Antragsteller.Antragsteller_Plz, 
                         dbo.T_Antragsteller.Antragsteller_Ort, LTRIM(RTRIM(ISNULL(dbo.T_Antragsteller.Antragsteller_Plz, '') + ' ' + ISNULL(dbo.T_Antragsteller.Antragsteller_Ort, ''))) AS Antragsteller_Plz_Ort, 
                         dbo.T_Regierungsbezirke.Regierungsbezirk_Bezeichnung
FROM            dbo.T_Regierungsbezirke RIGHT OUTER JOIN
                         dbo.T_Gebietskoerperschaften RIGHT OUTER JOIN
                         dbo.T_Antragsteller ON dbo.T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = dbo.T_Antragsteller.Antragsteller_Kuerzel ON 
                         dbo.T_Regierungsbezirke.Regierungsbezirk_ID = dbo.T_Gebietskoerperschaften.Gebietskoerp_Regierungsbezirk_ID
GO
/****** Object:  View [dbo].[S_Massnahme_Aktenzeichen_letzter_Antrag]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Massnahme_Aktenzeichen_letzter_Antrag]
AS
SELECT Massnahme_Aktenzeichen, Massnahme_Antrag_Detail_Antrag_ID, MAX(Massnahme_Antrag_Detail_lfd_Nr) AS Massnahme_Antrag_Detail_lfd_Nr
FROM     dbo.T_Massnahmen
GROUP BY Massnahme_Aktenzeichen, Massnahme_Antrag_Detail_Antrag_ID
GO
/****** Object:  View [dbo].[S_Massnahmen_exportieren]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Massnahmen_exportieren]
AS
SELECT        T_Antragsteller.Antragsteller_Kontext AS Kontext, T_Massnahmen.Massnahme_ID, T_Antragsteller.Antragsteller_Landkreis_ID AS Landkreis_ID, T_Antraege.Antrag_Antragsteller_ID AS Antragsteller_ID, T_Antraege.Antrag_Jahr, 
                         T_Massnahmen.Massnahme_Aktenzeichen, dbo.F_Sonderzeichen_entfernen(T_Massnahmen.Massnahme_Bezeichnung) AS Massnahme_Bezeichnung, T_Projekttraeger.Projekttraeger_ID, 
                         dbo.F_Sonderzeichen_entfernen(T_Projekttraeger.Projekttraeger_Name) AS Projekttraeger_Name, IIf(IsDate([T_Massnahmen].[Massnahme_Beginn]) = 1, Format([T_Massnahmen].[Massnahme_Beginn], 'dd/MM/yyyy'), NULL) 
                         AS Massnahme_Beginn, IIf(IsDate([T_Massnahmen].[Massnahme_Ende]) = 1, Format([T_Massnahmen].[Massnahme_Ende], 'dd/MM/yyyy'), NULL) AS Massnahme_Ende, T_Massnahmen.Massnahme_Verweildauer_Tage, 
                         T_Massnahmen.Massnahme_Durchgaenge, ISNull(T_Massnahmen.Massnahme_Anzahl_Teilnehmer_geplant, ISNull(T_Massnahmen.Massnahme_Durchgaenge,0) * ISNull(T_Massnahmen.Massnahme_Anzahl_Plaetze_geplant,0)) AS Anzahl_Plaetze, IIf(IsDate([T_Antraege].[Antrag_Durchfuehrungszeitraum_Ende]) = 1, 
                         Format([T_Antraege].[Antrag_Durchfuehrungszeitraum_Ende], 'dd/MM/yyyy'), NULL) AS Gesamtes_Laufzeitende, 'M' + Cast([T_Massnahmen].[Massnahme_Massnahmeart_ID] AS varchar) AS Massnahmeart
FROM            T_Projekttraeger INNER JOIN
                         (((T_Antragsteller INNER JOIN
                         T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) INNER JOIN
                         (T_Antraege_Detail INNER JOIN
                         T_Massnahmen ON (T_Antraege_Detail.Antrag_Detail_lfd_Nr = T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr) AND (T_Antraege_Detail.Antrag_Detail_Antrag_ID = T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID)) ON 
                         T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID) INNER JOIN
                         T_Massnahmen_Projekttraeger ON T_Massnahmen.Massnahme_ID = T_Massnahmen_Projekttraeger.Massn_Projekttr_Massnahme_ID) ON 
                         T_Projekttraeger.Projekttraeger_ID = T_Massnahmen_Projekttraeger.Massn_Projekttr_Projekttraeger_ID
WHERE        (((T_Massnahmen.Massnahme_Monitoring) = 1) AND ((T_Massnahmen.Massnahme_Monitoring_abgeschlossen) = 0) AND ((T_Antraege.Antrag_Abgeschlossen) = 0) AND ((T_Massnahmen.Massnahme_Abschluss_gemeldet) 
                         = 0));
GO
/****** Object:  View [dbo].[S_Projekttraeger]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Projekttraeger]
AS
SELECT T_Massnahmen_Projekttraeger.Massn_Projekttr_Massnahme_ID AS Massnahme_ID, T_Projekttraeger.Projekttraeger_ID, IIf([T_Massnahmen_Projekttraeger].[Massn_Projekttr_Projekttraeger_ID] > 0, 
                  [T_Projekttraeger].[Projekttraeger_Name] + IIf([T_Projekttraeger].[Projekttraeger_Ort] > '', ', ' + [T_Projekttraeger].[Projekttraeger_Ort], ''), '') AS Projekttraeger
FROM     T_Projekttraeger INNER JOIN
                  T_Massnahmen_Projekttraeger ON T_Projekttraeger.Projekttraeger_ID = T_Massnahmen_Projekttraeger.Massn_Projekttr_Projekttraeger_ID;
GO
/****** Object:  View [dbo].[S_Sachbericht]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Sachbericht]
AS
SELECT T_Antragsteller.Antragsteller_ID, T_Antraege_Detail.Antrag_Detail_Antrag_ID, T_Antraege_Detail.Antrag_Detail_lfd_Nr, T_Antragsteller.Antragsteller_Kuerzel, T_Antraege.Antrag_Jahr AS Programm_Jahr, IIf([Antrag_Jahr]<'2015','Ausbildungsbudget','Ausbildungs- und Qualifizierungsbudget') + ' ' + [Antrag_Jahr] AS Programm, T_Gebietskoerperschaften.Gebietskoerp_Bezeichnung AS Antragsteller, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Plz, T_Antragsteller.Antragsteller_Ort
FROM (T_Gebietskoerperschaften LEFT JOIN (T_Antragsteller LEFT JOIN T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) ON T_Gebietskoerperschaften.Gebietskoerp_Kuerzel = T_Antragsteller.Antragsteller_Kuerzel) LEFT JOIN T_Antraege_Detail ON T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID;

GO
/****** Object:  View [dbo].[S_Schreiben]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Schreiben]
AS
SELECT T_Antragsteller.Antragsteller_ID, T_Antraege_Detail.Antrag_Detail_Antrag_ID, T_Antraege_Detail.Antrag_Detail_lfd_Nr, T_Antragsteller.Antragsteller_Anschreiben_Name_1 AS Antragsteller_Name1, 
                  T_Antragsteller.Antragsteller_Anschreiben_Name_2 AS Antragsteller_Name2, T_Antragsteller.Antragsteller_Strasse, T_Antragsteller.Antragsteller_Ort, T_Antragsteller.Antragsteller_Plz, T_Ansprechpartner.Ansprechp_ID, 
                  IIf([Ansprechp_Titel] > '', [Ansprechp_Titel] + ' ', '') + IIf([Ansprechp_Vorname] > '', [Ansprechp_Vorname] + ' ', IIf([Ansprechp_Anrede] > '', [Ansprechp_Anrede], '')) + [Ansprechp_Nachname] AS Ansprechp_Name, IIf([Ansprechp_Anrede] > '', 
                  IIf([Ansprechp_Anrede] = 'Herr', 'Sehr geehrter Herr ', 'Sehr geehrte Frau ') + IIf([Ansprechp_Titel] > '', [Ansprechp_Titel] + ' ', '') + [Ansprechp_Nachname], 'Sehr geehrte Damen und Herren') AS Ansprechp_Briefanrede, 
                  'AQB' + RIGHT([T_Antraege].[Antrag_Jahr], 2) + '-' + [Antragsteller_Kuerzel] AS Aktenzeichen, T_Antraege.Antrag_Jahr AS Programm_Jahr, LTrim(RTrim(IIf([Sachb_Vorname] > '', [Sachb_Vorname], IIf([Sachb_Anrede] > '', [Sachb_Anrede], 
                  '')) + ' ' + [Sachb_Nachname])) AS Sachbearbeiter, T_Sachbearbeiter.Sachb_Telefon, T_Sachbearbeiter.Sachb_Fax, T_Sachbearbeiter.Sachb_E_Mail, T_Hausadressen.Hausadresse_Internet AS Haus_Internet, 
                  [Hausadresse_Strasse] + ', ' + [Hausadresse_Plz] + ' ' + [Hausadresse_Ort] AS Haus_Besucheranschrift, IIf(IsDate([Antrag_Durchfuehrungszeitraum_Beginn]) = 1, Format([Antrag_Durchfuehrungszeitraum_Beginn], 'dd/ MMMM yyyy'), Null) 
                  AS Durchfuehrung_Beginn, IIf(IsDate([Antrag_Durchfuehrungszeitraum_Ende]) = 1, Format([Antrag_Durchfuehrungszeitraum_Ende], 'dd/ MMMM yyyy'), Null) AS Durchfuehrung_Ende, IIf(IsDate([Antrag_Detail_Antragsdatum]) = 1, 
                  Format([Antrag_Detail_Antragsdatum], 'dd/ MMMM yyyy'), Null) AS Antragsdatum, T_Antraege_Detail.Antrag_Detail_Zuwendungsbescheid_Datum AS Zuwendungsbescheid_Datum, 
                  T_Antraege_Detail.Antrag_Detail_Aenderungsbescheid_Datum AS Aenderungsbescheid_Datum
FROM     ((T_Antragsteller INNER JOIN
                  T_Antraege ON T_Antragsteller.Antragsteller_ID = T_Antraege.Antrag_Antragsteller_ID) INNER JOIN
                  (T_Hausadressen RIGHT JOIN
                  (T_Sachbearbeiter RIGHT JOIN
                  T_Antraege_Detail ON T_Sachbearbeiter.Sachb_ID = T_Antraege_Detail.Antrag_Detail_Sachb_ID) ON T_Hausadressen.Hausadresse_ID = T_Sachbearbeiter.Sachb_Hausadresse_ID) ON 
                  T_Antraege.Antrag_ID = T_Antraege_Detail.Antrag_Detail_Antrag_ID) INNER JOIN
                  T_Ansprechpartner ON T_Antragsteller.Antragsteller_ID = T_Ansprechpartner.Ansprechp_Antragsteller_ID
WHERE  T_Ansprechpartner.Ansprechp_Anschreiben = 1;
GO
/****** Object:  View [dbo].[S_Schreiben_Einzelmassnahmen]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Schreiben_Einzelmassnahmen]
AS
SELECT dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_Antrag_ID, dbo.T_Massnahmen.Massnahme_Antrag_Detail_lfd_Nr, dbo.T_Massnahmen.Massnahme_Aktenzeichen, 
                  dbo.T_Massnahmen.Massnahme_Massnahmeart_ID, Format(dbo.T_Massnahmen.Massnahme_Nr, '00') AS Massnahme_Nr, dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.T_Massnahmearten.Massnahmeart_Bezeichnung, 
                  dbo.T_Massnahmenziele.Massn_Ziel_Bezeichnung AS Massnahme_Ziel_Bezeichnung, dbo.T_Zielgruppen.Zielgruppe_Bezeichnung AS Massnahme_Zielgruppe_Bezeichnung, dbo.T_Massnahmen.Massnahme_Beginn, 
                  dbo.T_Massnahmen.Massnahme_Ende
FROM     dbo.T_Massnahmearten RIGHT OUTER JOIN
                  dbo.T_Massnahmenziele RIGHT OUTER JOIN
                  dbo.T_Zielgruppen RIGHT OUTER JOIN
                  dbo.T_Massnahmen ON dbo.T_Zielgruppen.Zielgruppe_ID = dbo.T_Massnahmen.Massnahme_Zielgruppe_ID ON dbo.T_Massnahmenziele.Massn_Ziel_ID = dbo.T_Massnahmen.Massnahme_Massn_Ziel_ID ON 
                  dbo.T_Massnahmearten.Massnahmeart_ID = dbo.T_Massnahmen.Massnahme_Massnahmeart_ID
GO
/****** Object:  View [dbo].[S_Teilnehmendenmonitoring_Verbleib]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Teilnehmendenmonitoring_Verbleib]
AS
SELECT '20' + SUBSTRING(dbo.T_Massnahmen.Massnahme_Aktenzeichen, 4, 2) AS Jahr, dbo.T_Verbleib.Verbleib_ID, dbo.T_Verbleib.Verbleib_Text AS Verbleib, COUNT(dbo.T_Teilnehmer_Monitoring.Teiln_Teilnehmer_ID) AS Anzahl
FROM     dbo.T_Verbleib INNER JOIN
                  dbo.T_Massnahmen INNER JOIN
                  dbo.T_Teilnehmer_Monitoring ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Teilnehmer_Monitoring.Teiln_Massnahme_ID ON dbo.T_Verbleib.Verbleib_ID = dbo.T_Teilnehmer_Monitoring.Teiln_Verbleib_ID
GROUP BY '20' + SUBSTRING(dbo.T_Massnahmen.Massnahme_Aktenzeichen, 4, 2), dbo.T_Verbleib.Verbleib_ID, dbo.T_Verbleib.Verbleib_Text
GO
/****** Object:  View [dbo].[S_Teilnehmer]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Teilnehmer]
AS
SELECT dbo.T_Massnahmen.Massnahme_ID, dbo.T_Massnahmen.Massnahme_Aktenzeichen, dbo.T_Massnahmen.Massnahme_Bezeichnung, dbo.T_Teilnehmer_Monitoring.Teiln_Massnahme_ID, 
                  dbo.T_Teilnehmer_Monitoring.Teiln_Projekttraeger, dbo.T_Teilnehmer_Monitoring.Teiln_Projekttraeger_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Teilnehmer_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Wohnort_Kreiskennzeichen, 
                  dbo.T_Teilnehmer_Monitoring.Teiln_Geschlecht, dbo.T_Teilnehmer_Monitoring.Teiln_Geburtsdatum, dbo.T_Teilnehmer_Monitoring.Teiln_Staatsangeh_Schluessel, dbo.T_Teilnehmer_Monitoring.Teiln_Migrationshintergrund, 
                  dbo.T_Teilnehmer_Monitoring.Teiln_Schwerbehinderung, dbo.T_Teilnehmer_Monitoring.Teiln_Eintrittsdatum, dbo.T_Teilnehmer_Monitoring.Teiln_Bildungsstand_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Schulbesuch_ID, 
                  dbo.T_Teilnehmer_Monitoring.Teiln_Arbeitslosmeld_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Erwerbstaetigkeit_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Leistungsbezug_SGB_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Haushaltssituation_ID, 
                  dbo.T_Teilnehmer_Monitoring.Teiln_Austrittsdatum, dbo.T_Teilnehmer_Monitoring.Teiln_Verbleib_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Austrittsgrund_ID, dbo.T_Teilnehmer_Monitoring.Teiln_Pruefung_bestanden, 
                  dbo.T_Teilnehmer_Monitoring.Teiln_Erfasser, dbo.T_Teilnehmer_Monitoring.Teiln_Erfassungsdatum, dbo.T_Teilnehmer_Monitoring.Teiln_Geaendert_von, dbo.T_Teilnehmer_Monitoring.Teiln_Aenderungsdatum
FROM     dbo.T_Massnahmen INNER JOIN
                  dbo.T_Teilnehmer_Monitoring ON dbo.T_Massnahmen.Massnahme_ID = dbo.T_Teilnehmer_Monitoring.Teiln_Massnahme_ID
GO
/****** Object:  View [dbo].[S_Teilnehmer_Monitoring]    Script Date: 11.09.2024 10:57:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[S_Teilnehmer_Monitoring]
AS
SELECT T_Teilnehmer_Monitoring.Teiln_Massnahme_ID, 
T_Massnahmen.Massnahme_Aktenzeichen, 
T_Teilnehmer_Monitoring.Teiln_Teilnehmer_ID, 
[T_Wohnorte].[Wohnort_Kreiskennzeichen] + ' - ' + [T_Wohnorte].[Wohnort_Bezeichnung] AS Wohnort_Bezeichnung, 
IIf([T_Teilnehmer_Monitoring].[Teiln_Geschlecht]='m','männlich',IIf([T_Teilnehmer_Monitoring].[Teiln_Geschlecht]='w','weiblich',IIf([T_Teilnehmer_Monitoring].[Teiln_Geschlecht]='d','divers',''))) AS Teiln_Geschlecht, 
T_Teilnehmer_Monitoring.Teiln_Geburtsdatum, 
T_Staatsangehoerigkeiten.Staatsangeh_Bezeichnung, 
T_Teilnehmer_Monitoring.Teiln_Migrationshintergrund, 
T_Teilnehmer_Monitoring.Teiln_Schwerbehinderung, 
T_Teilnehmer_Monitoring.Teiln_Eintrittsdatum, 
T_Bildungsstand.Bildungsstand_Text, 
T_Schulbesuch.Schulbesuch_Text, 
T_Arbeitslosmeldung.Arbeitslosmeld_Text, 
T_Erwerbstaetigkeit.Erwerbstaetigkeit_Text, 
T_Leistungsbezug_SGB.Leistungsbezug_Text, 
T_Haushaltssituation.Haushaltssituation_Text, 
T_Teilnehmer_Monitoring.Teiln_Austrittsdatum, 
T_Verbleib.Verbleib_Text, 
T_Austrittsgruende.Austrittsgrund_Bezeichnung, 
T_Teilnehmer_Monitoring.Teiln_Pruefung_bestanden, 
T_Teilnehmer_Monitoring.Teiln_Erfassungsdatum
FROM T_Wohnorte RIGHT JOIN (T_Staatsangehoerigkeiten RIGHT JOIN (T_Schulbesuch RIGHT JOIN (T_Leistungsbezug_SGB RIGHT JOIN (T_Haushaltssituation RIGHT JOIN (T_Erwerbstaetigkeit RIGHT JOIN (T_Bildungsstand RIGHT JOIN (T_Austrittsgruende RIGHT JOIN (T_Arbeitslosmeldung RIGHT JOIN (T_Massnahmen INNER JOIN (T_Verbleib RIGHT JOIN T_Teilnehmer_Monitoring ON T_Verbleib.Verbleib_ID = T_Teilnehmer_Monitoring.[Teiln_Verbleib_ID]) ON T_Massnahmen.Massnahme_ID = T_Teilnehmer_Monitoring.Teiln_Massnahme_ID) ON T_Arbeitslosmeldung.Arbeitslosmeld_ID = T_Teilnehmer_Monitoring.Teiln_Arbeitslosmeld_ID) ON T_Austrittsgruende.Austrittsgrund_ID = T_Teilnehmer_Monitoring.Teiln_Austrittsgrund_ID) ON T_Bildungsstand.Bildungsstand_ID = T_Teilnehmer_Monitoring.Teiln_Bildungsstand_ID) ON T_Erwerbstaetigkeit.Erwerbstaetigkeit_ID = T_Teilnehmer_Monitoring.Teiln_Erwerbstaetigkeit_ID) ON T_Haushaltssituation.Haushaltssituation_ID = T_Teilnehmer_Monitoring.Teiln_Haushaltssituation_ID) ON T_Leistungsbezug_SGB.Leistungsbezug_ID = T_Teilnehmer_Monitoring.Teiln_Leistungsbezug_SGB_ID) ON T_Schulbesuch.Schulbesuch_ID = T_Teilnehmer_Monitoring.Teiln_Schulbesuch_ID) ON T_Staatsangehoerigkeiten.Staatsangeh_Schluessel = T_Teilnehmer_Monitoring.Teiln_Staatsangeh_Schluessel) ON T_Wohnorte.Wohnort_Kreiskennzeichen = T_Teilnehmer_Monitoring.Teiln_Wohnort_Kreiskennzeichen;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 351
               Bottom = 136
               Right = 655
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 6
               Left = 693
               Bottom = 136
               Right = 1015
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 341
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Alle_Aktenzeichen_eines_Antragstellers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Alle_Aktenzeichen_eines_Antragstellers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 309
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 347
               Bottom = 136
               Right = 651
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 6
               Left = 689
               Bottom = 136
               Right = 1011
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Alle_Antraege_Massnahmearten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Alle_Antraege_Massnahmearten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Antraege'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Antraege'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Antraege_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Antraege_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Anzahl_Plaetze_Teilnehmer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Anzahl_Plaetze_Teilnehmer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Teilnehmer_Monitoring"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Anzahl_Teilnehmer_aktuell'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Anzahl_Teilnehmer_aktuell'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Anzahl_Plaetze_und_Teilnehmer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Anzahl_Plaetze_und_Teilnehmer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Auszahlungen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Auszahlungen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Haushalt_Auszahlungen"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 343
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Auszahlungen_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Auszahlungen_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 6
               Left = 395
               Bottom = 136
               Right = 702
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Kofinanzierung_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Kofinanzierung_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "S_Auswertung_Landesmittel_UA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 350
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 3480
         Alias = 3975
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Landesmittel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Landesmittel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Finanzierungsplan"
            Begin Extent = 
               Top = 6
               Left = 395
               Bottom = 136
               Right = 763
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Landesmittel_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Landesmittel_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Landesmittel_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Landesmittel_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 329
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 367
               Bottom = 136
               Right = 687
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 171
               Left = 0
               Bottom = 301
               Right = 338
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 179
               Left = 395
               Bottom = 309
               Right = 714
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Finanzierungsplan"
            Begin Extent = 
               Top = 205
               Left = 767
               Bottom = 335
               Right = 1135
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Auswertung_Massnahmen_UA"
            Begin Extent = 
               Top = 6
               Left = 765
               Bottom = 193
               Right = 1003
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'  Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[23] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Teilnehmer_Monitoring"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 300
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 162
               Left = 0
               Bottom = 292
               Right = 303
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Austrittsgruende"
            Begin Extent = 
               Top = 7
               Left = 611
               Bottom = 146
               Right = 880
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Verbleib"
            Begin Extent = 
               Top = 6
               Left = 338
               Bottom = 136
               Right = 574
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2475
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Massnahmen_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Massnahmen_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -384
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Verteilung_Landesmittel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Verteilung_Landesmittel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 358
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Verteilung_Landesmittel"
            Begin Extent = 
               Top = 6
               Left = 396
               Bottom = 136
               Right = 735
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Verteilung_Landesmittel_letzter_Stand"
            Begin Extent = 
               Top = 6
               Left = 773
               Bottom = 102
               Right = 1020
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Verteilung_Landesmittel_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auswertung_Verteilung_Landesmittel_Gesamt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 351
               Bottom = 136
               Right = 655
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Auszahlungen"
            Begin Extent = 
               Top = 6
               Left = 693
               Bottom = 136
               Right = 982
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Auswertung_Auszahlungen_Gesamt"
            Begin Extent = 
               Top = 6
               Left = 1020
               Bottom = 102
               Right = 1259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3495
         Alias = 2535
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auszahlungen_Kontierungsbeleg_Anlage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Auszahlungen_Kontierungsbeleg_Anlage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Checkliste'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Checkliste'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[22] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 325
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 6
               Left = 363
               Bottom = 136
               Right = 654
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 692
               Bottom = 136
               Right = 1012
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 376
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 138
               Left = 414
               Bottom = 268
               Right = 733
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 138
               Left = 771
               Bottom = 268
               Right = 1078
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA"
            Begin Extent = 
               Top = 270
               Left = 38
           ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Excel_Finanzierungsplan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Bottom = 400
               Right = 342
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Excel_Finanzierungsplan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Excel_Finanzierungsplan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 329
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 6
               Left = 367
               Bottom = 136
               Right = 687
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Auswertung_Auszahlungen_Gesamt"
            Begin Extent = 
               Top = 6
               Left = 725
               Bottom = 102
               Right = 980
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 102
               Left = 725
               Bottom = 232
               Right = 1063
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Auswertung_Landesmittel_Gesamt"
            Begin Extent = 
               Top = 138
               Left = 395
               Bottom = 251
               Right = 697
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Foerdermittel"
            Begin Extent = 
               Top = 234
               Left = 735
               Bottom' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Excel_Kofinanzierung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 364
               Right = 1015
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 252
               Left = 395
               Bottom = 382
               Right = 702
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Excel_Kofinanzierung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Excel_Kofinanzierung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 367
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 7
               Left = 415
               Bottom = 170
               Right = 776
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 7
               Left = 824
               Bottom = 170
               Right = 1184
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Finanzierungsplan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Finanzierungsplan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "S_Hauptansprechpartner_UA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Hauptansprechpartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Hauptansprechpartner'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Ansprechpartner"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Hauptansprechpartner_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Hauptansprechpartner_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierung_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierung_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 325
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 6
               Left = 363
               Bottom = 136
               Right = 701
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 6
               Left = 739
               Bottom = 136
               Right = 1058
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA"
            Begin Extent = 
               Top = 138
               Left = 383
               Bottom = 268
               Right = 687
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Einzelmassnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Einzelmassnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Einzelmassnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "S_Haushalt_Finanzierungsplan_Massnahmen_UA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 306
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 6
               Left = 344
               Bottom = 136
               Right = 663
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 6
               Left = 701
               Bottom = 136
               Right = 988
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Massnahmen_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Finanzierungsplan_Massnahmen_UA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Kofinanzierung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Kofinanzierung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Verteilung_Landesmittel_Antrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Haushalt_Verteilung_Landesmittel_Antrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_LIste_Antraege'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_LIste_Antraege'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Liste_Antraege_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Liste_Antraege_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Regierungsbezirke"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 321
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Gebietskoerperschaften"
            Begin Extent = 
               Top = 6
               Left = 359
               Bottom = 136
               Right = 640
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 6
               Left = 678
               Bottom = 136
               Right = 953
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Liste_Antragsteller'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Liste_Antragsteller'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[27] 2[25] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Liste_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Liste_Massnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 425
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahme_Aktenzeichen_letzter_Antrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahme_Aktenzeichen_letzter_Antrag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahmen_exportieren'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahmen_exportieren'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[11] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 383
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antragsteller"
            Begin Extent = 
               Top = 7
               Left = 431
               Bottom = 170
               Right = 774
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege"
            Begin Extent = 
               Top = 7
               Left = 822
               Bottom = 170
               Right = 1198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Antraege_Detail"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 338
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmenziele"
            Begin Extent = 
               Top = 175
               Left = 498
               Bottom = 338
               Right = 809
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Zielgruppen"
            Begin Extent = 
               Top = 175
               Left = 857
               Bottom = 338
               Right = 1169
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 343
               Left = 48
               Bottom = 506
               Right = 42' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahmen_fuer_Zielvereinbarung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'5
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Haushalt_Kofinanzierung"
            Begin Extent = 
               Top = 343
               Left = 473
               Bottom = 506
               Right = 834
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "S_Haushalt_Finanzierungsplan_Einzelmassnahmen_UA"
            Begin Extent = 
               Top = 343
               Left = 882
               Bottom = 506
               Right = 1238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 4200
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahmen_fuer_Zielvereinbarung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Massnahmen_fuer_Zielvereinbarung'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Projekttraeger'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Projekttraeger'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Sachbericht'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Sachbericht'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Belege'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Belege'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[24] 2[38] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Bescheid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Bescheid'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[21] 2[41] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Daten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Daten'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmearten"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 367
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmenziele"
            Begin Extent = 
               Top = 7
               Left = 415
               Bottom = 170
               Right = 710
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Zielgruppen"
            Begin Extent = 
               Top = 7
               Left = 758
               Bottom = 170
               Right = 1054
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 7
               Left = 1102
               Bottom = 170
               Right = 1463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Einzelmassnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Schreiben_Einzelmassnahmen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Verbleib"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 343
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 7
               Left = 391
               Bottom = 170
               Right = 768
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Teilnehmer_Monitoring"
            Begin Extent = 
               Top = 7
               Left = 816
               Bottom = 170
               Right = 1142
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Teilnehmendenmonitoring_Verbleib'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Teilnehmendenmonitoring_Verbleib'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Massnahmen"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T_Teilnehmer_Monitoring"
            Begin Extent = 
               Top = 7
               Left = 457
               Bottom = 170
               Right = 767
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Teilnehmer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Teilnehmer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Teilnehmer_Monitoring'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Teilnehmer_Monitoring'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T_Haushalt_Verteilung_Landesmittel"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 377
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Verteilung_Landesmittel_letzter_Stand'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'S_Verteilung_Landesmittel_letzter_Stand'
GO

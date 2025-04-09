<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://civento.net" exclude-result-prefixes="xs fn" version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes" />

    <xsl:variable name="ID" as="xs:integer">715003302631000</xsl:variable>
    <xsl:template match="/">
    <xsl:variable name="DMName" select="/Metadatendefinition/Objekt/@Name" />
    <xsl:variable name="Liste" select="/Metadatendefinition/Objekt/Metadatenliste[@Name = 'Massnahme']/@Name" />
    
    <SequenzielleListe Id="150003302631000">
    <Comment>Maßnahmen Vergleiche</Comment>
    <Active>true</Active>
        <xsl:for-each select="//Metadatenfeld">
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="Verweis" select="." />
        <xsl:variable name="IDinner" as="xs:integer">150013302631000</xsl:variable>
        <xsl:variable name="IDSeq" as="xs:integer">1500003302631000</xsl:variable>
        <xsl:variable name="IDSeqVar" as="xs:integer">1500013302631000</xsl:variable>
        <xsl:variable name="IDSeqWF" as="xs:integer">1500203302631000</xsl:variable>
        <xsl:variable name="IDinnerWF" as="xs:integer">15023302631000</xsl:variable>
        <xsl:variable name="IDinnerBefehl" as="xs:integer">15033302631000</xsl:variable>
        <xsl:variable name="Name" select="@Name" />
        <xsl:variable name="Titel" select="*/Titel/@Standard" />

        <xsl:if test="@Datentyp != 'ANLAGEN'">
            <Entscheidungselement>
                <xsl:attribute name="Id">
                    <xsl:value-of select="$ID + $pos" />
                </xsl:attribute>
                <Active>true</Active>
                <Entscheidungszweig>
                    <xsl:attribute name="Id">
                        <xsl:value-of select="$IDinner + $pos" />
                    </xsl:attribute>
                    <Comment><xsl:value-of select="$Name"/>"</Comment>
                    <Active>true</Active>
                    <Ausdruck>
                        <Ausdruck>Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>Alt, k, "<xsl:value-of select="$Name"/>") != Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>, i, "<xsl:value-of select="$Name"/>")</Ausdruck>
                    </Ausdruck>
                    <WorkflowvariableSetzen>
                    <xsl:attribute name="Id">
                            <xsl:value-of select="$IDinnerWF + $pos + 1" />
                        </xsl:attribute>
                        <Active>true</Active>
                        <Wert>Anzahl(V.Z.Logbuch.ListeMassnahme)</Wert>
                    <Workflowvariable Datentyp="INTEGER" Variablenname="ZaehlerLogbuch"/>
                    </WorkflowvariableSetzen>
                    <xsl:choose>
                        <xsl:when test="@Datentyp = 'PERSONENDATENSATZ'">
                            <SequenzielleListe>
                                <xsl:attribute name="Id">
                                    <xsl:value-of select="$IDSeq + $pos + 100" />
                                </xsl:attribute>
                                <Comment>Person Werte ziehen</Comment>
                                <Active>true</Active>
                                <DatenvariableSetzen>
                                    <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDSeqVar + $pos + 100" />
                                    </xsl:attribute>
                                    <Active>true</Active>
                                    <Ausdruck>
                                        <Ausdruck>Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>, i, "Projekttraeger")</Ausdruck>
                                    </Ausdruck>
                                    <Datenverweis>V.Z.Hilfsvariablen.TMPPerson</Datenverweis>
                                </DatenvariableSetzen>
                                <WorkflowvariableSetzen>
                                    <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDSeqWF + $pos + 100" />
                                    </xsl:attribute>
                                    <Active>true</Active>
                                    <Wert>castToString(V.Z.Hilfsvariablen.TMPPerson.Name) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Postleitzahl) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Ort) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Strasse) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Hausnummer) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Hausnummernzusatz)</Wert>
                                    <Workflowvariable Datentyp="STRING" Variablenname="PersonNeuWerte"/>
                                </WorkflowvariableSetzen>
                                  <WorkflowvariableSetzen>
                                    <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDSeqWF + $pos + 200" />
                                    </xsl:attribute>
                                    <Active>true</Active>
                                    <Wert>replaceString(PersonNeuWerte, "null", "") </Wert>
                                    <Workflowvariable Datentyp="STRING" Variablenname="PersonNeuWerte"/>
                                </WorkflowvariableSetzen>
                               <DatenvariableSetzen>
                                    <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDSeqVar + $pos + 200" />
                                    </xsl:attribute>
                                    <Active>true</Active>
                                    <Ausdruck>
                                        <Ausdruck>Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>Alt, k, "Projekttraeger")</Ausdruck>
                                    </Ausdruck>
                                    <Datenverweis>V.Z.Hilfsvariablen.TMPPerson</Datenverweis>
                                </DatenvariableSetzen>
                                 <WorkflowvariableSetzen>
                                    <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDSeqWF + $pos + 300" />
                                    </xsl:attribute>
                                    <Active>true</Active>
                                    <Wert>castToString(V.Z.Hilfsvariablen.TMPPerson.Name) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Postleitzahl) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Ort) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Strasse) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Hausnummer) + " " + castToString(V.Z.Hilfsvariablen.TMPPerson.Hausnummernzusatz)</Wert>
                                    <Workflowvariable Datentyp="STRING" Variablenname="PersonAltWerte"/>
                                </WorkflowvariableSetzen>
                                <WorkflowvariableSetzen>
                                    <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDSeqWF + $pos + 400" />
                                    </xsl:attribute>
                                    <Active>true</Active>
                                    <Wert>replaceString(PersonAltWerte, "null", "") </Wert>
                                    <Workflowvariable Datentyp="STRING" Variablenname="PersonAltWerte"/>
                                </WorkflowvariableSetzen>
                                <Expanded>true</Expanded>
                            </SequenzielleListe>
                            <BefehlAusfuehren>
                                <xsl:attribute name="Id">
                                    <xsl:value-of select="$IDinnerBefehl + $pos + 400" />
                                </xsl:attribute>
                                <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertAlt", PersonAltWerte, ZaehlerLogbuch)</Comment>
                                <Active>true</Active>
                                <Befehl>
                                    <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertAlt", PersonAltWerte, ZaehlerLogbuch)</Ausdruck>
                                </Befehl>
                            </BefehlAusfuehren>
                            <BefehlAusfuehren>
                                <xsl:attribute name="Id">
                                    <xsl:value-of select="$IDinnerBefehl + $pos + 500" />
                                </xsl:attribute>
                                <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertNeu", PersonNeuWerte, ZaehlerLogbuch)</Comment>
                                <Active>true</Active>
                                <Befehl>
                                    <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertNeu", PersonNeuWerte, ZaehlerLogbuch)</Ausdruck>
                                </Befehl>
                            </BefehlAusfuehren>
                        </xsl:when>
                        <xsl:otherwise>
                    <BefehlAusfuehren>
                        <xsl:attribute name="Id">
                            <xsl:value-of select="$IDinnerBefehl + $pos + 400" />
                        </xsl:attribute>
                        <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertAlt", castToString(Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>Alt, k, "<xsl:value-of select="$Name"/>")), ZaehlerLogbuch)</Comment>
                        <Active>true</Active>
                        <Befehl>
                            <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertAlt", castToString(Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>Alt, k, "<xsl:value-of select="$Name"/>")), ZaehlerLogbuch)</Ausdruck>
                        </Befehl>
                    </BefehlAusfuehren>
                    <BefehlAusfuehren>
                        <xsl:attribute name="Id">
                            <xsl:value-of select="$IDinnerBefehl + $pos + 500" />
                        </xsl:attribute>
                        <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertNeu", castToString(Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>, i, "<xsl:value-of select="$Name"/>")), ZaehlerLogbuch)</Comment>
                        <Active>true</Active>
                        <Befehl>
                            <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "WertNeu", castToString(Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>, i, "<xsl:value-of select="$Name"/>")), ZaehlerLogbuch)</Ausdruck>
                        </Befehl>
                    </BefehlAusfuehren>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="matches($Name, 'Jahr\d')">
                        <BefehlAusfuehren>
                                <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDinnerBefehl + $pos" />
                                </xsl:attribute>
                                <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Typ", finanziell, ZaehlerLogbuch)</Comment>
                                <Active>true</Active>
                                <Befehl>
                                    <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Typ", finanziell, ZaehlerLogbuch)</Ausdruck>
                                </Befehl>
                            </BefehlAusfuehren>
                        </xsl:when>                   
                        <xsl:otherwise>
                            <BefehlAusfuehren>
                                <xsl:attribute name="Id">
                                        <xsl:value-of select="$IDinnerBefehl + $pos + 100" />
                                </xsl:attribute>
                                <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Typ", inhaltlich, ZaehlerLogbuch)</Comment>
                                <Active>true</Active>
                                <Befehl>
                                    <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Typ", inhaltlich, ZaehlerLogbuch)</Ausdruck>
                                </Befehl>
                            </BefehlAusfuehren>
                        </xsl:otherwise>
                    </xsl:choose>
                    <WorkflowvariableSetzen>
                        <xsl:attribute name="Id">
                            <xsl:value-of select="$IDSeqWF + $pos + 999" />
                        </xsl:attribute>
                        <Active>true</Active>
                        <Wert>Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>, i, "Landesmittel") + " Jahr " + castToString(Listenelement(V.Z.<xsl:value-of select="$DMName"/>.<xsl:value-of select="$Liste"/>, i, "<xsl:value-of select="$Name"/>"))</Wert>
                        <Workflowvariable Datentyp="STRING" Variablenname="Spalte"/>
                    </WorkflowvariableSetzen>
                    <BefehlAusfuehren>
                        <xsl:attribute name="Id">
                            <xsl:value-of select="$IDinnerBefehl + $pos + 300" />
                        </xsl:attribute>
                    <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Spalte", Spalte, ZaehlerLogbuch) </Comment>
                        <Active>true</Active>
                        <Befehl>
                            <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Spalte", Spalte, ZaehlerLogbuch) </Ausdruck>
                        </Befehl>
                    </BefehlAusfuehren>
                    <BefehlAusfuehren>
                        <xsl:attribute name="Id">
                            <xsl:value-of select="$IDinnerBefehl + $pos + 600" />
                        </xsl:attribute>
                        <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "ArtAenderung", geändert, ZaehlerLogbuch)</Comment>
                        <Active>true</Active>
                        <Befehl>
                            <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "ArtAenderung", geändert, ZaehlerLogbuch)</Ausdruck>
                        </Befehl>
                    </BefehlAusfuehren>
                    <BefehlAusfuehren>
                        <xsl:attribute name="Id">
                            <xsl:value-of select="$IDinnerBefehl + $pos + 700" />
                        </xsl:attribute>
                        <Comment>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Datum", todayDate(), ZaehlerLogbuch)</Comment>
                        <Active>true</Active>
                        <Befehl>
                            <Ausdruck>ListenelementSetzen(V.Z.Logbuch.ListeMassnahme, "Datum", todayDate(), ZaehlerLogbuch)</Ausdruck>
                        </Befehl>
                    </BefehlAusfuehren>
                    <Expanded>false</Expanded>
                </Entscheidungszweig>
            <Expanded>true</Expanded>
            </Entscheidungselement>   
        </xsl:if>
        </xsl:for-each>
                               
            <Expanded>false</Expanded>
    </SequenzielleListe>
    </xsl:template>
</xsl:stylesheet>
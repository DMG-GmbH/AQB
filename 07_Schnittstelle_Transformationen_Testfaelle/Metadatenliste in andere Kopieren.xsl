<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://civento.net" exclude-result-prefixes="xs fn" version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes" />

    <xsl:variable name="ID" as="xs:integer">110003302631000</xsl:variable>

    <xsl:template match="/">

    <Schleife Id="771740937780100">
        <Comment>Backup für Freie Mittel erstellen für späteren Vergleich</Comment>
        <Active>true</Active>
        <Ausdruck>
            <Ausdruck>i &lt; Anzahl(V.Z.TMassnahmen.FreieMittel) </Ausdruck>
        </Ausdruck>
        <xsl:for-each select="//Metadatenfeld">
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="Verweis" select="." />
        <BefehlAusfuehren>
            <xsl:attribute name="Id">
                <xsl:value-of select="$ID + $pos" />
            </xsl:attribute>
            <Comment>ListenelementSetzen(V.Z.TMassnahmen.FreieMittelAlt, "<xsl:value-of select="@Name"/>",
                Listenelement(V.Z.TMassnahmen.FreieMittel, i, "<xsl:value-of select="@Name"/>"), i)</Comment>
            <Active>true</Active>
            <Befehl>
                <Ausdruck>ListenelementSetzen(V.Z.TMassnahmen.FreieMittelAlt, "<xsl:value-of select="@Name"/>",
                Listenelement(V.Z.TMassnahmen.FreieMittel, i, "<xsl:value-of select="@Name"/>"), i)</Ausdruck>
            </Befehl>
        </BefehlAusfuehren>
        </xsl:for-each>
        <NameDerZaehlervariable>i</NameDerZaehlervariable>
        <Expanded>false</Expanded>
    </Schleife>
    </xsl:template>
</xsl:stylesheet>
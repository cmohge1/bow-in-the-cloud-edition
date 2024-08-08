<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <!-- Output HTML -->
    <xsl:output method="html" indent="yes"/>
    
    <!-- Root template -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Bow in the Cloud: Personography</title>
            </head>
            <body>
                <h1>Bow in the Cloud: Personography</h1>
                <xsl:apply-templates select="//tei:listPerson"/>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template to process listPerson -->
    <xsl:template match="tei:listPerson">
        <xsl:apply-templates select="tei:person"/>
    </xsl:template>
    
    <!-- Template to process each person -->
    <xsl:template match="tei:person">
        <!-- Person's name as h2 -->
        <h2>
            <xsl:apply-templates select="tei:name"/>
        </h2>
        
        <!-- Person's details -->
        <p><strong>Name ID: </strong> <a href="{tei:name/@ref}" target="_blank"> <xsl:value-of select="tei:name/@ref"/></a></p>
        <p><strong>Born: </strong> <xsl:value-of select="tei:birth"/></p>
        <p><strong>Died: </strong> <xsl:value-of select="tei:death"/></p>
        <p><strong>Faith: </strong> <xsl:value-of select="tei:faith"/></p>
        <p><strong>Note: </strong> <xsl:value-of select="tei:note"/></p>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date">

  <xsl:param name="release"/>

  <xsl:variable name="path" select="concat('/',substring-before($release,'.'),'.',substring-before(substring-after($release,'.'),'.'),'/')"/>

  <xsl:variable name="test1" select="concat('dcache-',$release,'-')"/>
  <xsl:variable name="test2" select="concat('dcache-',$release,'.')"/>
  <xsl:variable name="test3" select="concat('dcache_',$release,'-')"/>

  <xsl:output method="text"/>

  <xsl:template match="d:href" xmlns:d="DAV:">
    <xsl:if test="contains(text(),$test1) or contains(text(),$test2) or contains(text(),$test3)">
      <xsl:value-of select="concat(substring-after(text(),$path),'&#x0a;')"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()"/>

</xsl:stylesheet>

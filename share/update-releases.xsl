<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date">

<!-- dCache version to release -->
<xsl:param name='version' select="'2.11.1'"/>
<xsl:param name='checksums-path' select="'.'"/>

<!-- Derived values -->
<xsl:variable name='bugfix'
	      select="substring-after(substring-after($version,'.'), '.')"/>
<xsl:variable name='series'
	      select="concat(substring-before($version, '.'),'.',substring-before(substring-after($version, '.'), '.'))"/>


<xsl:variable name="now" select="date:date-time()"/>

<!-- Date of release; looks like 6.11.2014 -->
<xsl:param name="date">
    <xsl:value-of select="concat(date:day-in-month($now), '.', date:month-in-year($now), '.', date:year($now))"/>
</xsl:param>

<xsl:variable name='prev-bugfix' select="/download-page/series/releases[version-prefix=concat($series,'.')]/release[1]/@version"/>

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>


<xsl:template match="checksum" mode="checksums">

    <xsl:variable name="name">
        <xsl:choose>
            <xsl:when test="@type='deb'">Debian package</xsl:when>
            <xsl:when test="@type='sol'">Solaris package</xsl:when>
            <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="filename">
        <xsl:choose>
            <xsl:when test="@type='deb' and ($series='2.6' or $series='2.7' or $series='2.8')">_VERSION_all.deb</xsl:when>
            <xsl:when test="@type='deb'">_VERSION-<xsl:value-of select="@pack"/>_all.deb</xsl:when>
            <xsl:when test="@type='tgz'">-VERSION.tar.gz</xsl:when>
            <xsl:when test="@type='rpm' and ($series='2.8' or $series='2.7' or $series='2.6')">-VERSION.noarch.rpm</xsl:when>
            <xsl:when test="@type='rpm'">-VERSION-<xsl:value-of select="@pack"/>.noarch.rpm</xsl:when>
            <xsl:when test="@type='sol'">-VERSION-<xsl:value-of select="@pack"/>.pkg</xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:text>        </xsl:text><package name="{$name}"><xsl:text>&#10;</xsl:text>
    <xsl:text>          </xsl:text><download-url><xsl:value-of select="$filename"/></download-url><xsl:text>&#10;</xsl:text>
    <xsl:text>          </xsl:text><md5sum><xsl:value-of select="text()"/></md5sum><xsl:text>&#10;</xsl:text>
    <xsl:text>        </xsl:text></package><xsl:text>&#10;</xsl:text>
</xsl:template>


<xsl:template name="emit-new-release">
    <xsl:variable name="checksum-filename" select="concat($checksums-path,'/checksums-',$series,'.xml')"/>

    <release version="{$bugfix}">
	<xsl:if test="$series='2.6' or $series='2.7' or $series='2.8'">
	    <xsl:attribute name="pack-version">-1</xsl:attribute>
	</xsl:if>
	<xsl:attribute name="recommended">1</xsl:attribute>
	<xsl:text>&#10;</xsl:text>
    <xsl:text>        </xsl:text><date><xsl:value-of select="$date"/></date><xsl:text>&#10;</xsl:text>
    <xsl:apply-templates mode="checksums" select="document($checksum-filename)/checksums/checksum"/>
    <xsl:text>      </xsl:text></release><xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>      </xsl:text>
</xsl:template>



<xsl:template match="releases">
    <xsl:choose>
        <xsl:when test="$bugfix='0' and version-prefix=concat($series,'.')">
	    <xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
	    <xsl:text>&#10;&#10;      </xsl:text>
            <xsl:call-template name="emit-new-release"/>
	</xsl:when>
	<xsl:otherwise>
	    <xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
	</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template match="release">
    <xsl:choose>
        <xsl:when test="@version=$prev-bugfix and ../version-prefix=concat($series,'.')">
            <xsl:call-template name="emit-new-release"/>
            <xsl:copy>
                <xsl:apply-templates select="@*|node()">
                    <xsl:with-param name="keep-recommended" select="false()"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template match="@recommended">
    <xsl:param name="keep-recommended" select="true()"/>

    <xsl:if test="$keep-recommended">
        <xsl:copy/>
    </xsl:if>
</xsl:template>

<xsl:template match="/">
    <xsl:apply-templates select="*"/>
</xsl:template>
</xsl:stylesheet>

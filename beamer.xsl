<?xml version="1.0"?>
<!-- SPDX-License-Identifier: CC0-1.0 -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8" indent="yes" doctype-public="" doctype-system="" />
	<xsl:template match="/">
		<xsl:text>\documentclass[fleqn]{beamer}</xsl:text>
		<xsl:text>\usepackage[final]{microtype}</xsl:text>
		<xsl:text>\usepackage{mathtools}</xsl:text>
		<xsl:text>\usepackage{xcolor,libertine}</xsl:text>
		<xsl:text>\hypersetup{colorlinks=true,linkcolor={blue!30!black}}</xsl:text>
		<xsl:text>\usepackage[mode=buildmissing]{standalone}</xsl:text>
		<xsl:text>\setlength{\parskip}{0.8\baselineskip}</xsl:text>
		<xsl:apply-templates select="/tree/frontmatter" mode="top" />
		<xsl:text>\begin{document}</xsl:text>
		<xsl:for-each select="//embedded-tex[not(ancestor::backmatter)]">
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>\begin{filecontents*}[overwrite]{</xsl:text>
			<xsl:value-of select="@hash" />
			<xsl:text>.tex}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>\documentclass[crop]{standalone}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:value-of select="embedded-tex-preamble"/>
			<xsl:text>\usepackage{newtxmath,newtxtext}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>\begin{document}</xsl:text>
			<xsl:value-of select="embedded-tex-body"/>
			<xsl:text>\end{document}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>\end{filecontents*}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
		<xsl:apply-templates select="/tree/backmatter/references" />
		<xsl:text>\frame{\titlepage}</xsl:text>
		<xsl:apply-templates select="/tree/mainmatter" />
		<!-- <xsl:text>\nocite{*}</xsl:text> -->
		<!-- <xsl:text>\bibliographystyle{plain}</xsl:text> -->
		<!-- <xsl:text>\bibliography{\jobname.bib}</xsl:text> -->
		<xsl:text>\end{document}</xsl:text>
	</xsl:template>
	<xsl:template match="/tree/backmatter/references">
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>\begin{filecontents*}[overwrite]{\jobname.bib}</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates select="tree/frontmatter/meta[@name='bibtex']" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>\end{filecontents*}</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<xsl:template match="frontmatter" mode="top">
		<xsl:text>\title{</xsl:text>
		<xsl:apply-templates select="title" />
		<xsl:text>}</xsl:text>
		<xsl:text>\author{</xsl:text>
		<xsl:for-each select="authors/author">
			<xsl:value-of select="."/>
			<xsl:if test="not(position()=last())">
				<xsl:text>\and{}</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="frontmatter" mode="frame">
		<xsl:apply-templates select="title" mode="frame"/>
	</xsl:template>
	<xsl:template match="title" mode="frame">
		<xsl:text>\frametitle{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="tree[frontmatter/taxon[text()='Slide']]">
		<xsl:text>\begin{frame}</xsl:text>
		<xsl:apply-templates select="frontmatter" mode="frame"/>
		<xsl:apply-templates select="mainmatter"/>
		<xsl:text>\end{frame}</xsl:text>
	</xsl:template>
	<xsl:template match="tree[frontmatter/taxon[text()='Proof']]">
		<xsl:text>\begin{proof}</xsl:text>
		<xsl:apply-templates select="mainmatter" />
		<xsl:text>\end{proof}</xsl:text>
	</xsl:template>
	<xsl:template match="mainmatter">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="p">
		<xsl:text>\par{}</xsl:text>
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="strong">
		<xsl:text>\textbf{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="pause">
		<xsl:text>\pause{}</xsl:text>
	</xsl:template>
	<xsl:template match="em">
		<xsl:text>\emph{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="tex[not(@display='block')]">
		<xsl:text>\(</xsl:text>
		<xsl:apply-templates />
		<xsl:text>\)</xsl:text>
	</xsl:template>
	<xsl:template match="tex[@display='block']">
		<xsl:text>\[</xsl:text>
		<xsl:apply-templates />
		<xsl:if test="parent::mainmatter/parent::tree/frontmatter/taxon[text()='Proof'] and position()=last()">
			<xsl:text>\qedhere</xsl:text>
		</xsl:if>
		<xsl:text>\]</xsl:text>
	</xsl:template>
	<xsl:template match="ol">
		<xsl:text>\begin{enumerate}</xsl:text>
		<xsl:apply-templates />
		<xsl:text>\end{enumerate}</xsl:text>
	</xsl:template>
	<xsl:template match="ul">
		<xsl:text>\begin{itemize}</xsl:text>
		<xsl:apply-templates />
		<xsl:text>\end{itemize}</xsl:text>
	</xsl:template>
	<xsl:template match="li">
		<xsl:text>\item{}</xsl:text>
		<xsl:apply-templates />
		<xsl:if test="(parent::ol/parent::mainmatter/parent::tree/frontmatter/taxon[text()='Proof'] or parent::ul/parent::mainmatter/parent::tree/frontmatter/taxon[text()='Proof']) and position()=last()">
			<xsl:text>\qedhere</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ref[@taxon]">
		<xsl:value-of select="@taxon" />
		<xsl:text>~</xsl:text>
		<xsl:text>\ref{</xsl:text>
		<xsl:value-of select="@addr" />
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="ref[not(@taxon)]">
		<xsl:text>\S~\ref{</xsl:text>
		<xsl:value-of select="@addr" />
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="link[@type='local']">
		<xsl:choose>
			<xsl:when test="//tree/frontmatter[addr/text()=current()/@addr and not(ancestor::backmatter)]">
				<xsl:text>\hyperref[</xsl:text>
				<xsl:value-of select="@addr" />
				<xsl:text>]{</xsl:text>
				<xsl:apply-templates />
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="/tree/backmatter/references/tree/frontmatter[addr/text()=current()/@addr]">
				<xsl:apply-templates />
			</xsl:when>
   <xsl:otherwise>
				<xsl:text>\hyperref[</xsl:text>
				<xsl:value-of select="@href" />
				<xsl:text>]{</xsl:text>
				<xsl:apply-templates />
				<xsl:text>}</xsl:text>
   </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="block">
		<xsl:text>\begin{proof}</xsl:text>
		<xsl:apply-templates />
		<xsl:text>\end{proof}</xsl:text>
	</xsl:template>
	<xsl:template match="headline" />
	<xsl:template match="embedded-tex">
		<xsl:text>\begin{center}</xsl:text>
		<xsl:text>\includestandalone{</xsl:text>
		<xsl:value-of select="@hash"/>
		<xsl:text>}</xsl:text>
		<xsl:text>\end{center}</xsl:text>
	</xsl:template>
</xsl:stylesheet>

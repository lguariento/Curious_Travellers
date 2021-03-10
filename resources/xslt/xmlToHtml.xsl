<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ct="www.curioustravellers.ac.uk/ns/namespace" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tei" version="3.0">
    <!-- <xsl:strip-space elements="*"/>-->
    <!--   <xsl:param name="ref"/>-->



    <!-- ignores the <supplied> element -->
    <!--    <xsl:template match="//tei:supplied"/>-->

    

    <!-- Order of execution -->
    <xsl:template match="tei:text/tei:body/tei:div">
        <xsl:apply-templates select="tei:opener/tei:dateline"/>
        <xsl:apply-templates select="tei:opener/tei:salute"/>
        <xsl:apply-templates select="tei:p[not(tei:stamp)][not(tei:address)][not(tei:postscript)]"/>
        <xsl:apply-templates select="tei:closer/tei:salute"/>
        <xsl:apply-templates select="tei:closer/tei:signed"/>
        <xsl:apply-templates select="tei:closer/tei:dateline"/>
        <xsl:apply-templates select="tei:postscript"/>
        <xsl:apply-templates select="tei:stamp"/>
    </xsl:template>
    <xsl:template match="tei:stamp">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <xsl:template match="tei:addrLine">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <xsl:function name="functx:month-name-en" as="xs:string?">
        <xsl:param name="date" as="xs:anyAtomicType?"/>

        <xsl:sequence select="('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')[month-from-date(xs:date($date))]"/>

    </xsl:function>

    <xsl:function name="functx:escape-for-regex" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>

        <xsl:sequence select="replace($arg, '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))', '\\$1')"/>

    </xsl:function>

    <xsl:function name="functx:contains-word" as="xs:boolean">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="word" as="xs:string"/>

        <xsl:sequence select="matches(upper-case($arg), concat('^(.*\W)?', upper-case(functx:escape-for-regex($word)), '(\W.*)?$'))"/>

    </xsl:function>


    <!-- substring-after-last custom function -->
    <xsl:function name="ct:substring-after-last" as="xs:string">
        <xsl:param name="value" as="xs:string?"/>
        <xsl:param name="separator" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($value, $separator)">
                <xsl:value-of select="ct:substring-after-last(substring-after($value, $separator), $separator)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!-- end of substring-after-last function -->
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="xs:integer(substring(tei:TEI/@xml:id, 3)) &gt; 0100">
                
                <xsl:choose>
                    <xsl:when test="//tei:correspAction[@type = 'sent']/tei:persName/@ref">
                        <xsl:variable name="refFrom" select="//tei:correspAction[@type = 'sent']/tei:persName/@ref"/>
                        <xsl:sequence select="doc('/db/apps/app-ct/data/indices/pedb.xml')//tei:person[@xml:id eq $refFrom]//tei:forename"/>
                        <xsl:text> </xsl:text>
                        <xsl:sequence select="doc('/db/apps/app-ct/data/indices/pedb.xml')//tei:person[@xml:id eq $refFrom]//tei:surname"/>
                        <xsl:if test="$refFrom='pe0333' or $refFrom='pe0803'">, </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        Unknown correspondent
                    </xsl:otherwise>
                </xsl:choose>
                
                to
                <xsl:variable name="refTo" select="//tei:correspAction[@type = 'received']/tei:persName/@ref"/>
                <xsl:sequence select="doc('/db/apps/app-ct/data/indices/pedb.xml')//tei:person[@xml:id eq $refTo]//tei:forename"/>
                <xsl:text> </xsl:text>
                <xsl:sequence select="doc('/db/apps/app-ct/data/indices/pedb.xml')//tei:person[@xml:id eq $refTo]//tei:surname"/>
                
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:copy-of select="//tei:fileDesc/tei:titleStmt/tei:title/node()[not(self::tei:date)]"/>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="date">
        <xsl:choose>
            <xsl:when test="//tei:correspAction[@type = 'sent']/tei:date/@when">
                <xsl:variable name="sentOn" select="//tei:correspAction[@type = 'sent']/tei:date/@when"/>
                <xsl:variable name="year" select="format-number(xs:integer(substring-before($sentOn, '-')), '0000')"/>
                <xsl:variable name="month" select="substring($sentOn, 6, 2)"/>
                <xsl:variable name="day" select="number(ct:substring-after-last($sentOn, '-'))"/>
                
                
                
                <xsl:value-of select="format-number($day, '0')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="functx:month-name-en(xs:date(//tei:correspAction[@type = 'sent']/tei:date/@when))"/>
                <xsl:text> </xsl:text>
                <xsl:variable select="(substring(tei:TEI/@xml:id, 3))" name="id"/>
                <xsl:choose>
                    
                    <xsl:when test="($id eq '1051') or ($id eq '1062') or ($id eq '1065')"> [<xsl:value-of select="$year"/>]</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$year"/>
                    </xsl:otherwise>
                    
                </xsl:choose>
                
                <!-- If there is a note within the <date> element, with a @when attribute set (for instance a tentative date), output that footnote's number -->
                <xsl:if test=".//tei:note">
                    <xsl:apply-templates select=".//tei:note/ancestor::tei:date"/>
                </xsl:if>
                
            </xsl:when>
            
            
            <xsl:when test="empty(//tei:correspAction[@type = 'sent']/tei:date/@when)">
                <!--                        
                        <xsl:text> (undated)</xsl:text>-->
                
                <xsl:choose>
                    <xsl:when test="//tei:correspAction[@type = 'sent']/tei:date = ''">
                        <xsl:text> date unknown</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="//tei:correspAction//tei:date"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
        </xsl:choose>
        
        <xsl:if test="not(//tei:correspAction[@type = 'sent']/tei:date) or (//tei:correspAction[@type = 'sent']/tei:date eq '')">
            
            
            <xsl:choose>
                <xsl:when test="//tei:TEI[@xml:id lt 'ct0100']"> </xsl:when>
                
            </xsl:choose>
            
            
        </xsl:if>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="(tei:TEI/@xml:id ne 'pedb') or (tei:TEI/@xml:id ne 'pldb') or (tei:TEI/@xml:id ne 'ardb') or (tei:TEI/@xml:id ne 'bidb')">
                <div class="page-header">

                    
                    
                    <!--<xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title"/>-->
                    
                    
                    <h3 align="center">
                    <xsl:value-of select="$title"/>
                    </h3>
                    <!-- This is the button loading the tour intro. It is handled by introtours.js, and loads and external .html named after the .xml id,
            which is grabbed via the parameter in the address bar -->
                    <div id="theIntro">
                        <h5 align="center">
                            <a data-toggle="collapse" href="#introTourCollapse" role="button" aria-expanded="false" aria-controls="introTourCollapse" class="collapsed btnIntro">Show the introduction to this tour</a>
                        </h5>
                        
                        <div class="collapse" id="introTourCollapse">
                            <div class="card card-body" id="introTour"> </div>
                        </div>
                    </div>
                    <hr/>
                    <!-- End of intro tours button and loaded section -->


                        
                    <h4 align="center">
                    <xsl:value-of select="$date"/>
                    </h4>


                </div>
                <div>
                    <div class="card">
                        <!--
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <h4 align="center">Metadata</h4>
                    </h3>
                </div>-->
                        <div class="card-body">
                            <table class="table table-condensed">
                                <tbody>
                                    <!--
                            <tr>
                                <th class="col-md-6" style="text-align:right;">
                                    <abbr>Document no.:</abbr>
                                    
                                </th>
                                <td class="col-md-6" style="text-align:left;">
                                    
                                    <xsl:value-of select="substring(tei:TEI/@xml:id, 3)"/>
                                    
                                </td>
                            </tr>-->
                                    <xsl:variable name="id" select="substring(tei:TEI/@xml:id, 3)"/>
                                    <tr>
                                        <th width="15%">
                                            <abbr>ID:</abbr>
                                        </th>
                                        <td>
                                            <xsl:value-of select="substring(tei:TEI/@xml:id, 3)"/>
                                            <xsl:text> </xsl:text> [<a href="/rest/{$id}.xml" target="_blank">see the .xml file</a>] </td>
                                    </tr>
                                    
                                    <xsl:if test="xs:integer(substring(tei:TEI/@xml:id, 3)) &gt; 0100">
                                        <!--<tr>
                                <th>
                                    <abbr>Details</abbr>
                                </th>
                                <td>
                                    
                                    <xsl:variable name="sentOn" select="//tei:correspAction[@type = 'sent']/tei:date/@when"/>
                                        <xsl:variable name="year" select="format-number(xs:integer(substring-before($sentOn, '-')), '0000')"/>
                                        <xsl:variable name="month" select="substring($sentOn, 6, 2)"/>
                                        <xsl:variable name="day" select="ct:substring-after-last($sentOn, '-')"/>
                                    <xsl:value-of select="//tei:correspAction[@type = 'sent']/tei:persName"/>
                                    to <xsl:value-of select="//tei:correspAction[@type = 'received']/tei:persName"/>
                                    <xsl:choose>
                                    <xsl:when test="//tei:correspAction[@type = 'sent']/tei:date/@when">
                                        <xsl:text>, </xsl:text>
                                    <xsl:value-of select="$day"/><xsl:text> </xsl:text><xsl:value-of select="functx:month-name-en(xs:date(//tei:correspAction[@type = 'sent']/tei:date/@when))"/><xsl:text> </xsl:text><xsl:value-of select="$year"/>
                                        <!-\- If there is a note within the <date> element, with a @when attribute set (for instance a tentative date), output that footnote's number -\->
                                        <xsl:if test=".//tei:note">
                                            <xsl:apply-templates select=".//tei:note/ancestor::tei:date"/>
                                        </xsl:if>
                                    </xsl:when>
                                        <xsl:when test="empty(//tei:correspAction[@type = 'sent']/tei:date/@when)">
                                            <xsl:text> </xsl:text>
                                            <xsl:apply-templates select="//tei:correspAction//tei:date"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> (undated)</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <br/>
                                    
                                </td>
                            </tr>-->
                                    </xsl:if>
                                    <xsl:if test="//tei:msIdentifier">
                                        <tr>
                                            <th width="15%">
                                                <abbr>Identifier:</abbr>
                                            </th>
                                            <td>
                                                <xsl:choose>
                                                  <xsl:when test="//tei:msIdentifier/tei:repository eq 'National Library of Wales'">
                                                  <xsl:text>NLW </xsl:text>
                                                  </xsl:when>

                                                  <xsl:when test="//tei:msIdentifier/tei:repository eq 'National Library of Scotland'">
                                                  <xsl:text>NLS </xsl:text>
                                                  </xsl:when>

                                                  <xsl:when test="//tei:msIdentifier/tei:repository eq 'Warwickshire County Record Office'">
                                                  <xsl:text>WCRO </xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="//tei:msIdentifier/tei:repository eq 'County Record Office'">
                                                  <xsl:text>WCRO </xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="//tei:msIdentifier/tei:repository"/>
                                                  <xsl:text> </xsl:text>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                                <!-- (<xsl:value-of select="//tei:msIdentifier/tei:settlement"/>) -->
                                                <xsl:value-of select="//tei:msIdentifier/tei:idno"/>
                                                <xsl:if test="//tei:msContents/tei:ab/tei:locus ne ''">,
                                                  <xsl:value-of select="//tei:msContents/tei:ab/tei:locus"/>
                                                </xsl:if>
                                            </td>

                                        </tr>
                                        
                                        <xsl:if test="//tei:msContents/tei:p">
                                            <tr>
                                                <th width="15%">
                                                    <abbr>Description:</abbr>
                                                </th>
                                                <td>
                                                    <xsl:for-each select="//tei:msContents/tei:p">
                                                        <xsl:apply-templates/>
                                                        <br/>
                                                    </xsl:for-each>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:msDesc/tei:additional">
                                            <tr>
                                                <th width="15%">
                                                  <abbr>Notes:</abbr>
                                                </th>
                                                <td>
                                                    <xsl:apply-templates select="//tei:msDesc/tei:additional"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:respStmt/tei:name">
                                            <tr>
                                                <th width="15%">
                                                  <abbr>Editors:</abbr>
                                                </th>
                                                <td>
                                                  <xsl:value-of select="//tei:respStmt/tei:name"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:profileDesc/tei:correspDesc/tei:correspContext">

                                            <tr>
                                                <th>
                                                  <abbr>Previous letter:</abbr>
                                                </th>
                                                <td>
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:profileDesc/tei:correspDesc/tei:correspContext/tei:ref[@type = 'prev']">
                                                  <xsl:variable name="prev" select="replace(//tei:correspContext/tei:ref[@type = 'prev']/@target, 'ct', '')"/>
                                                  <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                      <xsl:text>/doc/</xsl:text>
                                                      <xsl:value-of select="$prev"/>
                                                  <!--<xsl:text>show.html?document=</xsl:text>
                                                  <xsl:copy-of select="concat($prev, '.xml')"/> -->
                                                  </xsl:attribute>

                                                  <xsl:value-of select="$prev"/>

                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>Not supplied</xsl:otherwise>
                                                  </xsl:choose>
                                                </td>
                                            </tr>



                                            <tr>
                                                <th>
                                                  <abbr>Next letter:</abbr>
                                                </th>
                                                <td>
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:profileDesc/tei:correspDesc/tei:correspContext/tei:ref[@type = 'next']">
                                                  <xsl:variable name="next" select="replace(//tei:correspContext/tei:ref[@type = 'next']/@target, 'ct', '')"/>
                                                  <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                      <xsl:text>/doc/</xsl:text>
                                                      <xsl:value-of select="$next"/>
                                                  <!--<xsl:text>show.html?document=</xsl:text>
                                                  <xsl:copy-of select="concat($next, '.xml')"/>-->
                                                  </xsl:attribute>

                                                  <xsl:value-of select="$next"/>

                                                  </xsl:element>
                                                  </xsl:when>
                                                  <xsl:otherwise>Not supplied</xsl:otherwise>
                                                  </xsl:choose>
                                                </td>
                                            </tr>
                                        </xsl:if>

                                    </xsl:if>
                                    <xsl:if test="(//tei:TEI/@xml:id='ct0011') or (//tei:TEI/@xml:id='ct0030') or (//tei:TEI/@xml:id='ct0031') or (//tei:TEI/@xml:id='ct0032')">
                                        <tr>
                                            <th>All Catherine Hutton tours:</th>
                                            <td>
                                            <ul>
                                                <li>
                                                        <a href="/doc/0011">Catherine Hutton’s Tour of Wales: 1796</a>
                                                    </li>
                                                <li>
                                                        <a href="/doc/0030">Catherine Hutton’s Tour of Wales: 1797</a>
                                                    </li>
                                                <li>
                                                        <a href="/doc/0031">Catherine Hutton’s Tour of Wales: 1799</a>
                                                    </li>
                                                <li>
                                                        <a href="/doc/0032">Catherine Hutton’s Tour of Wales: 1800</a>
                                                    </li>
                                            </ul>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                        <tr>
                                            <th>Cite:</th>
                                            <xsl:variable name="respstmt" select="//tei:respStmt/tei:name"/>
                                            <xsl:variable name="cite">'<xsl:value-of select="$title"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$date"/>' <xsl:value-of select="lower-case(substring($respstmt, 1, 1)) || substring($respstmt, 2)"/> <xsl:text> in Curious Travellers Digital Editions [editions.curioustravellers.ac.uk/doc/</xsl:text>
                                            <xsl:value-of select="substring(tei:TEI/@xml:id, 3)"/>
                                            <xsl:text>]</xsl:text>
                                            </xsl:variable>
                                            <td>
                                            <xsl:value-of select="$cite"/>
                                                <button style="display:contents;" class="js-copy" data-clipboard-text="{$cite}">
                                                    <xsl:text> </xsl:text>
                                                <img class="clippy" src="https://clipboardjs.com/assets/images/clippy.svg" width="13"/>
                                                </button>
                                            
                                            </td>
                                            
                                        </tr>
                                </tbody>
                            </table>
                            <!--                    <div class="panel-footer">
                        <p style="text-align:center;">
                            <a id="link_to_source"/>
                        </p>-->
                            <!--</div>-->
                        </div>
                    </div>
                </div>

                <div id="XMLtoHTML" class="card">
                    <!--
            <div class="panel-heading">
                <h3 class="panel-title">
                    <h4 align="center">
                        Transcription
                    </h4>
                </h3>
            </div>-->
                    <div class="card-body" id="transcribed_text">

                        <xsl:choose>
                            <xsl:when test="//tei:div[@type = 'enclosed']">
                                <!--
                                    <xsl:if test="xs:integer(substring(tei:TEI/@xml:id, 3)) > 0100">-->

                                <h5 style="text-align: center;">Letter</h5>
                                <br/>
                                <xsl:apply-templates select="//tei:div[@type eq 'letter']"/>
                                <hr/>
                                <h5 style="text-align: center;">Enclosure</h5>
                                <br/>
                                <p>
                                    <xsl:apply-templates select="//tei:div[@type eq 'enclosed']/*"/>
                                </p>
                                <hr/>
                                <xsl:apply-templates select="//tei:div[not(@type)]/*"/>

                                <!--</xsl:if>-->
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:if test="//tei:div[@type eq 'other']">
                                    <xsl:apply-templates select="//tei:div[@type eq 'other']/*"/>
                                    <hr/>
                                </xsl:if>
                                <xsl:apply-templates select="//tei:div[not(@type)]"/>
                                <xsl:if test="//tei:addrLine">
                                    <hr/>
                                    <xsl:apply-templates select="//tei:addrLine"/>
                                </xsl:if>
                                <xsl:if test="//tei:stamp">
                                    <hr/>
                                    <xsl:apply-templates select="//tei:stamp"/>
                                </xsl:if>

                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="//tei:note[@type = 'authorial']">
                            <hr/>
                            <b>Authorial notes</b>
                            <br/>

                            <xsl:apply-templates select="//tei:note[@type = 'authorial']" mode="footnoteAuthorial"/>
                        </xsl:if>
                    </div>
                    <xsl:if test="//tei:body//tei:note or //tei:profileDesc//tei:note or //tei:physDesc/tei:additions">
                        <div class="card-body" id="footnotes">
                            <xsl:if test="//tei:physDesc/tei:additions">
                                <div class="row">
                                    <div class="col-md-12">

                                        <!--                        <xsl:choose>
                            <xsl:when test=".//tei:note">
                                <b>Marginalia:</b>
                                <xsl:apply-templates select=".//tei:note/ancestor::tei:additions"/>
                                <br/>
                            </xsl:when>
                            <xsl:otherwise>
                                <h5>Marginalia:
                                    <xsl:apply-templates select="//tei:physDesc/tei:additions"/></h5><br/>
                            </xsl:otherwise>
                            
                        </xsl:choose>-->

                                        <b>Marginalia</b>

                                        <xsl:apply-templates select="//tei:physDesc/tei:additions"/>
                                    </div>
                                </div>
                            </xsl:if>
                            <xsl:if test="//tei:body//tei:note[@type = 'editorial']">
                                <hr/>
                                <h5>Editorial notes</h5>
                            </xsl:if>
                            <xsl:if test="//tei:profileDesc//tei:note">

                                <xsl:apply-templates select="//tei:profileDesc//tei:note" mode="footnoteprofileDesc"/>
                                <br/>

                            </xsl:if>
                            <xsl:apply-templates select="//tei:body//tei:note[@type = 'editorial']" mode="footnote"/>

                            <xsl:if test="//tei:additions//tei:note">
                                <br/>
                                <!-- <xsl:element name="hr"/>
                            <h6>Notes to the marginalia</h6>-->
                                <xsl:apply-templates select="//tei:additions//tei:note" mode="footnoteHeader"/>
                            </xsl:if>
                        </div>

                        <!--<script type="text/javascript">
                // creates a link to the xml version of the current document available via eXist-db's REST-API
                var params={};
                window.location.search
                .replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str,key,value) {
                params[key] = value;
                }
                );
                var path = window.location.origin+window.location.pathname;
                var replaced = path.replace("exist/apps/", "exist/rest/db/apps/");
                current_html = window.location.pathname.substring(window.location.pathname.lastIndexOf("/") + 1)
                var source_document = replaced.replace("pages/"+current_html, "data/letters/"+params['document']);
                console.log(source_document)
                $( "#link_to_source" ).attr('href',source_document);
                $( "#link_to_source" ).text(source_document);
            </script>-->
                    </xsl:if>
                </div>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="./node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Places -->
    <xsl:template match="tei:placeName">
        
        <!--        <a href="https://editor.curioustravellers.ac.uk/pages/placeedit.html?searchkey={@ref}" target="_blank">
            <xsl:apply-templates/>
        </a>-->
        
        <a data-ref="{@ref}" href="#" id="open" data-toggle="modal" data-target="#modalDetails">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!-- Images -->

    <xsl:template match="tei:graphic">
        <div>
            <img style="max-width: 80%;" class="center-block img-rounded img-responsive" src="{@url}"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Artworks -->
    <xsl:template match="tei:rs">
        <a data-ref="{@ref}" href="#" id="open" data-toggle="modal" data-target="#modalDetails">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!-- People -->
    <xsl:strip-space elements="tei:persName"/>
    <xsl:template match="tei:persName">

        <xsl:choose>
            <!--            <xsl:when test="(contains(@ref, ' '))">
                <xsl:apply-templates/>
            </xsl:when>-->
            <!-- If persName is tagged within an artwork or book, don't link it -->

            <xsl:when test="ancestor::tei:rs or ancestor::tei:bibl">
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:otherwise>
                <!--                <a href="pershits.html?searchkey={@ref}">
                    <xsl:apply-templates/>
                </a>-->
                <a data-ref="{@ref}" href="#" id="open" data-toggle="modal" data-target="#modalDetails">
                    <xsl:apply-templates/>
                </a>




            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <xsl:text>[?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>


    <!-- Highlighting -->
    <xsl:template match="tei:hi[@rend = 'underline']" mode="#default deletion addition">
        <span style="text-decoration: underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']" mode="#default deletion addition">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'superscript']" mode="#default deletion addition">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'subscript']" mode="#default deletion addition">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>

    <!-- abbreviations -->


    <xsl:template match="tei:choice">

        <xsl:for-each select="tei:abbr">

            <xsl:apply-templates select="."/>

        </xsl:for-each>
        <xsl:for-each select="tei:expan">
            <xsl:if test="not(functx:contains-word('(Large Paper) affectionate (Henry Clinton) voyage videlicet (Nota Bene) said Chief from Lord Secretary Richard armour Church (Roger Mostyn) (Lord Chief Justice Glynne) Duke (Richard Henry) Ditto Captain August quarto account Earl January February March April May June July August September October (Your affectionate) reverend November December french octavo Thomas your yours Compliments would Peter supplement Servant (obedient Servant) page (Humble Servant) Esquire', .))">
                <xsl:text> [</xsl:text>
                <xsl:apply-templates select="."/>
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <!-- footnotes (see http://www.microhowto.info/howto/create_a_list_of_numbered_footnotes_using_xslt.html) -->


    <xsl:template match="//tei:body//tei:note">
        <a>
            <xsl:attribute name="name">
                <xsl:text>footnoteref</xsl:text>
                <xsl:number level="any" count="//tei:body//tei:note" format="1"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="//tei:body//tei:note" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="//tei:body//tei:note" format="1"/>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:note" mode="footnote">
        <br>
            <a>
                <xsl:attribute name="name">
                    <xsl:text>footnote</xsl:text>
                    <xsl:number level="any" count="//tei:body//tei:note" format="1"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#footnoteref</xsl:text>
                    <xsl:number level="any" count="//tei:body//tei:note" format="1"/>
                </xsl:attribute>
                <xsl:number level="any" count="//tei:body//tei:note" format="1"/>. </a>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <i>
                <xsl:value-of select="                         if (@type = 'editorial') then                             ''                         else                             ' [Authorial note]'"/>
            </i>
        </br>
    </xsl:template>

    <!-- Marginalia footnotes -->

    <xsl:template match="//tei:additions//tei:note">
        <a>
            <xsl:attribute name="name">
                <xsl:text>footnoteref</xsl:text>
                <xsl:number level="any" count="//tei:additions//tei:note" format="i"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="//tei:additions//tei:note" format="i"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="//tei:additions//tei:note" format="i"/>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:note" mode="footnoteHeader">
        <br>
            <a>
                <xsl:attribute name="name">
                    <xsl:text>footnote</xsl:text>
                    <xsl:number level="any" count="//tei:additions//tei:note" format="i"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#footnoteref</xsl:text>
                    <xsl:number level="any" count="//tei:additions//tei:note" format="i"/>
                </xsl:attribute>
                <xsl:number level="any" count="//tei:additions//tei:note" format="i"/>. </a>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <i>
                <xsl:value-of select="                         if (//tei:note/@type = 'editorial') then                             ''                         else                             ' [Authorial note]'"/>
            </i>
        </br>
    </xsl:template>

    <!-- Authorial notes -->

    <xsl:template match="//tei:note[@type = 'authorial']">
        <a>
            <xsl:attribute name="name">
                <xsl:text>footnoteref</xsl:text>
                <xsl:number level="any" count="//tei:note[@type = 'authorial']" format="i"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="//tei:note[@type = 'authorial']" format="i"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="//tei:note[@type = 'authorial']" format="i"/>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:note[@type = 'authorial']" mode="footnoteAuthorial">
        <br>
            <a>
                <xsl:attribute name="name">
                    <xsl:text>footnote</xsl:text>
                    <xsl:number level="any" count="//tei:note[@type = 'authorial']" format="i"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#footnoteref</xsl:text>
                    <xsl:number level="any" count="//tei:note[@type = 'authorial']" format="i"/>
                </xsl:attribute>
                <xsl:number level="any" count="//tei:note[@type = 'authorial']" format="i"/>. </a>
            <xsl:apply-templates/>
        </br>
    </xsl:template>

    <!-- profileDesc footnotes -->

    <xsl:template match="//tei:profileDesc//tei:note">
        <a>
            <xsl:attribute name="name">
                <xsl:text>footnoteref</xsl:text>
                <xsl:number level="any" count="//tei:profileDesc//tei:note" format="a"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="//tei:profileDesc//tei:note" format="a"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="//tei:profileDesc//tei:note" format="a"/>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:note" mode="footnoteprofileDesc">
        <br>
            <a>
                <xsl:attribute name="name">
                    <xsl:text>footnote</xsl:text>
                    <xsl:number level="any" count="//tei:profileDesc//tei:note" format="a"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#footnoteref</xsl:text>
                    <xsl:number level="any" count="//tei:profileDesc//tei:note" format="a"/>
                </xsl:attribute>
                <xsl:number level="any" count="//tei:profileDesc//tei:note" format="a"/>. </a>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <i>
                <xsl:value-of select="                         if (//tei:note/@type = 'editorial') then                             ''                         else                             ' [Authorial note]'"/>
            </i>
        </br>
    </xsl:template>

    <!-- opener dateline  -->
    <xsl:template match="tei:opener/tei:dateline">
        <p class="dateline">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- opener salute  -->

    <xsl:template match="tei:opener/tei:salute">
        <p class="opener">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- postscript -->
    <xsl:template match="tei:postscript">
        <!--            <i><xsl:text>[Postscript]</xsl:text></i>-->
        <xsl:apply-templates/>
    </xsl:template>

    <!--    <!-\- closer -\->
    <xsl:template match="tei:closer">
        <p class="closer">
            <xsl:apply-templates/>
        </p>
    </xsl:template>-->

    <!-- closer salute  -->
    <xsl:template match="tei:closer/tei:salute">
        <p class="closer">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- closer signed  -->
    <xsl:template match="tei:closer/tei:signed">
        <p class="closer">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- closer addrLine  -->
    <xsl:template match="tei:closer/tei:dateline">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- unclear -->
    <xsl:template match="tei:unclear">
        <span class="unclear">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- addrLine -->
    <xsl:template match="tei:addrLine">
        <div style="text-align: left;">
            <p>
                <xsl:apply-templates/>
                <br/>
            </p>
        </div>
    </xsl:template>

    <!-- reference -->
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="@type = 'http'">
                <a target="_blank" href="{@target}">
                    <xsl:apply-templates/>
                </a>
                <span style="font-size: smaller; font-style: normal;">
                    <xsl:text> [external link]</xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>

                <a href="/doc/{substring-before(@target, '.xml')}">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- stamp -->
    <xsl:template match="tei:stamp">
        <div style="text-align: left; padding-top: 10px;">
            <i>
                <xsl:text>[Stamp </xsl:text>
                <xsl:choose>


                    <xsl:when test="./@type">(<xsl:value-of select="./@type"/>)] </xsl:when>
                    <xsl:otherwise>] </xsl:otherwise>

                </xsl:choose>
            </i>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- resp -->
    <xsl:template match="tei:respStmt/tei:resp">
        <xsl:apply-templates/>  </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <!-- reference strings   -->
    <!--<xsl:template match="tei:rs[@ref or @key]">
        <i>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">
                    <xsl:value-of select="concat('list', data(@type), '.xml')"/>
                </xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </i>
    </xsl:template>-->

    <!-- gaps -->
    <xsl:template match="tei:gap">
        <xsl:text>[...]</xsl:text>
    </xsl:template>
    <!--    <xsl:template match="tei:gap">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>damage</xsl:text>
            </xsl:attribute>
        <xsl:text>[? </xsl:text><xsl:value-of select="./@quantity"/>
        <xsl:text> </xsl:text><xsl:value-of select="./@unit"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="./@reason"/>
        <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>-->

    <!-- lists -->

    <xsl:template match="tei:list">

        <ul>
            <xsl:for-each select="tei:item">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </ul>

    </xsl:template>

    <!-- verse lines -->

    <xsl:template match="tei:quote">
        <p>
            <xsl:for-each select="tei:l">
                <span style="margin-left: 2em;">
                    <xsl:apply-templates/>
                    <br/>
                </span>
            </xsl:for-each>
        </p>

    </xsl:template>

    <!-- additions -->
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>caretAdd</xsl:text>
            </xsl:attribute>
            <xsl:text>^</xsl:text>
        </xsl:element>

        <xsl:element name="span">

            <xsl:attribute name="class">
                <xsl:text>add</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@place = 'margin'">
                        <xsl:text>Text added </xsl:text>(<xsl:value-of select="./@place"/>). </xsl:when>
                    <xsl:when test="@place = 'above'">
                        <xsl:text>Text added </xsl:text>
                        <xsl:value-of select="./@place"/>
                    </xsl:when>
                    <xsl:when test="@place = 'below'">
                        <xsl:text>Text added </xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'inline'">
                        <xsl:text>Text added </xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'top'">
                        <xsl:text>Text added to the </xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:when test="@place = 'bottom'">
                        <xsl:text>Text added to the </xsl:text>(<xsl:value-of select="./@place"/>) </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Text added somewhere</xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:text/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Books -->
    <xsl:strip-space elements="tei:bibl"/>
    <xsl:template match="tei:bibl">
        
        <xsl:choose>

            <xsl:when test=".[@type eq 'editorial']">
                <a data-ref="{./tei:title/@ref}" href="#" id="open" data-toggle="modal" data-target="#modalDetails">
                    <i data-ref="{./tei:title/@ref}">
                        <xsl:apply-templates/>
                    </i>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a data-ref="{./tei:title/@ref}" href="#" id="open" data-toggle="modal" data-target="#modalDetails">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:sic">
        <xsl:apply-templates/>
        <xsl:text> [</xsl:text>
        <xsl:element name="i">sic</xsl:element>
        <xsl:text>]</xsl:text>
    </xsl:template>


    <!-- Seitenzahlen -->
    <xsl:template match="tei:pb">
        <!--        <xsl:element name="div">-->
        <!--<xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:text>-\-\-</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>-</xsl:text>-->
        <!--</xsl:element>-->
        <xsl:element name="hr"/>
    </xsl:template>
    <xsl:template match="tei:fw">
        <xsl:element name="p">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        <!--        <xsl:element name="hr"/>-->
    </xsl:template>
    <!-- Table -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:choose>
                <xsl:when test="@style = 'letter'">
                    <xsl:attribute name="class">
                        <xsl:text>table</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">
                        <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="tbody">
                <xsl:attribute name="style">
                    <xsl:text>float: left;</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:attribute name="class">
                <xsl:text>col-md-2</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@style = 'left'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:left;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@style = 'right'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:right;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@style = 'right_pad'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:right;</xsl:text>
                        <xsl:text>padding-right:1em;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@style = 'center'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:center;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>
    <!-- Überschriften -->
    <xsl:template match="tei:head">
        <xsl:element name="h3">
            <xsl:element name="a">
                <xsl:attribute name="id">
                    <xsl:text>text_</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#nav_</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:q">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--  Quotes -->

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- Line breaks    -->

    <xsl:template match="tei:ab">
        <xsl:choose>
            <xsl:when test="@style = 'indent'">
                <xsl:copy>
                    <xsl:attribute name="style">
                        <xsl:text>padding-left: 2em;</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="(@style = 'not_indent' or not(@style))">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>

    </xsl:template>
    <!-- Indented ab    -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:choose>
                <xsl:when test="@style = 'left'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:left;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@style = 'right'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:right;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@style = 'center'">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:center;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@style = 'indent'">
                    <xsl:attribute name="style">
                        <xsl:text>padding-left: 4em;</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Durchstreichungen -->
    <xsl:template match="tei:del">
        <xsl:element name="strike">
            <xsl:apply-templates/>
        </xsl:element>
        <!--        <xsl:text xml:space="preserve"> </xsl:text>-->

    </xsl:template>
    <xsl:template match="tei:w">
        <xsl:value-of select="./text()"/>
    </xsl:template>
</xsl:stylesheet>
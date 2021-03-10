xquery version "3.1";

module namespace app = "https://editions.curioustravellers.ac.uk/templates";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "https://editions.curioustravellers.ac.uk/config" at "config.xqm";
import module namespace tei2 = "http://exist-db.org/xquery/app/tei2html" at "tei2html.xql";
import module namespace functx = 'http://www.functx.com';
import module namespace kwic = "http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=html media-type=text/html";

declare function app:checkPresence($node as node(), $model as map(*), $searchkey as xs:string?)

{

    let $message :=
    for $hit in collection('/db/apps/ct_editions/data/documents/')//tei:TEI[.//tei:bibl[@ref = $searchkey]]
    return
        if ($hit = "") then
            ("No docs linked")
        else
            ()
    return
        $message

};

declare function local:get-id($xml-id as xs:string) as xs:integer {
    xs:integer(replace($xml-id, '[^0-9]+', ''))
};

declare function app:countLetters($node as node(), $model as map(*)) {

    let $count_letters := count(collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100])
    return
        $count_letters

};

declare function app:countTours($node as node(), $model as map(*)) {

    let $count_tours := count(collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) < 0100])
    return
        $count_tours

};

declare function app:getDocName($node as node()) {
    let $name := functx:substring-after-last(document-uri(root($node)), '/')
    return
        $name
};

declare function app:hrefToDoc($node as node()) {
    let $href := concat('show.html', '?document=', app:getDocName($node))
    return
        $href
};

(: The transform (in the http://exist-db.org/xquery/transform function namespace) module
provides functions for directly applying an XSL stylesheet
to an XML fragment within an XQuery script.:)

declare function app:XMLtoHTML($node as node(), $model as map(*)) {
    let $ref := xs:string(request:get-parameter("document", ""))
    let $xmlPath := concat(xs:string(request:get-parameter("directory", "documents")), '/')
    let $xml := doc(replace(concat("/db/apps/ct_editions/data/", $xmlPath, $ref), '/exist', '/db/'))

    let $xslPath := concat(xs:string(request:get-parameter("stylesheet", "xmlToHtml")), '.xsl')
    let $xsl := doc(replace(concat("/db/apps/ct_editions/resources/xslt/", $xslPath), '/exist', '/db/'))
    (: get a list of all the URL parameters that are not either xml= or xslt= :)
    let $params :=
    <parameters>
        {
            for $p in request:get-parameter-names()
            let $val := request:get-parameter($p, ())
                where not($p = ("document", "directory", "stylesheet"))
            return
                <param
                    name="{$p}"
                    value="{$val}"/>
        }
    </parameters>

    return
        transform:transform($xml, $xsl, $params),

    (: navigation within the Pennant-Bull corpus :)

    let $currentID := xs:integer(substring-before(request:get-parameter("document", ''), '.xml'))
    let $thisid := "ct" || substring-before(request:get-parameter("document", ''), '.xml')

    let $nextdoc :=
    (for $doc in collection("/db/apps/ct_editions/data/documents")//tei:TEI[@xml:id gt $thisid]
    let $sent := $doc//tei:correspAction[@type eq "sent"]/tei:persName
    let $received1 := $doc//tei:correspAction[@type eq "received"]/tei:persName[1]
    let $received2 := $doc//tei:correspAction[@type eq "received"]/tei:persName[2]

        where
        $sent/@ref eq "pe0313" or $sent/@ref eq "pe0232" and ($received1/@ref eq "pe0313" or $received1/@ref eq "pe0232")
        order by $doc/@xml:id
    return
        (: concat(substring(string($doc//@xml:id), 3), '.xml'))[1] :)
        substring(string($doc//@xml:id), 3))[1]

    let $prevdoc :=
    (for $doc in collection("/db/apps/ct_editions/data/documents")//tei:TEI[@xml:id lt $thisid]
    let $sent := $doc//tei:correspAction[@type eq "sent"]/tei:persName
    let $received1 := $doc//tei:correspAction[@type eq "received"]/tei:persName[1]
    let $received2 := $doc//tei:correspAction[@type eq "received"]/tei:persName[2]

        where
        ($sent/@ref eq "pe0313" or $sent/@ref eq "pe0232") and ($received1/@ref eq "pe0313" or $received1/@ref eq "pe0232")
        order by $doc/@xml:id descending
    return
        (: concat(substring(string($doc//@xml:id), 3), '.xml'))[1] :)
        substring(string($doc//@xml:id), 3))[1]

    return
        if ($currentID gt 0999 and $currentID lt 1270) then
            (
            if ($nextdoc) then
                <a
                    type="button"
                    class="btn btn-outline-primary float-right"
                    href="/doc/{$nextdoc}">Next letter in the Pennant-Bull correspondence</a>
            else
                (<button
                    class="btn btn-outline-primary float-right disabled">This is the last letter</button>),
            if ($prevdoc) then
                <a
                    type="button"
                    class="btn btn-outline-primary float-left"
                    href="/doc/{$prevdoc}">Previous letter in the Pennant-Bull correspondence</a>
            else
                (<button
                    type="button"
                    class="btn btn-outline-primary float-left disabled">This is the first letter</button>),
            <br/>,
            <br/>)
        else
            ()
};

(:~ : creates a basic table of content derived from the documents stored in '/data/documents' :)

declare function app:tocLettersBull($node as node(), $model as map(*)) {
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(app:getDocName($doc), '.xml')
    (:let $from := string($doc//tei:correspAction[@type = "sent"]/tei:persName):)
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)
    let $to := for $recipient at $i in $doc//tei:correspAction[@type = "received"]/tei:persName
    return
        if ($i eq $recipients) then
            $recipient
        else
            ($recipient || ', ')
    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
    return
        $recipient/@ref
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
        where (($fromID = "pe0313") or ($fromID = "pe0232")) and (contains($toID, "pe0313") or (contains($toID, "pe0232")))
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$doc}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>


};

declare function app:tocLettersPaton($node as node(), $model as map(*)) {
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(app:getDocName($doc), '.xml')
    let $from := string($doc//tei:correspAction[@type = "sent"]/tei:persName)
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)
    let $to := for $recipient at $i in $doc//tei:correspAction[@type = "received"]/tei:persName
    return
        if ($i eq $recipients) then
            $recipient
        else
            ($recipient || ', ')
    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
    return
        $recipient/@ref
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := $year || ' ' || $month || ' ' || $day
        where (($fromID = "pe0228") or ($fromID = "pe0232")) and (contains($toID, "pe0228") or (contains($toID, "pe0232")))
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$doc}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>


};

declare function app:tocLettersScottish($node as node(), $model as map(*)) {
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(app:getDocName($doc), '.xml')
    let $from := string($doc//tei:correspAction[@type = "sent"]/tei:persName)
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)
    let $to := for $recipient at $i in $doc//tei:correspAction[@type = "received"]/tei:persName
    return
        if ($i eq $recipients) then
            $recipient
        else
            ($recipient || ', ')
    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
    return
        $recipient/@ref
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := $year || ' ' || $month || ' ' || $day
        where $fromID ne "pe0228"
        and $fromID ne "pe0313"
        and not(contains($toID, "pe0228"))
        and not(contains($toID, "pe0313"))
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$doc}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>


};

(: NOT USED! The XHR call is used instead (handlerTours.xq) :)
declare function app:tocTours($node as node(), $model as map(*)) {

    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) < 0100]
    let $id := substring-before(app:getDocName($doc), '.xml')
    let $title := string($doc//tei:titleStmt/tei:title)
    let $year := string($doc/tei:titleStmt/tei:title/tei:date)

    return
        (<tr>

            <td><a
                    href="/doc/{$doc}">{$title}</a></td>
            <td>{$year}</td>

        </tr>)

};


declare function app:number($node as node(), $model as map(*)) {

    let $par := fn:current-dateTime()

    return

        $par

};

declare function app:listPers($node as node(), $model as map(*)) {

    let $hitHtml := "hits.html?searchkey="
    for $person at $i in doc("/db/apps/ct_editions/data/indices/pedb.xml")//tei:listPerson/tei:person
    let $forename := $person/tei:persName/tei:forename
    let $surname := $person/tei:persName/tei:surname
    let $akas := $person/tei:persName/tei:addName
    let $akas_n := count($akas)
        order by $surname
    return

    (:<div
            class="card" data-ref="{$person/@xml:id}">
            <div
                class="card-header"
                id="heading">
                <h5
                    class="mb-0">
                    <button
                        class="btn btn-link"
                        type="button"
                        style="text-align: left;white-space: unset;"
                        data-toggle="collapse"
                        data-target="#collapse{$i}"
                        aria-expanded="true"
                        aria-controls="collapse{$i}">
                        {
                    if ($surname = "") then
                        "[Unknown]"
                    else
                        $surname
                }, {
                    if ($forename = "") then
                        "[Unknown]"
                    else
                        $forename
                }
                {
                    if (not(empty($akas))) then
                        for $aka at $i in $akas
                        return
                            (if ($i ne $akas_n) then
                                (", " || $aka)
                            else
                                (" " || $aka))
                    else
                        ()
                }
                    </button>
                </h5>
            </div>

            <div
                id="collapse{$i}"
                class="collapse"
                aria-labelledby="heading{$i}"
                data-parent="#listULPersons">
                <div
                    class="card-body" id="details">

                        Info about the person


                    </div></div></div>:)

            (<div data-ref="{$person/@xml:id}" class="accordion-item">
                <div id="person-{$person/@xml:id}" data-ref="{$person/@xml:id}" class="accordion-heading">
                    <h6 data-ref="{$person/@xml:id}">{
                    if ($surname = "") then
                        "[Unknown]"
                    else
                        $surname
                }, {
                    if ($forename = "") then
                        "[Unknown]"
                    else
                        $forename
                }
                {
                    if (not(empty($akas))) then
                        for $aka at $i in $akas
                        return
                            (if ($i ne $akas_n) then
                                (", " || $aka)
                            else
                                (" " || $aka))
                    else
                        ()
                }</h6>
                    <div class="icon">
                        <i class="arrow right"></i>
                    </div>
                </div>
                <div class="accordion-content">
                <div style="height: 30em !important; overflow: auto;" id="details-{$person/@xml:id}"/>
                </div>
            </div>)


        (:<li><a
                href="{concat($hitHtml, data($person/@xml:id))}">
                {
                    if ($surname = "") then
                        "[Unknown]"
                    else
                        $surname
                }, {
                    if ($forename = "") then
                        "[Unknown]"
                    else
                        $forename
                }
                {
                    if (not(empty($akas))) then
                        for $aka at $i in $akas
                        return
                            (if ($i ne $akas_n) then
                                (", " || $aka)
                            else
                                (" " || $aka))
                    else
                        ()
                }</a></li>:)
};

declare function app:listPlaces($node as node(), $model as map(*)) {

    let $hitHtml := "hits.html?searchkey="
    for $place at $i in doc("/db/apps/ct_editions/data/indices/pldb.xml")//tei:listPlace/tei:place
    let $geogName := $place/tei:placeName/tei:geogName
    let $addNames := $place/tei:placeName/tei:addName
    let $addNames_n := count($addNames)
        order by $geogName
    return

    (<div class="accordion-item">
                <div data-ref="{$place/@xml:id}" id="place-{$place/@xml:id}" class="accordion-heading">
                <h6>{
                    if ($geogName = "") then
                        "[Unknown]"
                    else
                        $geogName
                }
                {
                    if (not(empty($addNames))) then
                        for $addName at $i in $addNames
                        return
                            (if ($i ne $addNames_n) then
                                (", " || $addName)
                            else
                                (" " || $addName))
                    else
                        ()
                }
                </h6>
                <div class="icon">
                        <i class="arrow right"></i>
                    </div></div>
                <div class="accordion-content">
                <div style="height: 30em !important; overflow: auto;" id="details-{$place/@xml:id}"/>
                </div>
                </div>)


    (:<div
            class="card">
            <div
                class="card-header"
                id="heading{$i}">
                <h5
                    class="mb-0">
                    <button
                        class="btn btn-link"
                        type="button"
                        style="text-align: left;white-space: unset;"
                        data-toggle="collapse"
                        data-target="#collapse{$i}"
                        aria-expanded="true"
                        aria-controls="collapse{$i}">{
                    if ($geogName = "") then
                        "[Unknown]"
                    else
                        $geogName
                }
                {
                    if (not(empty($addNames))) then
                        for $addName at $i in $addNames
                        return
                            (if ($i ne $addNames_n) then
                                (", " || $addName)
                            else
                                (" " || $addName))
                    else
                        ()
                }</button></h5></div>
                <div
                id="collapse{$i}"
                class="collapse"
                aria-labelledby="heading{$i}"
                data-parent="#listULPlaces">
                <div
                    class="card-body"> Info about the place </div></div></div>:)

        (:<li><a
                href="{concat($hitHtml, data($place/@xml:id))}">
                {
                    if ($geogName = "") then
                        "[Unknown]"
                    else
                        $geogName
                }
                {
                    if (not(empty($addNames))) then
                        for $addName at $i in $addNames
                        return
                            (if ($i ne $addNames_n) then
                                (", " || $addName)
                            else
                                (" " || $addName))
                    else
                        ()
                }</a></li>:)
};


declare function app:listArtworks($node as node(), $model as map(*)) {

    let $hitHtml := "hitsartworks.html?searchkey="
    for $artwork at $i in doc('/db/apps/ct_editions/data/indices/ardb.xml')/tei:TEI/tei:text/tei:body/tei:list/tei:item/tei:rs
    return

    (:<div
            class="card">
            <div
                class="card-header"
                id="heading{$i}">
                <h5
                    class="mb-0">
                    <button
                        class="btn btn-link"
                        style="text-align: left;white-space: unset;"
                        type="button"
                        data-toggle="collapse"
                        data-target="#collapse{$i}"
                        aria-expanded="true"
                        aria-controls="collapse{$i}">
                        {string($artwork/tei:title)}
                {
                    if (($artwork/tei:surname eq '') or ($artwork/tei:forename eq '')) then
                        ''
                    else
                        ', by '
                }
                {string($artwork/tei:surname)}
                {string($artwork/tei:forename)}</button></h5></div>
                <div
                id="collapse{$i}"
                class="collapse"
                aria-labelledby="heading{$i}"
                data-parent="#listULArtworks">
                <div
                    class="card-body"> Info about the artwork </div></div></div>:)

                    ((<div class="accordion-item">
                <div data-ref="{$artwork/@xml:id}" id="artwork-{$artwork/@xml:id}" class="accordion-heading">
                <h6>{string($artwork/tei:title)}
                {
                    if (($artwork/tei:surname eq '') or ($artwork/tei:forename eq '')) then
                        ''
                    else
                        ', by '
                }
                {string($artwork/tei:surname)}
                {string($artwork/tei:forename)}
                </h6>
                <div class="icon">
                        <i class="arrow right"></i>
                    </div></div>
                <div class="accordion-content">
                <div style="height: 30em !important; overflow: auto;" id="details-{$artwork/@xml:id}"/>
                </div>
                </div>))


        (:<li><a
                href="{concat($hitHtml, data($artwork/@xml:id))}">{string($artwork/tei:title)}
                {
                    if (($artwork/tei:surname eq '') or ($artwork/tei:forename eq '')) then
                        ''
                    else
                        ', by '
                }
                {string($artwork/tei:surname)}
                {string($artwork/tei:forename)}</a></li>:)



};

declare function app:listBooks($node as node(), $model as map(*)) {

    let $hitHtml := "hitsbooks.html?searchkey="
    for $book at $i in doc('/db/apps/ct_editions/data/indices/bidb.xml')/tei:TEI/tei:text/tei:body/tei:listBibl/tei:bibl

    return

        (:        <li><a
                    href="{concat($hitHtml, data($book/@xml:id))}">{string($book/tei:title)}
                    </a>
                    </li>:)

        (:<div
            class="card">
            <div
                class="card-header"
                id="heading{$i}">
                <h5
                    class="mb-0">
                    <button
                        class="btn btn-link"
                        type="button"
                        style="text-align: left;white-space: unset;"
                        data-toggle="collapse"
                        data-target="#collapse{$i}"
                        aria-expanded="true"
                        aria-controls="collapse{$i}">
                        {string($book/tei:title)}
                    </button>
                </h5>
            </div>

            <div
                id="collapse{$i}"
                class="collapse"
                aria-labelledby="heading{$i}"
                data-parent="#listULBooks">
                <div
                    class="card-body"> Info about the book </div></div></div>:)
(<div class="accordion-item">
                <div data-ref="{$book/@xml:id}" id="book-{$book/@xml:id}" class="accordion-heading">
                <h6>{string($book/tei:title)}
                </h6>
                <div class="icon">
                        <i class="arrow right"></i>
                    </div></div>
                <div class="accordion-content">
                <div style="height: 30em !important; overflow: auto;" id="details-{$book/@xml:id}"/>
                </div>
                </div>)


};

declare function app:listPers_hits($node as node(), $model as map(*), $searchkey as xs:string?)

{

    for $hit in collection("/db/apps/ct_editions/data/documents/")//tei:TEI[.//tei:persName[@ref = $searchkey]]
    let $document := substring-before(app:getDocName($hit), '.xml')
    let $title := $hit//tei:titleStmt/tei:title

    return

        <tr>
            <td><a
                    href="/doc/{$document}">{$document}</a> ({string($title)})
            </td>
        </tr>
};

declare function app:listArtworks_hits($node as node(), $model as map(*), $searchkey as xs:string?)

{

    for $hit in collection('/db/apps/ct_editions/data/documents/')//tei:TEI[.//tei:rs[@ref = $searchkey]]
    let $document := substring-before(app:getDocName($hit), '.xml')
    let $title := $hit//tei:titleStmt/tei:title
    return

        <tr>
            <td><a
                    href="/doc/{$document}">{$document}</a> ({string($title)})
            </td>
        </tr>
};

declare function app:listBooks_hits($node as node(), $model as map(*), $searchkey as xs:string?)

{

    for $hit in collection('/db/apps/ct_editions/data/documents/')//tei:TEI[.//tei:bibl/tei:title[@ref = $searchkey]]
    let $document := substring-before(app:getDocName($hit), '.xml')
    let $title := $hit//tei:titleStmt/tei:title
    return

        <tr>
            <td><a
                    href="/doc/{$document}">{$document}</a> ({string($title)})
            </td>
        </tr>
};

declare function app:listPlace_hits($node as node(), $model as map(*), $searchkey as xs:string?)

{

    for $hit in collection('/db/apps/ct_editions/data/documents/')//tei:TEI[.//tei:placeName[@ref = $searchkey]]
    let $document := substring-before(app:getDocName($hit), '.xml')
    let $title := $hit//tei:titleStmt/tei:title
    return

        <tr>
            <td><a
                    href="/doc/{$document}">{$document}</a> ({string($title)})
            </td>
        </tr>
};

declare function app:persDetails($node as node(), $model as map(*), $searchkey as xs:string?)

{

    let $note := doc('/db/apps/ct_editions/data/indices/pedb.xml')//tei:listPerson/tei:person[@xml:id = $searchkey]/tei:persName/tei:note
    let $forename := doc('/db/apps/ct_editions/data/indices/pedb.xml')//tei:listPerson/tei:person[@xml:id = $searchkey]/tei:persName/tei:forename
    let $surname := doc('/db/apps/app-ct//data/indices/pedb.xml')//tei:listPerson/tei:person[@xml:id = $searchkey]/tei:persName/tei:surname
    let $rolename := doc('/db/apps/ct_editions/data/indices/pedb.xml')//tei:listPerson/tei:person[@xml:id = $searchkey]/tei:persName/tei:roleName
    let $xsl := doc('../resources/xslt/xmlToHtml.xsl')
    (:let $xsl := (
    <xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ct="www.curioustravellers.ac.uk/ns/namespace" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tei" version="3.0">
    <xsl:template match="//tei:hi[@rend = 'italic']" mode="#default deletion addition">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//tei:hi[@rend = 'bold']" mode="#default deletion addition">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- People -->
    <xsl:template match="tei:persName">
        <xsl:variable name="pedb" select="doc('pedb.xml')"/>
        <xsl:variable name="peid" select="{$ref}"/>
        <xsl:variable name="note" select="$pedb//tei:person[@xml:id eq $peid]//tei:note"/>


                <a href="/pages/hits.html?searchkey=">
                    <xsl:apply-templates/>
                </a>


    </xsl:template>
    </xsl:stylesheet>
    ):)
    let $params :=
    <parameters>
        {
            for $p in request:get-parameter-names()
            let $val := request:get-parameter($p, ())
                where not($p = ("document", "directory", "stylesheet"))
            return
                <param
                    name="{$p}"
                    value="{$val}"/>
        }
    </parameters>
    let $addNames := doc('/db/apps/ct_editions/data/indices/pedb.xml')//tei:listPerson/tei:person[@xml:id = $searchkey]/tei:persName/tei:addName
    let $nAddNames := count($addNames)
    let $variant :=
    for $addname at $i in $addNames
    return
        if ($nAddNames eq $i) then
        $addname else
            $addname || ', '


    return
        <div>
            <h2>Person details</h2>
            <br/>
            {
                if ($forename ne "" and $surname ne "") then
                    (<h4>{string($surname)}, {string($forename)}</h4>)
                else
                    if ($forename eq "" and $surname ne "") then
                        (<h4>{string($surname)}<span
                                style="font-size: small;"> (surname)</span></h4>)
                    else
                        if ($surname eq "" and $forename ne "") then
                            (<h4>{$forename/text()}<span
                                    style="font-size: small;"> (forename)</span></h4>)
                        else
                            ''
            }
            {
                if (empty($variant) or ($variant = '')) then
                    ''
                else
                    (<p>AKA: {
                            $variant
                            (:for $variant at $pos in $addname
                    return
                    if($variant[position() ne last()]) then
                    string($variant[$pos]) || "," else
                    string($variant[$pos]):)
                        }</p>)

            }
            {
                if ($rolename ne "") then
                    (<p>Title: {string($rolename)}</p>)
                else
                    ''
            }
            {
                if ($note ne "") then
                (<p>Notes: {

                        transform:transform($note, $xsl, $params)

                    }</p>)
                    else
                    ''
            }

        </div>
};

declare function app:placeDetails($node as node(), $model as map(*), $searchkey as xs:string?)

{

    let $note := doc('/db/apps/ct_editions/data/indices/pldb.xml')//tei:listPlace/tei:place[@xml:id = $searchkey]/tei:placeName/tei:note
    let $geogName := doc('/db/apps/ct_editions/data/indices/pldb.xml')//tei:listPlace/tei:place[@xml:id = $searchkey]/tei:placeName/tei:geogName
    let $addnames := doc('/db/apps/app-ct//data/indices/pldb.xml')//tei:listPlace/tei:place[@xml:id = $searchkey]/tei:placeName/tei:addName
    let $xsl := doc('../resources/xslt/xmlToHtml.xsl')


    let $params :=
    <parameters>
        {
            for $p in request:get-parameter-names()
            let $val := request:get-parameter($p, ())
                where not($p = ("document", "directory", "stylesheet"))
            return
                <param
                    name="{$p}"
                    value="{$val}"/>
        }
    </parameters>
    let $variant :=
    for $addname in $addnames
    return
        if ($addname[@ref = "1"]) then
            $addname
        else
            if ($addname = "") then
                ()
            else
                (", " || $addname)

    return
        <div>
            <h2>Place details</h2>
            <br/>
            <h4>{$geogName}</h4>
            {
                if (empty($variant)) then
                    ''
                else
                    (<p>Variant: {
                            $variant
                            (:for $variant at $pos in $addname
                    return
                    if($variant[position() ne last()]) then
                    string($variant[$pos]) || "," else
                    string($variant[$pos]):)
                        }</p>)

            }

            {
                if ($note ne "") then
                (<p>Notes: {

                        transform:transform($note, $xsl, $params)

                    }</p>)
                    else
                    ''

            }

        </div>
};

declare function app:artworkDetails($node as node(), $model as map(*), $searchkey as xs:string?)

{

    let $title := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:title
    let $geognameHist := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:geogName[@type = "historic"]
    let $geognameCurr := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:geogName[@type = "current"]
    let $note := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:note
    let $forename := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:forename
    let $surname := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:surname
    let $date := doc('/db/apps/ct_editions/data/indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:date
    let $addname := doc('/db/apps/ct_editions/data//indices/ardb.xml')//tei:rs[@xml:id = $searchkey]/tei:addname

    let $xsl := doc('../resources/xslt/xmlToHtml.xsl')
    let $params :=
    <parameters>
        {
            for $p in request:get-parameter-names()
            let $val := request:get-parameter($p, ())
                where not($p = ("document", "directory", "stylesheet"))
            return
                <param
                    name="{$p}"
                    value="{$val}"/>
        }
    </parameters>
    return
        <div>
            <h2>Artwork details</h2>
            <br/>
            <h4><i>{string($title)}</i></h4>
            {
                if ($forename ne "" and $surname ne "") then
                    (<p>By {string($surname)}, {string($forename)}</p>)
                else
                    if ($surname ne "") then
                        (<p>By {string($surname)}
                        </p>)
                    else
                        ''
            }
            {
                if ($geognameHist ne "") then
                    (<p>Geogname (historic): {$geognameHist}</p>)
                else
                   ''
            }
            {
                if ($geognameCurr ne "") then
                    (<p>Geogname (current): {$geognameCurr}</p>)
                else
                    ''
            }
            {
                if ($date ne "") then
                    (<p>Date: {$date}</p>)
                else
                    ''
            }
            {
                if ($addname ne "") then
                    (<p>Addname: {$addname}</p>)
                else
                    ''
            }
            {
                if ($note ne "") then
                    (<p>Note: {transform:transform($note, $xsl, $params)}</p>)
                else
                    ''
            }

        </div>
};

declare function app:bookDetails($node as node(), $model as map(*), $searchkey as xs:string?)

{

    let $title := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:title
    let $pubPlace := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:pubPlace
    let $publisher := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:publisher
    let $note := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:note
    let $date := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:date
    let $forename := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:author/tei:forename
    let $surname := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:author/tei:surname
    let $addname := doc('/db/apps/ct_editions/data/indices/bidb.xml')//tei:bibl[@xml:id = $searchkey]/tei:addname
    let $xsl := doc('../resources/xslt/xmlToHtml.xsl')
    let $params :=
    <parameters>
        {
            for $p in request:get-parameter-names()
            let $val := request:get-parameter($p, ())
                where not($p = ("document", "directory", "stylesheet"))
            return
                <param
                    name="{$p}"
                    value="{$val}"/>
        }
    </parameters>

    return
        <div>
            <h2>Book details</h2>
            <br/>
            <h4><i>{string($title)}</i></h4>
            {
                if ($addname ne "") then
                    (<p>AKA: {string($addname)}</p>)
                else
                   ''
            }
            {
                if ($surname ne "" and $forename ne "") then
                    (<p>By {string($surname)}, {string($forename)}</p>)
                else
                    if ($surname ne "") then
                        (<p>By {$surname}</p>)
                    else
                        ''
            }
            {
                if ($publisher ne "") then
                    (<p>Publisher: {string($publisher)}</p>)
                else
                    ''
            }
            {
                if ($pubPlace ne "") then
                    (<p>Publication place: {string($pubPlace)}</p>)
                else
                    ''
            }
            {
                if ($date ne "") then
                    (<p>Publication date: {string($date)}</p>)
                else
                    ''
            }
            {
                if ($note ne "") then
                    (<p>Note: {transform:transform($note, $xsl, $params)}</p>)
                else
                    ''
            }

        </div>
};

declare function app:ft_search($node as node(), $model as map(*)) {
    if (request:get-parameter("searchexpr", "") != "") then
        let $searchterm as xs:string := request:get-parameter("searchexpr", "")
        for $hit in collection('/db/apps/ct_editions/data/documents')//tei:p[ft:query(., $searchterm)]
        (: passes the search term to the show.html so that we can highlight the search terms :)
        let $href := concat(app:hrefToDoc($hit), "&amp;searchexpr=", $searchterm)
        let $score as xs:float := ft:score($hit)
            order by $score descending
        return
            <tr>
                <td
                    class="KWIC">{
                        kwic:summarize($hit, <config
                            width="40"
                            link="{$href}"/>)
                    }</td>
                <td>{app:getDocName($hit)}</td>
            </tr>
    else
        <div>Nothing to search for</div>
};

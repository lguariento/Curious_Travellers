xquery version "3.1";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
import module namespace functx = 'http://www.functx.com';
declare option output:method "html";
declare option output:media-type "application/html";

declare function local:getDocName($node as node()) {
    let $name := functx:substring-after-last(document-uri(root($node)), '/')
    return
        $name
};

declare function local:hrefToDoc($node as node()) {
    let $href := concat('show.html', '?document=', local:getDocName($node))
    return
        $href
};

declare variable $index := doc("/db/apps/ct_editions/data/indices/pedb.xml");


(: Document 132 has two receipients! :)


    (:if((substring(request:get-parameter('selected', ()), 2, 1)) = "2") then( :)

    if(request:get-parameter('selected', ()) = "2") then(
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) gt 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    (:let $from := string($doc//tei:correspAction[@type eq "sent"]/tei:persName):)
    let $fromID := string($doc//tei:correspAction[@type eq "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type eq "received"]/tei:persName)
    (: let $to := for $recipient at $i in $doc//tei:correspAction[@type eq "received"]/tei:persName
        return if($i eq $recipients) then $recipient else ($recipient || ', ') :)
    let $toID := for $recipient in $doc//tei:correspAction[@type eq "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()    where (($fromID eq "pe0313") or ($fromID eq "pe0232")) and (contains($toID, "pe0313") or (contains($toID, "pe0232")))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

        else if(request:get-parameter('selected', ()) = "3") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) gt 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type eq "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname

    let $recipients := count($doc//tei:correspAction[@type eq "received"]/tei:persName)
    let $toID := for $recipient in $doc//tei:correspAction[@type eq "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()    where (($fromID eq "pe0228") or ($fromID eq "pe0232")) and (contains($toID, "pe0228") or (contains($toID, "pe0232")))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

        else if (request:get-parameter('selected', ()) = "4") then

        (for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) gt 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type eq "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type eq "received"]/tei:persName)
    let $toID := for $recipient in $doc//tei:correspAction[@type eq "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()    where $fromID ne "pe0228"
    and $fromID ne "pe0313"
    and not(contains($toID, "pe0228"))
    and not(contains($toID, "pe0313"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{string($from)}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)
        (:
        else if (request:get-parameter('selected', ()) = "5") then

        (: all Welsh letters are after ID 1274 :)

        (for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) gt 1273]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type eq "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type eq "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type eq "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when), '-')
    let $date := $year || ' ' || $month || ' ' || $day

    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{string($from)}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)
    :)

    (: Daniel Lysons :)
    else if (request:get-parameter('selected', ()) = "5") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()    where ($fromID = "pe0408") or (contains($toID, "pe0408"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: Treadway Russell Nash :)
    else if (request:get-parameter('selected', ()) = "6") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname

    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := $year || ' ' || $month || ' ' || $day
    where ($fromID = "pe0416") or (contains($toID, "pe0416"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: Hugh Davies :)
    else if (request:get-parameter('selected', ()) = "7") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()    where ($fromID = "pe0903") or (contains($toID, "pe0903"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: Philip Yorke :)
    else if (request:get-parameter('selected', ()) = "8") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)
    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := $year || ' ' || $month || ' ' || $day
    where ($fromID = "pe0243") or (contains($toID, "pe0243"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: John Lloyd, Hafodunos and Wigfair :)
    else if (request:get-parameter('selected', ()) = "9") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()    where ($fromID = "pe0803") or (contains($toID, "pe0803"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: John Lloyd, Caerwys :)
    else if (request:get-parameter('selected', ()) = "10") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)
    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
    where ($fromID = "pe0333") or (contains($toID, "pe0333")) or (contains($toID, "pe2061"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: William Owen Pughe :)
    else if (request:get-parameter('selected', ()) = "11") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)
    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
    where ($fromID = "pe2111") or (contains($toID, "pe2111"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: John Jones :)
    else if (request:get-parameter('selected', ()) = "12") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
    where ($fromID = "pe0322") or (contains($toID, "pe0322"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    (: William Morris :)
    else if (request:get-parameter('selected', ()) = "13") then

        (
    for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
    where ($fromID = "pe0031") or (contains($toID, "pe0031"))
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    else if ((substring(request:get-parameter('selected', ()), 2, 3)) = "all") then

        (for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) > 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type = "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname
    let $recipients := count($doc//tei:correspAction[@type = "received"]/tei:persName)

    let $toID := for $recipient in $doc//tei:correspAction[@type = "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type = "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{$from}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

    else if (request:get-parameter('selected', ()) = "all") then

        (for $doc in collection("/db/apps/ct_editions/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) gt 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $fromID := string($doc//tei:correspAction[@type eq "sent"]/tei:persName/@ref)
    let $from := $index//tei:person[@xml:id eq $fromID]//tei:forename || ' ' || $index//tei:person[@xml:id eq $fromID]//tei:surname

    let $recipients := count($doc//tei:correspAction[@type eq "received"]/tei:persName)
    let $toID := for $recipient in $doc//tei:correspAction[@type eq "received"]/tei:persName
        return $recipient/@ref
    let $to := for $recipient at $i in $index//tei:person[@xml:id eq $toID]
        return if($i eq $recipients) then ($recipient//tei:forename || ' ' || $recipient//tei:surname) else ($recipient//tei:forename || ' ' || $recipient//tei:surname || ', ')
    let $day := functx:substring-after-last(string(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)), '-')
    let $month := functx:month-name-en(xs:date(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when)))
    let $year := substring-before(data($doc//tei:correspAction[@type eq "sent"]/tei:date/@when), '-')
    let $date := if (data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)) then ($year || ' ' || $month || ' ' || $day) else $doc//tei:date/string()
    order by data($doc//tei:correspAction[@type = "sent"]/tei:date/@when)
    return

        <tr>

            <th
                scope="row"><a
                    href="/doc/{$id}">{$id}</a></th>
            <td>{string($from)}</td>
            <td>{$to}</td>
            <td>{$date}</td>
        </tr>)

        else ()

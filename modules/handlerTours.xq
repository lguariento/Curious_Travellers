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


    if(request:get-parameter('selected', ()) = "2") then( 
    
    for $doc in collection("/db/apps/app-ct/data/documents")/tei:TEI/tei:teiHeader[@type eq 's']
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $title := $doc//tei:titleStmt/tei:title/node()[not(self::tei:date)]
    let $year := string($doc//tei:titleStmt/tei:title/tei:date)
    
    return
        <tr>
            
            <td>{$year}</td>
            <td><a href="/doc/{$id}">{$title}</a></td>
            
        
        </tr>)

else if(request:get-parameter('selected', ()) = "3") then( 
    
    for $doc in collection("/db/apps/app-ct/data/documents")/tei:TEI/tei:teiHeader[@type eq 'w']
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $title := $doc//tei:titleStmt/tei:title/node()[not(self::tei:date)]
    let $year := string($doc//tei:titleStmt/tei:title/tei:date)
    
    return
        <tr>
            
            <td>{$year}</td>
            <td><a href="/doc/{$id}">{$title}</a></td>
            
        
        </tr>)
        
        else (for $doc in collection("/db/apps/app-ct/data/documents")/tei:TEI[xs:integer(substring(@xml:id, 3)) < 0100]
    let $id := substring-before(local:getDocName($doc), '.xml')
    let $title := $doc//tei:titleStmt/tei:title/node()[not(self::tei:date)]
    let $year := string($doc//tei:titleStmt/tei:title/tei:date)
    
    return
        <tr>
            <td>{$year}</td>
            <td><a href="/doc/{$id}">{$title}</a></td>
            
        
        </tr>)
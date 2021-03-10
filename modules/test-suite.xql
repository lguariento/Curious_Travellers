xquery version "3.1";

(:~ This library module contains XQSuite tests for the ct_editions app.
 :
 : @author Luca Guariento
 : @version 1.0.0
 : @see curioustravellers.ac.uk
 :)

module namespace tests = "https://curioustravellers.ac.uk/apps/ct_editions/tests";

  import module namespace app = "https://curioustravellers.ac.uk/apps/ct_editions/templates" at "app.xql";
declare namespace test="http://exist-db.org/xquery/xqsuite";

declare variable $tests:map := map {1: 1};

declare
    %test:arg('n', 'div')
    %test:assertEquals("<p>Dummy templating function.</p>")
    function tests:templating-foo($n as xs:string) as node(){
        app:foo(element {$n} {}, $tests:map)
};

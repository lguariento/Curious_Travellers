xquery version "3.1";

(:~ The controller library contains URL routing functions.
 :
 : @see http://www.exist-db.org/exist/apps/doc/urlrewrite.xml
 :)

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/apps/ct_editions/"/>
    </dispatch>

(: Resource paths starting with $shared are loaded from the shared-resources app :)
else if (contains($exist:path, "/$shared/")) then
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
    <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
    <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
    </forward>
  </dispatch>


  else if ($exist:path eq "/") then
  (: forward root path to index.xql :) 
  (let $real-url := $exist:controller || replace($exist:path, '/', '/pages/index.html' )
  return (
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="{$real-url}"/>
    </dispatch>))
    
else if (starts-with($exist:path, "/doc/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/pages/show.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="document" value="{$exist:resource}.xml"/>
            </forward>
        </view>
    </dispatch> 
    
else if ($exist:path eq "/new_look") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/new_look', '/pages/new_look_Pennant_Bull.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
  
else if ($exist:path eq "/letters_editorial_policy") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/letters_editorial_policy', '/pages/letters_editorial_policy.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
  else if ($exist:path eq "/tours_editorial_policy") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/tours_editorial_policy', '/pages/tours_editorial_policy.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
else if ($exist:path eq "/bibliography") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/bibliography', '/pages/bibliography.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )


else if ($exist:path eq "/letters") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/letters', '/pages/letters.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
else if ($exist:path eq "/tours") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/tours', '/pages/tours.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
else if ($exist:path eq "/indices") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/indices', '/pages/indices.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )

else if ($exist:path eq "/show.html") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/show.html', '/pages/show.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
else if ($exist:path eq "/placedetails.html") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/placedetails.html', '/pages/placedetails.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
else if ($exist:path eq "/persdetails.html") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/persdetails.html', '/pages/persdetails.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
else if ($exist:path eq "/bookdetails.html") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/bookdetails.html', '/pages/bookdetails.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )
  
else if ($exist:path eq "/artworkdetails.html") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/artworkdetails.html', '/pages/artworkdetails.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )

else if ($exist:path eq "/ft_search.html") then
 (: forward root path to index.xql :)
  (let $real-url := $exist:controller || replace($exist:path, '/ft_search.html', '/pages/ft_search.html' )
  return (
  <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$real-url}">
        </forward>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler />
    </dispatch> )
  )

  else if (matches($exist:path, "/modules/.+")) then
  let $modules-url := $exist:controller || $exist:path
  return (
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="{$modules-url}"/>
    </dispatch> )

 else if (matches($exist:path, "/static/(css|img|js|open-iconic)/.+"))
    then (
        let $real-url := $exist:controller || replace($exist:path, '/static/', '/resources/' )
        let $log := util:log("debug", "static web resource:" || $exist:path || " redirect to " || $real-url)
        return (
            <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <set-header name="Cache-Control" value="max-age=2419200, must-revalidate, stale-while-revalidate=86400"/>
                <cache-control cache="yes"/>
                <forward url="{$real-url}" />
            </dispatch>
        )
    )

  else if (ends-with($exist:resource, ".html")) then (

  (: the html page is run through view.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">


        <view>
          <forward url="{$exist:controller}/modules/view.xql">
                      <set-header name="Cache-Control" value="no-cache"/>
                      </forward>
        </view>
        <error-handler>
      	  
      		<forward url="{$exist:controller}/modules/view.xql"/>
      	</error-handler>
    </dispatch>)

(: Resource paths starting with $app-root are loaded from the application's root collection :)
else if (contains($exist:path,"app-root")) then
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
    <forward url="{$exist:controller}/{substring-after($exist:path, '$app-root/')}">
        <set-header name='Cache-Control' value="yes"/>
    </forward>
</dispatch>

      else
          
          (:<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
              <cache-control cache="yes"/>
          </dispatch>  :)
          <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
                <redirect url="https://editions.curioustravellers.ac.uk/pages/error-page.html"/>
                </dispatch>
      

    document.addEventListener("DOMContentLoaded", function(){
    // load the datatables.js script in letters and tours pages
    if (window.location.pathname == '/letters' || window.location.pathname =="/tours") {
    var script = document.createElement("script");  // create a script DOM node
    script.src = 'https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js';  // set its src to the provided URL
    var script1 = document.createElement("script");  // create a script DOM node
    script1.src = 'https://cdn.datatables.net/v/bs4/dt-1.10.22/r-2.2.6/datatables.min.js';  // set its src to the provided URL
    var script2 = document.createElement("script");
    script2.src = '../static/js/datatables.js'
    document.body.appendChild(script);
    document.body.appendChild(script1);
    document.body.appendChild(script2);
   }
   })
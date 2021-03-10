        $( document ).ready(function() {

            var hits = ($('td.KWIC').children('p').length);
            if (hits == 1){
                $("#hitcount").text(hits+" document ");
            }
            else {
                $("#hitcount").text(hits+" documents ");
            }
            $("#searchexpr").text(decodeURIComponent($.urlParam("searchexpr")));
        });
$(document).on('click', "a#open", function (){
            <!-- fetch the @ref from the data-ref parameter passed by the .xslt processor -->
            ref = $(this).attr('data-ref');
            if (ref.substring(0,2) == 'pe') {
            $("#modalDetails").modal('handleUpdate');
            $("#details").load("/persdetails.html?searchkey=" + ref)}
            else if (ref.substring(0,2) == 'pl') {
            $("#modalDetails").modal('handleUpdate');
            $("#details").load("/placedetails.html?searchkey=" + ref)}
            else if (ref.substring(0,2) == 'bi') {
            console.log("book")
            $("#modalDetails").modal('handleUpdate');
            $("#details").load("/bookdetails.html?searchkey=" + ref)}
            else if (ref.substring(0,2) == 'ar') {
            $("#modalDetails").modal('handleUpdate');
            $("#details").load("/artworkdetails.html?searchkey=" + ref)}
    });
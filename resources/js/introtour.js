var address = String(window.location)
var docID = address.substr(-4);
//var docIDint = parseInt(docID)
var introHTML = docID + ".html"
console.log(docID)
if (docID < 0100) {
    document.getElementById("theIntro").style.visibility = "visible"
    $("#introTour").load('/pages/' + docID + ".html")
} else {
    document.getElementById("theIntro").remove();
}
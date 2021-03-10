const urlParams = new URLSearchParams(window.location.search);
const searchexpr = urlParams.get('searchexpr');
console.log(searchexpr)
var transcribedText = document.getElementById("XMLtoHTML").innerHTML;

 {
  var pattern=new RegExp("("+ searchexpr +")", "gi");
  var new_text=transcribedText.replace(pattern, "<span class='highlight'>"+searchexpr+"</span>");
  document.getElementById("XMLtoHTML").innerHTML=new_text;

 }
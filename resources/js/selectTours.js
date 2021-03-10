function listTours(selected, object) {

    var selectTour = document.getElementsByClassName("selectTour");
    selectTour[0].style.color = "#007bff";
    selectTour[1].style.color = "#007bff";
    selectTour[2].style.color = "#007bff";
    object.style.color = "black";
    
   /* document.getElementById('please').style.visibility = 'hidden';*/
    document.getElementById('tours').style.visibility = 'visible';
    
    var select = document.getElementById('selectToursGrop');
/*    const selected = JSON.stringify(select.options[select.selectedIndex].value); */

    var dataT = $('#tours').DataTable()
    dataT.destroy();
    
    var xhr = new XMLHttpRequest();
    var url = "../modules/handlerTours.xq";
    
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    
    xhr.send('selected=' + selected)
    
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            
            document.getElementById("listTours").innerHTML = xhr.responseText;
            
            
            $('#tours').DataTable();
            document.getElementById('tours_filter').lastChild.firstChild.nodeValue = 'Filter results'
        }
    }
 
}
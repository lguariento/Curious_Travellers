function listLetters(selected, object) {
    
    var selectLetter = document.getElementsByClassName("selectLetter");
    selectLetter[0].style.color = "#007bff";
    selectLetter[1].style.color = "#007bff";
    selectLetter[2].style.color = "#007bff";
    selectLetter[3].style.color = "#007bff";
    selectLetter[4].style.color = "#007bff";
    selectLetter[5].style.color = "#007bff";
    selectLetter[6].style.color = "#007bff";
    selectLetter[7].style.color = "#007bff";
    selectLetter[8].style.color = "#007bff";
    selectLetter[9].style.color = "#007bff";
    selectLetter[10].style.color = "#007bff";
    selectLetter[11].style.color = "#007bff";
    selectLetter[12].style.color = "#007bff";
    selectLetter[13].style.color = "#007bff";
    object.style.color = "black";
/*    document.getElementById('please').style.visibility = 'hidden';*/
    document.getElementById('letters').style.visibility = 'visible';
    
/*    var select = document.getElementById('selectLettersGrop');*/
/*    const selected = JSON.stringify(select.options[select.selectedIndex].value);*/

    
    var dataT = $('#letters').DataTable()
    dataT.destroy();
    document.getElementById("listLetters").innerHTML = ''
    
    var xhr = new XMLHttpRequest();
    var url = "../modules/handler.xq";
    
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    
    xhr.send('selected=' + selected)
    console.log("the value xhr is " + selected)
    
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            
            console.log(xhr.responseText)
            document.getElementById("listLetters").innerHTML = xhr.responseText;
            
            $('#letters').DataTable( 
            
                //{"order": [[ 3, 'asc' ]]}
                {"bSort": true}
                );
            
            document.getElementById('letters_filter').lastChild.firstChild.nodeValue = 'Filter results'
       
        }
    }
    /* add " (e.g. selected == '"2"') if using drop-down */
    if (selected == '2') {
        
        /*        document.getElementById("specificIntro").innerHTML = "<a href='Pennant-Bull.html'>Go to the Pennant-Bull intro</a>";
         */ document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Pennant-Bull Correspondence </a></h5>';
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Pennant-Bull.html");
    } else if (selected == '3') {
        
        /*        document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Pennant-Paton intro</a>";
         */ document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Pennant-Paton Correspondence</a></h5>';
        document.getElementById("intro").classList.remove('disabled')
        document.getElementById("specificIntro1").innerHTML = ""
        
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Pennant-Paton.html");
    } else if (selected == '4') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Pennant\’s Scottish Circles</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Scottish_circles.html");
    } else if (selected == '5') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Daniel Lysons (1727–1800)</a></h5 >';
        
        /* Disable the button for now */
        
        document.getElementById("specificIntro1").innerHTML = ""
        
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Lysons.html");
    } else if (selected == '6') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Treadway Russell Nash (1725–1811)</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Nash.html");
    } else if (selected == '7') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Hugh Davies (1739–1821)</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Davies.html");
    } else if (selected == '8') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Philip Yorke, Erddig (1743–1804)</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Yorke.html");
    } else if (selected == '9') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: John Lloyd, Hafodunos and Wigfair (1749–1815)</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Hafodunos.html");
    } else if (selected == '10') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: John Lloyd, Caerwys</h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Lloyd_Caerwys.html");
    } else if (selected == '11') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: William Owen (Pughe)</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Owen.html");
    } else if (selected == '12') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: John Jones</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("btnSpecificIntro").classList.add('disabled')
        //document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        //$("#specificIntro1").load("/pages/Scottish_circles.html");
    } else if (selected == '13') {
        
        /*            document.getElementById("specificIntro").innerHTML = "<a href='#'>Go to the Scottish tours intro</a>";
         */
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: William Morris</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/William_Morris.html");
    } else if (selected == 'welsh') {
        
        document.getElementById("intro").innerHTML = '<h5><a id="btnSpecificIntro" class="btn btn-primary btnIntro collapsed" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample">Introduction: Pennant\’s Welsh Circles</a></h5 >';
        document.getElementById("specificIntro1").innerHTML = ""
        document.getElementById("intro").classList.remove('disabled')
        $("#collapseExample").collapse('hide')
        $("#specificIntro1").load("/pages/Welsh_circles.html");
    }
    
    else if (selected == 'all') {
        $("#collapseExample").collapse({
        toggle: false
        })
        document.getElementById("intro").classList.remove('disabled')
        document.getElementById("intro").innerHTML = '';
        document.getElementById("specificIntro1").innerHTML = '';
    }
}
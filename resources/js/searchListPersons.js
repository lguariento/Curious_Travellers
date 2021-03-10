function myFunctionPersons() {
    // Declare variables
    var input, filter, ul, li, a, i;
    input = document.getElementById('listInputPersons');
    filter = input.value.toUpperCase();
    ul = document.getElementById("accordionPe");
    li = ul.getElementsByClassName('accordion-item');

    // Loop through all list items, and hide those who don't match the search query
    for (i = 0; i < li.length; i++) {
        a = li[i].getElementsByClassName("accordion-heading")[0];
        if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
            li[i].style.display = "";
        } else {
            li[i].style.display = "none";
        }
    }
}
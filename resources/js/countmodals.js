$('#modalDetails').on('shown.bs.modal', function () {
    
    // counts the number of opened modals and adds 1
    var nModals = $('#modalDetails').length + 1;
    
    // finds all the links with id 'open' (i.e. persons, places, books, and artworks)
    var list = $('#details').find('*[id^="open"]')
    
    // assing another modal to the data-target attribute in case the clicked link is within a modal itself
    for (var i = 0; i < list.length; i++) {
        list[i].dataset.target = 'modalDetails' + nModals;
    }
});
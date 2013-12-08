
$(document).ready(function() {
    $('#num').keydown(function(e){
      if(e.keyCode == 13)
        window.location = "/articles/" + $('#num').attr('value') + "?" + location.search.substring(1); 
    });
    /* ------- my scripts ------- */
    // login box click to open
    $('.popup').click(onPopupClick);

        function onPopupClick(e){
            // hide any other active popup
            var currentElementNestedPopup = $(this).parent().find('.popup_container');
            var tt = $('.popup_Open').not(currentElementNestedPopup);

            tt.removeClass("popup_Open").parent().find('.active').removeClass('active');
            e.preventDefault();
            $(this).toggleClass('active');
            currentElementNestedPopup.toggleClass('popup_Open');
    }


    $("body").click(function(ee){
        var element = $(ee.target);
        var elemClass = element.attr('class');
        var popupOpenParentObject = element.closest(".popup_Open");

        if(popupOpenParentObject.length === 0 &&  (!element.hasClass('excludPopup')))
        {
           $('.popup_Open').removeClass('popup_Open').parent().find('.active').removeClass('active');
        }
    });




});





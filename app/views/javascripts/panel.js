function hidePanel() {
  $('.cd-panel').removeClass('cd-panel--is-visible');
  $('body').removeClass('panel-visible');
  $(".panel-overlay").hide();
}

function showPanel() {
  $(".panel-overlay").show();
  $('.cd-panel').addClass('cd-panel--is-visible');
  $('body').addClass('panel-visible');
}

$(function() {

  $(".toggle-panel").on('click', function(e) {
    showPanel();
  });

  $(document).on("click", ".panel-overlay", function() {
    hidePanel();
  });

});


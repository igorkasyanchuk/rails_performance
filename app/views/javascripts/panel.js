function hidePanel() {
  $('.cd-panel').removeClass('cd-panel--is-visible');
  $('body').removeClass('panel-visible');
  $(".panel-overlay").hide();
}

function showPanel() {
  $(".panel-overlay").show();
  $('.cd-panel').addClass('cd-panel--is-visible');
  $('body').addClass('panel-visible');

  $('.cd-panel__content table').stupidtable();
}


$(function() {

  var panel = {};
  window.panel = panel;
  window.panel.header  = $(".panel-heading span");
  window.panel.content = $(".cd-panel__content");
  window.panel.close   = '<a class="panel-close" href="#" onclick="javascript: hidePanel(); return false;">&times;</a>'

  $(".toggle-panel").on('click', function(e) {
    showPanel();
  });

  $(document).on("click", ".panel-overlay", function() {
    hidePanel();
  });

});


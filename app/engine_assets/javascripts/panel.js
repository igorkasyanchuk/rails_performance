import $ from 'jquery';

function hidePanel() {
  $('.cd-panel').removeClass('cd-panel--is-visible');
  $('body').removeClass('panel-visible');
  $(".panel-overlay").hide();
}

function showPanel() {
  $(".cd-panel__container").scrollTop(0);
  $(".panel-overlay").show();
  $('.cd-panel').addClass('cd-panel--is-visible');
  $('body').addClass('panel-visible');
  $('.cd-panel__content table').stupidtable();
}

window.hidePanel = hidePanel;
window.showPanel = showPanel;

$(function() {
  var panel = {};
  window.panel = panel;
  window.panel.header  = $(".panel-heading span");
  window.panel.content = $(".cd-panel__content");
  window.panel.close   = '<a class="panel-close" href="#" onclick="javascript: hidePanel(); return false;">&times;</a>'

  $(document).ajaxStart(function(e) {
    $('.loader-wrapper').addClass('is-active');
  });

  $(document).ajaxComplete(function(e) {
    $('.loader-wrapper').removeClass('is-active');
  });

  $(".toggle-panel").on('click', function(e) {
    showPanel();
  });

  $(document).on("click", ".panel-overlay", function() {
    hidePanel();
  });

  $(document).on("click", ".rp-copy-tag", function () {
    var $tag = $(this);
    var text = $tag.data("value") || $tag.text().trim();

    navigator.clipboard.writeText(text).then(function () {
      $tag.addClass("is-copied");
      var originalText = $tag.attr("title");
      $tag.attr("title", "Copied!");

      setTimeout(function () {
        $tag.removeClass("is-copied");
        $tag.attr("title", originalText);
      }, 1000);
    });
  });
});

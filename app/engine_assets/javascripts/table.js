import $ from 'jquery';
window.jQuery = $; // shim for stupid-table-plugin
await import('stupid-table-plugin');

$(function() {
  $('table').stupidtable();
});

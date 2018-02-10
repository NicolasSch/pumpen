//= require jquery
//= require jquery_ujs
//= require tether
//= require toastr
//= require smart_listing
//= require bootstrap-select
//= require bootstrap

$(document).on('ready', function () {

  // on change listener
  $('#cart_user_id').on('change', function (e) {
    $(this).parents('form').submit();
  })

  $('#bill_filter_term').on('change', function (e) {
    $(this).parents('form').submit();
  })

  $('.selectpicker').selectpicker({});
});

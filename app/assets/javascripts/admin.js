//= require jquery
//= require jquery_ujs
//= require tether
//= require toastr
//= require smart_listing
//= require bootstrap-datepicker
//= require bootstrap-select
//= require_tree

$(document).on('ready', function () {

  // on change listener
  $('#cart_user_id').on('change', function (e) {
    $(this).parents('form').submit();
  })

  $('#bill_filter_term').on('change', function (e) {
    $(this).parents('form').submit();
  })

  $('.datepicker').datepicker({
    clearBtn: true,
    autoclose: true,
    format: 'dd/mm/yyyy',
    language: 'de'
  }
  );

  $('.selectpicker').selectpicker({});
});

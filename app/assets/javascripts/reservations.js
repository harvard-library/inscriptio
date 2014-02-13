$(function () {
  var $select = $('select#reservation_user_id');
  var options = $select.find('option').get();
  var source = [];
  var options_len = 0;

  if ($('html.c_reservations.a_new, html.c_reservations.a_edit').length == 0) {return;}

  options_len = options.length;
  while (options_len--) {
    source.unshift({label: options[options_len].textContent, value: options[options_len].value})
  }
  $('li#reservation_user_input').before('<li id="reservation_user_autocomplete" class="string input optional stringish"><label for="reservation_user_filter">User Filter</label> <input id="reservation_user_filter"></li>');
  $('#reservation_user_filter').autocomplete({
    source: source,
    select: function (e,ui) {
      $select.val(ui.item.value);
      $(this).val(ui.item.label);
      return false;
    },
    focus: function (e, ui) {
      return false;
    }
  });
})

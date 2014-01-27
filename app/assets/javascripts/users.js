$(function () {
  var $els = $('li.user.line > a')
  var TO_filter = null;
  $('ul.users.collection-list').prev().after('<label for="user-filter">Filter: </label><input type="text" id="user-filter" />');
  $('#user-filter').on('input', function (e) {
    var sstring = $(e.currentTarget).val();
    if (TO_filter) {
      clearTimeout(TO_filter);
    }
    TO_filter = setTimeout(function () {
      $els.each(function (i, el) {
        if (el.textContent.match(new RegExp(sstring, 'i'))) {
          $(el).parent().show();
        }
        else {
          $(el).parent().hide();
        }
      });
      if ($els.filter(':visible').length == 0) {
        $('#users-header').text('No Users Selected').effect('highlight', 1000);
      }
      else {
        $('#users-header').text('Users');
      }
    }, 300)})
});

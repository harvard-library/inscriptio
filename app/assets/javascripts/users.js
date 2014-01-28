/* User list filtering */
$(function () {
  /* Get ahold of relevant DOM elements */
  var $users_list = $('ul.users.collection-list')
  var els = $('li.user.line > a').get() /* All users in list */

  var old_color = $users_list.css('background-color')

  var TO_filter = null;

  var regex_from_sstring = function (s) {
    /* splits search string, turns each
       token into a positive lookahead assertion */
    var tokens = s.split(/\s+/);
    var len = tokens.length;
    while (len--) {
      tokens[len] = '(?=.*' + tokens[len] + ')';
    }
    return new RegExp('^' + tokens.join(''), 'i');
  };

  /* Build necessary DOM elements */
  $users_list.prev().after('<label for="user-filter">Filter: </label><input type="text" id="user-filter" placeholder="case insensitive ANDed search" style="max-width:50%;width: 100%" />');
  $('#user-filter').on('input propertychange', function (e) {
    /* Timeout prevents callback from bogging down user input */
    if (TO_filter) {
      clearTimeout(TO_filter);
    }
    if ($users_list.css('opacity') == 1) { /* Prevents multiple style changes while typing */
      $users_list.css({backgroundColor: '#eee', opacity: 0.5})
    }

    TO_filter = setTimeout(function () {
      var regex = regex_from_sstring($(e.currentTarget).val())

      var len = els.length
      var visible = 0;
      while (len--) {
        var $el = $(els[len]); // Cache jQuery object
        if (regex.test($el.text())) {
          $el.parent().show();
          visible++;
        }
        else {
          $el.parent().hide();
        }
      };
      if (visible == 0) {
        $('#users-header').text('No Users Selected').effect('highlight', 1000);
      }
      else {
        $('#users-header').text('Users');
      }
      $users_list.css({backgroundColor: old_color, opacity: 1});
    }, 300)})
});

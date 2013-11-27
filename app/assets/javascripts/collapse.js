/* Handles collapse/expand functionality
for various sidebars throughout Inscriptio */
$(function() {
  var states = {'Collapse': 'Expand',
                'Expand': 'Collapse'};

  $('.collapsible').prepend('<button>Expand</button>');

  $('.collapsible button').on('click', function (e) {
    var t_value = $(e.currentTarget).text();
    $(e.currentTarget).text(states[t_value]);
    $(e.currentTarget).parent().next().toggle(300);
    e.stopPropagation(); /* Prevents loop from triggerHandler */
  }).parent().next().hide();

  /* Make entire header clickable for better usability */
  $('.collapsible').click(function (e) {
    $(e.currentTarget).children('button').triggerHandler('click');
  });
});

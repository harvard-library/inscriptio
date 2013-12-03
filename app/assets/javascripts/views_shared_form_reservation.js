$(function () {
  /* Get timevals for end_date from DOM */
  var min_time = $('#timevals > .min-time').text();
  var max_time = $('#timevals > .max-time').text();

  /* Skip all this if no relevant form */
  if (!$('.formtastic.reservation').length) {return;}


  /* jQueryUI Datepickers */
  $('#reservation_start_date').datepicker({ minDate: 0 })
  $('#reservation_end_date').datepicker({ minDate: "+" + min_time + "D", maxDate: "+" + max_time + "D" });

  /* Prevent clicks and message if no TOS agreement */
  $('#reserveButton').click(function (e) {
    if (!$('#reservation_tos').prop('checked')) {
      e.preventDefault();
      alert('You must agree to the TOS to reserve a carrel');
    }
  });
});

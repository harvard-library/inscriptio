$(function() {
	$('.collapsable').click(function() {
		$(this).next().toggle(400);
	}).next().hide();
});

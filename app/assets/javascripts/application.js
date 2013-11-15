/*
*= require jquery
*= require jquery.ui.draggable
*= require jquery.ui.resizable
*= require_self
*= require_tree .
*/

// Move to file, rethink
$(function() {
	$('.collapsable').click(function() {
		$(this).next().toggle(400);
	}).next().hide();
});

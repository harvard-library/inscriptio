var floorMap = {
	overlays: [],
	overlay: function (x1, y1, x2, y2, assignedId) {
		id		= 'overlay' + floorMap.overlays.length,
		x1		= x1 || 0,
		y1		= y1 || 0,
		x2		= x2 || x1,
		y2		= y2 || y1,
		assignedId	= assignedId || null;


		var newOverlay = '<div id="overlay' + floorMap.overlays.length + '" class="overlay"' 
			+ ' style="z-index: ' + floorMap.overlays.length + ';' 
			+ ' left: ' + x1 + 'px;'
			+ ' top: ' + y1 + 'px;';
		
		if (x2 != x1 || y2 != y1) {
			newOverlay += ' width: ' + (x2 - x1) + 'px;' + ' height: ' + (y2 - y1) + 'px;'
		}
	
		newOverlay += '"></div>';
		newOverlay = $(newOverlay).data({
		       	'assignedId': assignedId 
		}).bt({
			trigger: 'click',
			contentSelector: "floorMap.tooltip", 
			fill: '#FFF',
			strokeWidth: 4, 
			padding: 20,
			cornerRadius: 15,
			cssClass: 'tooltip',
			closeWhenOthersOpen: true,
			postShow: function() {
				$('#overlayId').val($(this).data('assignedId'));
			}
		});
		
		floorMap.overlays.push(newOverlay);
		return newOverlay;
	},
};

$(function() {
	floorMap.tooltip = '<div><div><label for="overlayId" id="overlayIdLabel">Asset: </label><select id="overlayId">';
	$.each(floorMap.assets, function(i, val) {
		if (val.location.length > 0) {
			$(new floorMap.overlay(
				val.location[0], 
				val.location[1], 
				val.location[2], 
				val.location[3])
			).appendTo('#map').data('assignedId', val.id);
		}
		floorMap.tooltip += '<option value="' + val.id + '">' + val.name + '</option>';
	});
       	floorMap.tooltip += '</select></div><button id="removeOverlay">Remove</button>';
	floorMap.tooltip += '<button id="applyOverlay">Apply</button><button id="closeTooltip">X</button></div>';

	$('#closeTooltip').live('click', function() {
		$('.overlay').btOff();
	});

	$('#removeOverlay').live('click', function() {
		/* Ajax stuff */
		$('.overlay.bt-active').btOff().remove();
	});

	$('#applyOverlay').live('click', function() {
		/* Ajax stuff */
		$('.overlay.bt-active').data({
			assignedId: $('#overlayId').val()
		});
		$('.overlay').btOff();
	});

	$('.overlay').live({
		drag: function(event) {
			$(this).css({
				top: event.pageY - $(this).data('diffY'),
				left: event.pageX - $(this).data('diffX')
			});
		},
		draginit: function(event) {
			$(this).data({
				diffX: event.pageX - $(this).offset().left,
				diffY: event.pageY - $(this).offset().top
			});
		}
	});

	$('#map').mousedown(function(event) {
		if (event.target == this) {
			var newOverlay = new floorMap.overlay( event.pageX, event.pageY );

			$(this).append($(newOverlay)).mousemove(function(event) { 
				/* TODO: Make this work properly. */
				if (event.pageY > parseInt($(newOverlay).css('top')))
					$(newOverlay).css('bottom', $(window).height() - event.pageY);
				else
					$(newOverlay).css('top', event.pageY);
				if (event.pageX > parseInt($(newOverlay).css('left')))
					$(newOverlay).css('right', $(window).width() - event.pageX);
				else
					$(newOverlay).css('left', event.pageX);
			}).one('mouseup', function() {
				$(newOverlay).css({
					width: parseInt($(newOverlay).innerWidth()) + 'px',
					height: parseInt($(newOverlay).innerHeight()) + 'px',
					right: 'auto',
					bottom: 'auto'
				});
			});

		}
	}).mouseup(function() {
		$(this).unbind('mousemove');	
	});

});

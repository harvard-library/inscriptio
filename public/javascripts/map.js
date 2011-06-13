floorMap = {
	overlays: [],
	overlay: function (type, x1, y1, x2, y2, width, height) {
		var type	= type || 'asset',
		id		= 'overlay' + floorMap.overlays.length,
		x1		= x1 || 0,
		y1		= y1 || 0,
		x2		= x2 || this.x1,
		y2		= y2 || this.y1,
		assignedTo	= null;

		var newOverlay = $('<div id="overlay' + floorMap.overlays.length + '" class="overlay ' + type + '"' 
			+ ' style="z-index: ' + floorMap.overlays.length + ';' 
			+ ' left: ' + x1 + 'px;'
			+ ' top: ' + y1 + 'px;'
			+ ' right: ' + ($(window).width() - x2) + 'px;'
			+ ' bottom: ' + ($(window).height() - y2) + 'px;'
			+ '"></div>').data({
			'type': type,
			'assignedTo': assignedTo
			});

		floorMap.overlays.push(newOverlay);
		return newOverlay;
	}
};
$(function() {
	$('#closeTooltip').click(function() {
		$('#tooltip').hide();
	});

	$('#removeOverlay').click(function() {
		$('#' + $('#tooltip').data('currentOverlay')).remove();
		$('#tooltip').hide();
	});

	$('#applyOverlay').click(function() {
		/* Ajax stuff */
		$('#' + $('#tooltip').data('currentOverlay')).data({
			type: $('#overlayType').val(),
			assignedId: $('#overlayId').val()
		});
	});

	$('#map').mousedown(function(event) {
		if (event.target == this) {
			var newOverlay = new floorMap.overlay( $('#overlayType').val(), event.pageX, event.pageY );

			$(this).append($(newOverlay)).mousemove(function(event) { 
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
			$('#tooltip').data({ 'currentoverlay': $(newOverlay).attr('id') });

			$(newOverlay).drag(function(event) {
				$(this).css({
					top: event.pageY - $(this).data('diffY'),
					left: event.pageX - $(this).data('diffX')
				});
			}).bind('draginit', function(event) {
				$(this).data({
					diffX: event.pageX - $(this).offset().left,
				       	diffY: event.pageY - $(this).offset().top
				});
			}).click(function() {
				$('#tooltip').data({ 'currentOverlay': $(this).attr('id') });
				$('#overlayType').val($(this).data('type'));
				$('#overlayId').val($(this).data('assignedId'));
				$('#tooltip').css({
					left: $(this).offset().left + 10 + $(this).outerWidth(),
					top: $(this).offset().top
				}).show();
			});
;
		}
	}).mouseup(function() {
		$(this).unbind('mousemove');	
	});


	$('#overlayType').change(function() {
		var tipBits = {
			'typeVal': 'asset', 
			'typeName': 'Assets',
			'typeCollection': floorMap.assets,
			'oldTypeVal': 'subject'
		};
		if ($(this).val() == 'subject') {
			tipBits = {
				'typeVal': 'subject', 
				'typeName': 'Subjects',
				'typeCollection': floorMap.subjects,
				'oldTypeVal': 'asset'
			};
		}
		$('#' + $('#tooltip').data('currentOverlay')).removeClass(tipBits.oldTypeVal).addClass(tipBits.typeVal);
		$('#overlayIdLabel').html(tipBits.typeName + ': ');
		$('#overlayId').empty();
		for (i in tipBits.typeCollection) {
			$('#overlayId').append(
				'<option value="' + tipBits.typeCollection[i].id + '">' 
				+ tipBits.typeCollection[i].name 
				+ '</option>');
		}
	});
});

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
	},
	tooltip: 
		'<div> <label for="subject">Type: </label> <select id="overlayType" name="overlayType"> <option value="asset">Asset</option> <option value="subject">Subject Area</option> </select> </div> <div> <label for="overlayId" id="overlayIdLabel">Asset: </label> <select id="overlayId"> <option value="1">Carrel 1</option> <option value="2">Carrel 2</option> <option value="3">Carrel 3</option> </select> </div> <button id="removeOverlay">Remove</button> <button id="applyOverlay">Apply</button> <button id="closeTooltip">X</button>',
	updateOverlayDropdown: function() {
		var tipBits = {};
		if ($('#overlayType').val() == 'asset') {
		       	tipBits = {
				'typeVal': 'asset', 
				'typeName': 'Assets',
				'typeCollection': floorMap.assets,
				'oldTypeVal': 'subject'
			};
		} else {
			tipBits = {
				'typeVal': 'subject', 
				'typeName': 'Subjects',
				'typeCollection': floorMap.subjects,
				'oldTypeVal': 'asset'
			};
		}
		$('.bt-active').removeClass(tipBits.oldTypeVal).addClass(tipBits.typeVal);
		$('#overlayIdLabel').html(tipBits.typeName + ': ');
		$('#overlayId').empty();
		for (i in tipBits.typeCollection) {
			$('#overlayId').append(
				'<option value="' + tipBits.typeCollection[i].id + '">' 
				+ tipBits.typeCollection[i].name 
				+ '</option>');
		}
	}
};
$(function() {
	$('#closeTooltip').live('click', function() {
		$('.overlay').btOff();
	});

	$('#overlayType').live('change', function() {
		floorMap.updateOverlayDropdown();
	});

	$('#removeOverlay').live('click', function() {
		$('.overlay.bt-active').btOff().remove();
	});

	$('#applyOverlay').live('click', function() {
		/* Ajax stuff */
		$('.overlay.bt-active').data({
			type: $('#overlayType').val(),
			assignedId: $('#overlayId').val()
		});
		$('.overlay').btOff();
	});

	$('#map').mousedown(function(event) {
		if (event.target == this) {
			var newOverlay = new floorMap.overlay( $('#overlayType').val(), event.pageX, event.pageY );

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
					$('#overlayType').val($(this).data('type'));
					floorMap.updateOverlayDropdown();
					$('#overlayId').val($(this).data('assignedId'));
				}
			});
		}
	}).mouseup(function() {
		$(this).unbind('mousemove');	
	});

});

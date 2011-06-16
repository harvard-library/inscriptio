var floorMap = {
	overlays: [],
	overlay: function (originOffset, x1, y1, x2, y2, assignedId) {
		id		= 'overlay' + floorMap.overlays.length,
		x1		= x1 || 0,
		y1		= y1 || 0,
		x2		= x2 || x1,
		y2		= y2 || y1,
		assignedId	= assignedId || null;

		var newOverlay = '<div id="overlay' + floorMap.overlays.length + '" class="overlay"' 
			+ ' style="z-index: ' + floorMap.overlays.length + ';' 
			+ ' left: ' + (x1 + originOffset.left) + 'px;'
			+ ' top: ' + (y1 + originOffset.top) + 'px;';
		
		if (x2 != x1 || y2 != y1) {
			newOverlay += ' width: ' + (x2 - x1) + 'px;' + ' height: ' + (y2 - y1) + 'px;'
		} else {
			newOverlay += ' right: ' + ($(window).width() - (x1 + originOffset.left)) + 'px;'
				+ ' bottom: ' + ($(window).height() - (y1 + originOffset.top)) + 'px;';
		}
	
		newOverlay += '"></div>';
		newOverlay = $(newOverlay).data({
		       	'assignedId': assignedId 
		}).bt({
			trigger: 'click',
			contentSelector: "floorMap.tooltip", 
			fill: '#FFF',
			strokeWidth: 3, 
			cssClass: 'tooltip',
			closeWhenOthersOpen: true,
			preShow: function() {
				var allAssigned = true;
				$('#overlayId').val($(this).data('assignedId'));
				$.each(floorMap.assets, function(id, asset) {
					if (asset.location.length > 0 && $('.overlay.bt-active').data('assignedId') != id) {
						$('#overlayId option[value=' + id + ']').hide();
					} else {
						$('#overlayId option[value=' + id + ']').show();
						allAssigned = false;
					}
					if (allAssigned) 
						$('#overlayId').attr('disabled', true);
					else 
						$('#overlayId').removeAttr('disabled');
				});
			}
		});
		
		floorMap.overlays.push(newOverlay);
		return newOverlay;
	},
	buildAssets: function() {
		$.each(floorMap.assets, function(i, asset) {
			asset.location = [];
		});

		$('.overlay').each(function(i, overlay) {
			if ($(overlay).data('assignedId')) {
				var mapOffset 	= $('#map').offset(),
				overlay		= $(overlay),
				x1		= overlay.offset().left - mapOffset.left,
				y1		= overlay.offset().top - mapOffset.top,
				x2		= overlay.offset().left + overlay.innerWidth() - mapOffset.left,
				y2		= overlay.offset().top + overlay.innerHeight() - mapOffset.top;

				floorMap.assets[$(overlay).data('assignedId')].location = [x1, y1, x2, y2];
			}
		});
	}
};

$(function() {
	floorMap.tooltip = '<div><div><label for="overlayId" id="overlayIdLabel">Asset: </label><select id="overlayId">';
	$.each(floorMap.assets, function(id, asset) {
		floorMap.tooltip += '<option value="' + id + '"';
		if (asset.location.length > 0) {
			$('#content-right').append(
				new floorMap.overlay(
					$('#map').offset(),
					asset.location[0], 
					asset.location[1], 
					asset.location[2], 
					asset.location[3],
					id
				)
			);
		}
		floorMap.tooltip += '>' + asset.name + '</option>';
	});
	floorMap.tooltip += '</select></div>'
		+ '<div><button id="moveLeft">&#9664</button>' + '<button id="widen">+</button>'
		+ '<button id="narrow">-</button>' + '<button id="moveRight">&#9654</button></div>'
		+ '<div><button id="moveDown">&#9660</button>' + '<button id="heighten">+</button>'
		+ '<button id="shorten">-</button>' + '<button id="moveUp">&#9650</button></div>'
		+ '<button id="removeOverlay">Remove</button>'
		+ '<button id="applyOverlay">Apply</button>'
		+ '<button id="closeTooltip">Close</button>'
		+ '</div>';

	$('#moveLeft').live('click', function() {
		$('.overlay.bt-active').css('left', function(index, value) {
			return parseInt(value) - 1;
		});
	});

	$('#moveRight').live('click', function() {
		$('.overlay.bt-active').css('left', function(index, value) {
			return parseInt(value) + 1;
		});
	});

	$('#moveUp').live('click', function() {
		$('.overlay.bt-active').css('top', function(index, value) {
			return parseInt(value) - 1;
		});
	});
	
	$('#moveDown').live('click', function() {
		$('.overlay.bt-active').css('top', function(index, value) {
			return parseInt(value) + 1;
		});
	});

	$('#widen').live('click', function() {
		$('.overlay.bt-active').css('width', function(index, value) {
			return parseInt(value) + 1;
		});
	});

	$('#narrow').live('click', function() {
		$('.overlay.bt-active').css('width', function(index, value) {
			return parseInt(value) - 1;
		});
	});

	$('#heighten').live('click', function() {
		$('.overlay.bt-active').css('height', function(index, value) {
			return parseInt(value) + 1;
		});
	});

	$('#shorten').live('click', function() {
		$('.overlay.bt-active').css('height', function(index, value) {
			return parseInt(value) - 1;
		});
	});

	$('#closeTooltip').live('click', function() {
		$('.overlay').btOff();
	});

	$('#removeOverlay').live('click', function() {
		/* Ajax stuff */
		if ($('.overlay.bt-active').data('assignedId'))
			floorMap.assets[$('.overlay.bt-active').data('assignedId')].location = [];
		$('.overlay.bt-active').btOff().remove();
	});

	$('#applyOverlay').live('click', function() {
		/* Ajax stuff */
		/* var mapOffset 	= $('#map').offset(),
		overlay		= $('.overlay.bt-active'),
		x1		= overlay.offset().left - mapOffset.left,
		y1		= overlay.offset().top - mapOffset.top,
		x2		= overlay.offset().left + overlay.innerWidth() - mapOffset.left,
		y2		= overlay.offset().top + overlay.innerHeight() - mapOffset.top; */


		//floorMap.assets[$('#overlayId').val()].location = [x1, y1, x2, y2];
		$('.overlay.bt-active').data({ assignedId: $('#overlayId').val() });
		floorMap.buildAssets();
		$('.overlay').btOff();
	});

	$(window).resize(function() {
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
		},
		mouseup: function() {
			$(this).add('#map').unbind('mousemove');
		},
		dblclick: function(event) {
			$('#content-right').append(new floorMap.overlay(
				$(event.target).offset(),
				0,
				0,
				$(event.target).width(),
				$(event.target).height()
			));
		}
	});

	$('#map').mousedown(function(event) {
		if (event.target == this) {
			event.preventDefault();
			var newOverlay = new floorMap.overlay(
				{left: 0, top: 0},
				event.pageX,
				event.pageY
			),
			startX		= event.pageX,
			startY		= event.pageY;

			$('#content-right').append( $(newOverlay) );

			$(this).add(newOverlay).mousemove(function(event) { 
				if (event.pageY > startY)
					$(newOverlay).css('bottom', $(window).height() - event.pageY);
				else
					$(newOverlay).css('top', event.pageY);
				if (event.pageX > startX)
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
		$('#map, .overlay').unbind('mousemove');
	});
});

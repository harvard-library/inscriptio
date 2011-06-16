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
			fill: '#FFF',
			strokeWidth: 3, 
			cssClass: 'tooltip',
			closeWhenOthersOpen: true,
			ajaxPath: '/reservable_assets/' + assignedId + ' div.reservable_asset.show-object dl, p'
		});
		
		floorMap.overlays.push(newOverlay);
		return newOverlay;
	},
};

$(function() {
	$.each(floorMap.assets, function(id, asset) {
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
	});
	$('#closeTooltip').live('click', function() {
		$('.overlay').btOff();
	});

	$(window).resize(function() {
	});
});

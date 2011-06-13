floorMap = {
	newestOverlay: 0,
	overlays: [],
	overlay: function (type, x1, y1, x2, y2, width, height) {
		this.type	= type || 'asset';
		this.id		= 'overlay' + floorMap.overlays.length;
		this.x1		= x1 || 0;
		this.y1		= y1 || 0;
		this.x2		= x2 || this.x1;
		this.y2		= y2 || this.y1;
		this.assignedTo	= null;

		this.getHtml = function() {
			return '<div id="' + this.id + '" class="overlay ' + this.type 
				+ '" style="z-index: ' + floorMap.overlays.length + ';' 
				+ ' left: ' + this.x1 + 'px;'
				+ ' top: ' + this.y1 + 'px;'
				+ ' right: ' + ($(window).width() - this.x2) + 'px;'
				+ ' bottom: ' + ($(window).height() - this.y2) + 'px;'
				+ '"></div>';
		}

		floorMap.overlays.push(this);
		floorMap.newestOverlay = this.id;
	},
};
$(function() {
	$('#removeOverlay').click(function() {
		$('#' + $('#tooltip').data('currentOverlay')).remove();
		$('#tooltip').hide();
	});

	$('#map').mousedown(function(event) {
		if (event.target == this) {
			var newOverlay = new floorMap.overlay(
				'asset', event.pageX, event.pageY
			);
			$(this).append(newOverlay.getHtml()).mousemove(function(event) { 
				var thisOverlay = $('#' + floorMap.newestOverlay);
				if (event.pageY > parseInt($('#' + floorMap.newestOverlay).css('top')))
					$('#' + floorMap.newestOverlay).css('bottom', $(window).height() - event.pageY);
				else
					$('#' + floorMap.newestOverlay).css('top', event.pageY);

				if (event.pageX > parseInt(thisOverlay.css('left')))
					$('#' + floorMap.newestOverlay).css('right', $(window).width() - event.pageX);
				else
					$('#' + floorMap.newestOverlay).css('left', event.pageX);
			}).one('mouseup', function() {
				$('#' + floorMap.newestOverlay).css({
					width: parseInt($('#' + floorMap.newestOverlay).innerWidth()) + 'px',
					height: parseInt($('#' + floorMap.newestOverlay).innerHeight()) + 'px',
					right: 'auto',
					bottom: 'auto'
				});
			});
			$('#tooltip').data({ 'currentoverlay': floorMap.newestOverlay });

			$('#' + floorMap.newestOverlay).drag(function(event) {
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
				$('#overlayType option[value="' + $(this).attr('id')).val();
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


	$('#closeTooltip').click(function() {
		$('#tooltip').hide();
	});
	$('#overlayType').change(function() {
		if ($(this).val() == 'asset') {
			$('#' + $('#tooltip').data('currentOverlay')).removeClass('subject').addClass('asset');
			$('#overlayIdLabel').html('Asset: ');
			$('#overlayId').empty();
			for (i in floorMap.assets) {
				$('#overlayId').append('<option value="' + floorMap.assets[i].id + '">' + floorMap.assets[i].name + '</option>');
			}
		}
		else {
			$('#' + $('#tooltip').data('currentOverlay')).removeClass('asset').addClass('subject');
			$('#overlayIdLabel').html('Subject: ');
			$('#overlayId').empty();
			for (i in floorMap.subjects) {
				$('#overlayId').append('<option value="' + floorMap.subjects[i].id + '">' + floorMap.subjects[i].name + '</option>');
			}
		}
	});
});

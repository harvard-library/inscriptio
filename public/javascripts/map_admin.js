(function ($) {

	var defaults = {
		containerSelector: '#map',
		origin: $('#map').offset(),
		parentSelector: '#content-right',
		overlayClass: 'overlay',
		activeOverlaySelector: '.bt-active',
		admin: false,
		assets: null
	},

	floormapMethods = {
		init: function(options) {
			var $this = $(this), data = $this.data('floormap');

			if (!data) {
				$this.data('floormap', {
					initialized: true
				});
				defaults.origin = $(defaults.containerSelector).offset();

				$.ajax({
					type: 'GET',
					url: window.location.href + '/assets',
					dataType: 'json',
					error: function(){},
					success: function(data) {
						defaults.assets = data;
						$.each(data, function(index, asset) {
							if (asset.x1 && asset.y1 && asset.x2 && asset.y2) 
								overlayMethods.create( defaults.origin, asset.x1, asset.y1, asset.x2, asset.y2, asset.id);
						});
					}
				});

				$.each(
					[
						['#moveUp', 'top', -1],
						['#moveRight', 'left', 1],
						['#moveDown', 'top', 1],
						['#moveLeft', 'left', -1],
						['#widen', 'width', 1],
						['#narrow', 'width', -1],
						['#heighten', 'height', 1],
						['#shorten', 'height', -1]
					],
					function(index, value) {
						var button = value[0], attr = value[1], delta = value[2];
						$(button).live('click.floormap', function() {
							$('.' + defaults.overlayClass + '.bt-active').css(attr, function(index, value) {
								return parseInt(value) + delta;
							});
						});
					}
				);

				$('#closeTooltip').live('click.floormap', function() {
					$('.overlay').btOff();
				});

				$('#removeOverlay').live('click.floormap', function() {
					overlayMethods.destroy();
				});

				$('#applyOverlay').live('click.floormap', function() {
					overlayMethods.update($('#overlayId').val());
				});

				$(window).resize(function() {
				});

				$('.' + defaults.overlayClass).live({
					'drag.floormap': function(event) {
						$(this).css({
							top: event.pageY - $(this).data('diffY'),
							left: event.pageX - $(this).data('diffX')
						});
					},
					'draginit.floormap': function(event) {
						$(this).data({
							diffX: event.pageX - $(this).offset().left,
							diffY: event.pageY - $(this).offset().top
						});
					},
					'mouseup.floormap': function() {
						$(this).add('#map').unbind('mousemove');
					},
					'dblclick.floormap': function(event) {
						overlayMethods.create(
							$(event.target).offset(),
							parseInt($(event.target).width() * 0.25),
							parseInt($(event.target).height() * 0.25),
							parseInt($(event.target).width() * 1.25),
							parseInt($(event.target).height() * 1.25)
						);
					}
				});

				$(defaults.containerSelector).bind({
					'mousedown.floormap': function(event) {
						if (event.target == this) {
							event.preventDefault();

							var newOverlay = overlayMethods.create(
								{left: 0, top: 0},
								event.pageX,
								event.pageY
							),
							startX = event.pageX,
							startY = event.pageY;

							$(this).add(newOverlay).bind('mousemove.floormap', function(event) { 
								if (event.pageY > startY)
									$(newOverlay).css('bottom', $(window).height() - event.pageY);
								else
									$(newOverlay).css('top', event.pageY);
								if (event.pageX > startX)
									$(newOverlay).css('right', $(window).width() - event.pageX);
								else
									$(newOverlay).css('left', event.pageX);
							}).one('mouseup.floormap', function() {
								$(newOverlay).css({
									width: parseInt($(newOverlay).innerWidth()) + 'px',
									height: parseInt($(newOverlay).innerHeight()) + 'px',
									right: 'auto',
									bottom: 'auto'
								});
							});
						}
					},
					'mouseup.floormap': function() {
						$(defaults.containerSelector + ', .' + defaults.overlayClass).unbind('mousemove.floormap');
					}
				});
			}
		},

		buildTooltipAssetOptions: function() {
			var newOptions = '';
			$.each(defaults.assets, function(index, asset) {
				if (asset.x1 && $(defaults.activeOverlaySelector).data('assignedAssetId') == asset.id) {
					newOptions += '<option selected="selected" value="' + asset.id + '">' 
						+ asset.name + '</option>';
				} else if (!asset.x1) {
					newOptions += '<option value="' + asset.id + '">' 
						+ asset.name + '</option>';
				}
			});
			$('#overlayId').html(newOptions);
			if (newOptions == '') {
				$('#overlayId').attr('disabled', true);
			} else {
				$('#overlayId').removeAttr('disabled');
			}
		},

		/* This is so goddamned ugly */
		syncOverlaysToAssets: function() {
			$.each(defaults.assets, function(i, asset) {
				defaults.assets[i].x1 = null;
				defaults.assets[i].y1 = null;
				defaults.assets[i].x2 = null;
				defaults.assets[i].y2 = null;
				$('.overlay').each(function(j, overlay) {
					if ($(overlay).data('assignedAssetId') == asset.id) {
						var mapOffset = $('#map').offset(), overlay = $(overlay);
						defaults.assets[i].x1 = overlay.offset().left - mapOffset.left;
						defaults.assets[i].y1 = overlay.offset().top - mapOffset.top;
						defaults.assets[i].x2 = 
							overlay.offset().left + overlay.innerWidth() - mapOffset.left;
						defaults.assets[i].y2 = 
							overlay.offset().top + overlay.innerHeight() - mapOffset.top;
					}
				});
			});
		},
	},

	overlayMethods = {
		create: function (originOffset, x1, y1, x2, y2, assignedAssetId) {
			var $this = $(this),
			originOffset = originOffset || {left: 0, top: 0},
			id = 'overlay' + $('.overlay').length,
			x1 = x1 || 0,
			y1 = y1 || 0,
			x2 = x2 || x1,
			y2 = y2 || y1,
			assignedAssetId = assignedAssetId || null,
			ajaxPath = null;

			if (assignedAssetId)
				ajaxPath = '/reservable_assets/' + assignedAssetId + '/edit';

			var newOverlay = '<div id="overlay' + $('.overlay').length + '" class="overlay"' 
				+ ' style="z-index: ' + $('.overlay').length + ';' 
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
				'assignedAssetId': assignedAssetId,
				'x1': x1,
				'y1': y1,
				'x2': x2,
				'y2': y2
			}).bt({
				trigger: 'click',
				'ajaxPath': ajaxPath,
				fill: '#FFF',
				strokeWidth: 3, 
				cssClass: 'tooltip',
				closeWhenOthersOpen: true,
				contentSelector: function() {
					return $('#tooltipTools').html();
				},
				preBuild: function() {
					defaults.activeOverlaySelector = '#' + $(this).attr('id');
					floormapMethods.buildTooltipAssetOptions();
				},
				preShow: function() {
				},
				preHide: function() {
					if ($('.bt-content').html()) {
						$('#tooltip').html($('.bt-content').html());
					}
					defaults.activeOverlaySelector = '.bt-active';
				},
				ajaxLoading: '<img src="/images/ajax-loader.gif" alt="Loading..." />',
				ajaxOpts: {
					complete: function(data) {
						$('.bt-content').prepend($('#tooltip').html());
					}
				}
			});
			
			return newOverlay.appendTo(defaults.parentSelector);
		},

		getCoords: function() {

		},

		update: function(assignedAssetId) {
			$(defaults.activeOverlaySelector).data('assignedAssetId', assignedAssetId);
			floormapMethods.syncOverlaysToAssets();
			$('#tooltipTools').hide();
			$('#loading').show();

			$.ajax({
				url: '/reservable_assets/' + $(defaults.activeOverlaySelector).data('assignedAssetId') + '/edit',
				success: function(data) {
					var mapOffset = $('#map').offset(), overlay = $(defaults.activeOverlaySelector);
					$('.bt-content').append(data);
					$('#reservable_asset_x1').val(overlay.offset().left - mapOffset.left);
					$('#reservable_asset_y1').val(overlay.offset().top - mapOffset.top);
					$('#reservable_asset_x2').val(overlay.offset().left + overlay.width() - mapOffset.left);
					$('#reservable_asset_y2').val(overlay.offset().top + overlay.height() - mapOffset.top);
					$('#edit_reservable_asset_' + overlay.data('assignedAssetId')).submit();
					$('.' + defaults.overlayClass).btOff();
					$('#loading').hide();
					$('#tooltipTools').show();
				}
			});
		},

		destroy: function() {
			if ($(defaults.activeOverlaySelector).data('assignedAssetId')) {
				$.ajax({
					url: '/reservable_assets/' + $(defaults.activeOverlaySelector).data('assignedAssetId') + '/edit',
					success: function(data) {
						$('.bt-content').append(data);
						$('#reservable_asset_x1, #reservable_asset_y1, #reservable_asset_x2 #reservable_asset_y2').val('');
						$('#edit_reservable_asset_' + $(defaults.activeOverlaySelector).data('assignedAssetId')).submit();
						$('.overlay.bt-active').btOff().remove();
						$('#loading').hide();
						$('#tooltipTools').show();
					}
				});
			}
			floormapMethods.syncOverlaysToAssets();
		}
	}

	$.fn.floormap = function( method ) {
		if ( floormapMethods[method] ) {
		  return floormapMethods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
		  return floormapMethods.init.apply( this, arguments );
		} else {
		  $.error( 'Method ' + method + ' does not exist on jQuery.floormap' );
		}    
	};

})(jQuery);

$(function() {
	$('#map').floormap();
});

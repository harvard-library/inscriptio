(function ($) {

	var opts = {
		containerSelector: '#map',
		origin: {left: 0, top: 0},
		parentSelector: '#content-right',
		overlayClass: 'overlay',
		notReservableClass: 'full',
		activeOverlaySelector: '.bt-active',
		admin: false,
		assets: []
	},

	methods = {
		/**** Start this whole business ****/
		init: function(options) {

			/* Overwrite any default options with those passed in */
			$.extend(opts, options);

			return this.each(function() {
				if (!$(this).data('floormap')) {
					$(this).data('floormap', {
						initialized: true
					});

					/* Drop the HTML into the document if it's not there already */
					if (opts.admin) {
						methods.addHtml();
					}
					methods.bindEventHandlers();

					/* Set the origin to create the overlays against */
					opts.origin = $(opts.containerSelector).offset();

					/* Get the asset info and create the overlays */
					$.ajax({
						type: 'GET',
						url: window.location.href + '/assets',
						dataType: 'json',
						error: function(){},
						success: function(data) {
							opts.assets = data;
							$.each(data, function(index, asset) {
								if (asset.x1 && asset.y1 && asset.x2 && asset.y2) 
									overlay.create(opts.origin, asset.x1, asset.y1, asset.x2, asset.y2, asset.id, asset.allow_reservation);
							});
						}
					});

				}
			});
		},

		/**** Add all the required HTML ****/
		/* I put this here instead of in the view so if javascript is off
		 * the user doesn't get useless markup. */
		addHtml: function() {
			$(opts.containerSelector).append(
				'<div id="tooltip">' + 
					'<div id="loading">' + 
						'<img src="/images/ajax-loader.gif" alt="Loading" />' + 
					'</div>' + 
					'<div id="tooltipTools">' + 
						'<label for="overlayId" id="overlayIdLabel">Asset: </label>' + 
						'<select id="overlayId"></select>' + 
						'<br />' + 
						'<button id="moveLeft">&#9664</button>' + 
						'<button id="narrow">-</button>' + 
						'<button id="widen">+</button>' + 
						'<button id="moveRight">&#9654</button>' + 
						'<br />' + 
						'<button id="moveDown">&#9660</button>' + 
						'<button id="shorten">-</button>' + 
						'<button id="heighten">+</button>' + 
						'<button id="moveUp">&#9650</button>' + 
						'<br />' + 
						'<button id="removeOverlay">Remove</button>' + 
						'<button id="applyOverlay">Apply</button>' + 
						'<button id="closeTooltip">Close</button>' + 
					'</div>' + 
				'</div>' 
			);
		},

		/**** Bind all the event handlers ****/
		/* This just broken out for clarity */
		bindEventHandlers: function() {
			/* These are all the tooltip buttons */

			$('#closeTooltip').live('click.floormap', function() {
				$(opts.activeOverlaySelector).btOff();
			});

			if (opts.admin) {
				$('#removeOverlay').live('click.floormap', function() {
					overlay.destroy();
				});

				$('#applyOverlay').live('click.floormap', function() {
					overlay.update($('#overlayId').val());
				});

				$.each( [
					['#moveUp', 'top', -1],
					['#moveRight', 'left', 1],
					['#moveDown', 'top', 1],
					['#moveLeft', 'left', -1],
					['#widen', 'width', 1],
					['#narrow', 'width', -1],
					['#heighten', 'height', 1],
					['#shorten', 'height', -1]],

					function(index, value) {
						var button = value[0], attr = value[1], delta = value[2];
						$(button).live('click.floormap', function() {
							$(opts.activeOverlaySelector).css(attr, function(index, value) {
								return parseInt(value) + delta;
							});
						});
					}
				);

				/* TODO: add window resizing support */
				$(window).resize(function() {
				});


				/* These are the handlers for the overlays */
				$('.' + opts.overlayClass).live({
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
						overlay.create(
							$(event.target).offset(),
							parseInt($(event.target).width() * 0.25),
							parseInt($(event.target).height() * 0.25),
							parseInt($(event.target).width() * 1.25),
							parseInt($(event.target).height() * 1.25)
						);
					}
				});

				/* These are the handlers for the "map" */
				$(opts.containerSelector).bind({
					'mousedown.floormap': function(event) {
						if (event.target == this) {
							event.preventDefault();

							var newOverlay = overlay.create(
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
						$(opts.containerSelector + ', .' + opts.overlayClass).unbind('mousemove.floormap');
					}
				});
			}
		},

		/**** Build the option list for the Asset ID dropdown in the tooltip ****/
		/* This makes sure an asset can't be assigned to two physical locations */
		buildTooltipAssetOptions: function() {
			var newOptions = '';
			$.each(opts.assets, function(index, asset) {
				if (asset.x1 && $(opts.activeOverlaySelector).data('assignedAssetId') == asset.id) {
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

		/**** This keeps the "assets" object in sync with the overlays ****/
		/* This is so goddamned ugly */
		/* TODO: Factor this function out of existence */
		syncAssetsToOverlays: function() {
			$.each(opts.assets, function(i, asset) {
				opts.assets[i].x1 = null;
				opts.assets[i].y1 = null;
				opts.assets[i].x2 = null;
				opts.assets[i].y2 = null;
				$('.' + opts.overlayClass).each(function(j, overlay) {
					if ($(overlay).data('assignedAssetId') == asset.id) {
						var overlay = $(overlay);
						opts.assets[i].x1 = overlay.offset().left - opts.origin.left;
						opts.assets[i].y1 = overlay.offset().top - opts.origin.top;
						opts.assets[i].x2 = overlay.offset().left + overlay.innerWidth() - opts.origin.left;
						opts.assets[i].y2 = overlay.offset().top + overlay.innerHeight() - opts.origin.top;
					}
				});
			});
		},
	},

	overlay = {
		/**** Create an overlay ****/
		/* The origin argument is only used for real when an admin drags on the map */
		create: function (origin, x1, y1, x2, y2, assignedAssetId, reservable) {
			var id = 'overlay' + $('.' + opts.overlayClass).length,
			origin = origin || opts.origin,
			x1 = x1 || 0,
			y1 = y1 || 0,
			x2 = x2 || x1,
			y2 = y2 || y1,
			assignedAssetId = assignedAssetId || null,

			newOverlay = '<div id="' + id + '" class="' + opts.overlayClass;

			/* Add a class if the asset is not reservable (full or whatever) */
			if (reservable === false) 
				newOverlay += ' ' + opts.notReservableClass;

			newOverlay += '"'
				+ ' style="z-index: ' + $('.' + opts.overlayClass).length + ';' 
				+ ' left: ' + (x1 + origin.left) + 'px;'
				+ ' top: ' + (y1 + origin.top) + 'px;';
			
			if (x2 != x1 || y2 != y1) {
				newOverlay += ' width: ' + (x2 - x1) + 'px;' + ' height: ' + (y2 - y1) + 'px;'
			} else {
				newOverlay += ' right: ' + ($(window).width() - (x1 + origin.left)) + 'px;'
					+ ' bottom: ' + ($(window).height() - (y1 + origin.top)) + 'px;';
			}
		
			newOverlay += '"></div>';
			/* These location values aren't being used anywhere yet */
			newOverlay = $(newOverlay).data({
				'assignedAssetId': assignedAssetId,
				'x1': x1,
				'y1': y1,
				'x2': x2,
				'y2': y2
			});
			
			/* Change the tooltip depending on user role */
			if (opts.admin) {
				var contentSelector = function() {
					var html = $('#tooltip').html();
					$('#tooltip').empty();
					return html;
				},
				ajaxPath = null,
				/* These shenanigans go on so we don't end up with two elements with the same ID */
				preShow = function() {
					opts.activeOverlaySelector = '#' + $(this).attr('id');
					methods.buildTooltipAssetOptions();
				},
				preHide = function() {
					if ($('.bt-content').html()) {
						$('#tooltip').html($('.bt-content').html());
					}
					opts.activeOverlaySelector = '.bt-active';
				};
			}
			else {
				var contentSelector = null,
				ajaxPath = '/reservable_assets/' + assignedAssetId + ' div.reservable_asset.show-object dl, p',
				preShow = function(){},
				preHide = function(){};
			}

			newOverlay.bt({
				trigger: 'click',
				fill: '#FFF',
				strokeWidth: 3, 
				cssClass: 'tooltip',
				closeWhenOthersOpen: true,
				'ajaxPath': ajaxPath,
				'contentSelector': contentSelector,
				'preShow': preShow,
				'preHide': preHide
			});
			
			return newOverlay.appendTo(opts.parentSelector);
		},

		/**** Get the coordinates of an overlay ****/
		getCoords: function() {

		},

		/**** Update an overlay (assign it an asset ID) ****/
		update: function(assignedAssetId) {
			var overlay = $(opts.activeOverlaySelector);
			overlay.data('assignedAssetId', assignedAssetId);
			methods.syncAssetsToOverlays();
			$('#tooltipTools').hide();
			$('#loading').show();

			$.ajax({
				url: '/reservable_assets/' + overlay.data('assignedAssetId') + '/edit',
				success: function(data) {
					$('.bt-content').append(data);
					$('#reservable_asset_x1').val(overlay.offset().left - opts.origin.left);
					$('#reservable_asset_y1').val(overlay.offset().top - opts.origin.top);
					$('#reservable_asset_x2').val(overlay.offset().left + overlay.width() - opts.origin.left);
					$('#reservable_asset_y2').val(overlay.offset().top + overlay.height() - opts.origin.top);
					$('#edit_reservable_asset_' + overlay.data('assignedAssetId')).submit();
					overlay.btOff();
					$('#loading').hide();
					$('#tooltipTools').show();
				},
				error: function(response) {
				}
			});
		},

		/**** Make an overlay go away ****/
		destroy: function() {
			var overlay = $(opts.activeOverlaySelector);
			if (overlay.data('assignedAssetId')) {
				$('#tooltipTools').hide();
				$('#loading').show();
				$.ajax({
					url: '/reservable_assets/' + overlay.data('assignedAssetId') + '/edit',
					success: function(data) {
						$('.bt-content').append(data);
						$('#reservable_asset_x1, #reservable_asset_y1, #reservable_asset_x2 #reservable_asset_y2').val('');
						$('#edit_reservable_asset_' + overlay.data('assignedAssetId')).submit();
						overlay.btOff().remove();
						$('#loading').hide();
						$('#tooltipTools').show();
					},
					error: function(response) {
						$('.bt-content').html(response.responseText);
					}
				});
			}
			else {
				overlay.btOff().remove();
			}
			methods.syncAssetsToOverlays();
		}
	}

	/**** Register the floormap plugin ****/
	$.fn.floormap = function( method ) {
		if ( methods[method] ) {
		  return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
		  return methods.init.apply( this, arguments );
		} else {
		  $.error( 'Method ' + method + ' does not exist on jQuery.floormap' );
		}    
	};

})(jQuery);

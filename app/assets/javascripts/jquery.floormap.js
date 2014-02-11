(function ($) {

	var opts = {
		containerSelector: '#map-container',
		origin: {left: 0, top: 0},
		parentSelector: '#content-right',
		overlayClass: 'overlay',
		notReservableClass: 'full',
		activeOverlaySelector: '.bt-active',
		admin: false,
		dupVertMargin: 5,
		dupHoriMargin: 0,
		assets: []
	},

	methods = {
		/**** Start this whole business ****/
		init: function(options) {

			/* Overwrite any default options with those passed in */
			$.extend(opts, options);

            if (typeof $.rootPath == 'undefined') {
                $.extend({ rootPath: function() { return '/'; } });
            }

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
						error: function(response) {
							if (response.status != 404) {
						    	alert('Error retrieving assets: ' + response.status);
								if (typeof console != 'undefined')
									console.log(response.responseText);
							}
						},
						success: function(data) {
							opts.assets = data;
							$.each(data, function(index, asset) {
								if (asset.x1 && asset.y1 && asset.x2 && asset.y2) {
									overlays.create(
										opts.origin,
									   	asset.x1,
									   	asset.y1,
									   	asset.x2,
									   	asset.y2,
									   	asset.id,
									   	asset.allow_reservation,
										true
									);
								}
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
			$(opts.parentSelector).append(
        '<div id="tooltip">' +
          '<div id="loading">' +
            '<img src="/images/ajax-loader.gif" alt="Loading" />' +
          '</div>' +
          '<div id="tooltipTools">' +
            '<label for="overlayId" id="overlayIdLabel">Asset: </label>' +
            '<select id="overlayId"></select>' +
            '<button id="closeTooltip">x</button>' +
            '<br />' +
            '<div id="movers">' +
              '<button class="nudger" id="moveUp" title="w">&#9650</button>' +
              '<br />' +
              '<button class="nudger" id="moveLeft" title="a">&#9668</button>' +
              '<button class="nudger" id="moveRight" title="d">&#9658</button>' +
              '<br />' +
              '<button class="nudger" id="moveDown" title="s">&#9660</button>' +
            '</div>' +
            '<div id="sizers">' +
              '<button class="nudger" id="shorten" title="i">&ndash;</button>' +
              '<br />' +
              '<button class="nudger" id="narrow" title="j">&ndash;</button>' +
              '<button class="nudger" id="widen" title="l">+</button>' +
              '<br />' +
					    '<button class="nudger" id="heighten" title="k">+</button>' +
					  '</div>' +
					  '<div id="overlayButtons">' +
					    '<button id="removeOverlay">Remove</button>' +
					    '<button id="copyOverlay">Copy</button>' +
					    '<button id="applyOverlay">Apply</button>' +
					  '</div>' +
            '<div style="margin:20px auto 0;text-align:center">' +
              '<button id="showSelectedAsset">Go to Asset</button>' +
            '</div>' +
					'</div>' +
				'</div>'
			);
		},

		/**** Bind all the event handlers ****/
		/* This just broken out for clarity */
		bindEventHandlers: function() {

			$(document).on('click.floormap', '#closeTooltip', function() {
				$(opts.activeOverlaySelector).btOff();
			});

			/* Make sure the overlays stay in place when the window is resized */
			$(window).resize(function() {
				opts.origin = $(opts.containerSelector).offset();
				$('.' + opts.overlayClass).each(function() {
					$(this).css({
						top: $(this).data('y1') + opts.origin.top,
						left: $(this).data('x1') + opts.origin.left
					});
				});
			});


			/* These are all the event handlers specific to the admin stuff */
			if (opts.admin) {
				$(document).on('click.floormap', '#removeOverlay', function() {
					overlays.destroy();
				});

				$(document).on('click.floormap', '#applyOverlay', function() {
					overlays.update($('#overlayId').val());
				});

        /* Duplicates carrel on double click */
        $(document).on('dblclick.floormap', '.' + opts.overlayClass, function(event) {
 		      var target = $(event.target);
 		      overlays.create(
 			      opts.origin,
 			      target.data('x1') + opts.dupHoriMargin,
 			      target.data('y1') + target.height() + opts.dupVertMargin,
 			      target.data('x2') + opts.dupHoriMargin,
 			      target.data('y2') + target.height() + opts.dupVertMargin
 		      );
 		      $(opts.activeOverlaySelector).btOff();
 	      });

				$(document).on('click.floormap', '#copyOverlay', function() {
					var target = $(opts.activeOverlaySelector);
					overlays.create(
						opts.origin,
						target.data('x1') + opts.dupHoriMargin,
						target.data('y1') + target.height() + opts.dupVertMargin,
						target.data('x2') + opts.dupHoriMargin,
						target.data('y2') + target.height() + opts.dupVertMargin
					);
					target.btOff();
				});

        $(document).on('change.floormap', '#overlayId', function() {
          $('#applyOverlay').removeAttr('disabled');
        });

        /* Control overlay positioning with buttons */
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
						$(document).on('click.floormap', button,  function() {
							$(opts.activeOverlaySelector).data('saved', false);
							$('#applyOverlay').removeAttr('disabled');
							$(opts.activeOverlaySelector).css(attr, function(index, value) {
								return parseInt(value) + delta;
							});
						});
					}
				);

        /* Go to Asset button in tooltip */
        $(document).on('click', '#showSelectedAsset', function (e) {
          var id = $(e.currentTarget).parents('#tooltipTools').find('select#overlayId').val();
          if (id) {
            window.location.href = '/reservable_assets/' + id;
          }
          else {
            return false;
          }
        });

				/* Add a few keypress handlers to make it easier to move overlays around */
				$(document).keypress(function(event) {
					switch (event.which) {
						case 119:
							$('#moveUp').click();
							break;
						case 97:
							$('#moveLeft').click();
							break;
						case 100:
							$('#moveRight').click();
							break;
						case 115:
							$('#moveDown').click();
							break;
						case 105:
							$('#shorten').click();
							break;
						case 107:
							$('#heighten').click();
							break;
						case 106:
							$('#narrow').click();
							break;
						case 108:
							$('#widen').click();
					}
				});


				/* These are the handlers for the "map" */
				$(opts.containerSelector).bind({
					'mousedown.floormap': function(event) {
						if (event.currentTarget == this) {
							event.preventDefault();

							var newOverlay = overlays.create(
								{left: opts.origin.left, top: opts.origin.top},
								event.pageX - opts.origin.left,
								event.pageY - opts.origin.top
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
								}).data({
									x2: $(this).data('x1') + $(this).width(),
									y2: $(this).data('y1') + $(this).height()
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
		/* TODO: Do this a better way */
		syncAssetsToOverlays: function() {
			$.each(opts.assets, function(i, asset) {
				opts.assets[i].x1 = null;
				opts.assets[i].y1 = null;
				opts.assets[i].x2 = null;
				opts.assets[i].y2 = null;
				$('.' + opts.overlayClass).each(function(j, overlay) {
					if ($(overlay).data('assignedAssetId') == asset.id) {
						var coords = overlays.getCoords($(overlay));
						opts.assets[i].x1 = coords.x1;
						opts.assets[i].y1 = coords.y1;
						opts.assets[i].x2 = coords.x2;
						opts.assets[i].y2 = coords.y2;
					}
				});
			});
		}
	},

	overlays = {
		/**** Create an overlay ****/
		/* The origin argument is only used for real when an admin drags on the map */
		create: function (origin, x1, y1, x2, y2, assignedAssetId, reservable, saved) {
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
				'saved': saved,
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
					if ($('#overlayId').attr('disabled') || $(opts.activeOverlaySelector).data('saved') == true)
						$('#applyOverlay').attr('disabled', true);
					else
						$('#applyOverlay').removeAttr('disabled');
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
				ajaxPath = $.rootPath() + 'reservable_assets/' + assignedAssetId + ' #content-right > *',
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
      /* Following block is order-dependent in Webkit
       * Everything explodes if draggable is called before overlay is added to the dom */
			newOverlay.appendTo(opts.parentSelector);
      if (opts.admin) {
        newOverlay.draggable({
          containment: opts.containerSelector,
          drag: function (e,ui) {
            ui.position.top -= $( 'html' ).scrollTop();
          },
          start: function (e, ui) {
	          $(e.currentTarget).data('saved', false);
          },
          end: function (e, ui) {
            $(e.currentTarget).data(overlays.getCoords(this));
 	        },
        })
      }
      return newOverlay;
		},

		/**** Get the coordinates of an overlay ****/
		getCoords: function(overlay) {
			overlay = overlay || $(opts.activeOverlaySelector);
			if (!overlay.jquery)
				overlay = $(overlay);

			return {
				x1: overlay.offset().left - opts.origin.left,
				y1: overlay.offset().top - opts.origin.top,
				x2: overlay.offset().left + overlay.width() - opts.origin.left,
				y2: overlay.offset().top + overlay.height() - opts.origin.top
			}
		},

		/**** Update an overlay (assign it an asset ID) ****/
		update: function(assignedAssetId) {
			$(opts.activeOverlaySelector).data('assignedAssetId', assignedAssetId);
			methods.syncAssetsToOverlays();

			$.each(opts.assets, function(i, asset) {
                if (asset.id == assignedAssetId) {
                    $('#tooltipTools').hide();
                    $('#loading').show();

                    $.ajax({
                        url: $.rootPath() + 'reservable_assets/' + asset.id + '/locate',
                        data: {
                            'reservable_asset[x1]': asset.x1,
                            'reservable_asset[y1]': asset.y1,
                            'reservable_asset[x2]': asset.x2,
                            'reservable_asset[y2]': asset.y2
                        },
                        success: function(data) {
                            $(opts.activeOverlaySelector).data('saved', true);
                            $('.' + opts.overlayClass).btOff();
                            $('#loading').hide();
                            $('#tooltipTools').show();
                        },
                        error: function(response) {
                            $('.bt-content').html('Error updating asset: ' + response.status);
                            if (typeof console != 'undefined')
                                console.log(response.responseText);
                        }
                    });
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
					url: $.rootPath() + 'reservable_assets/' + overlay.data('assignedAssetId') + '/locate',
					data: {
						'reservable_asset[x1]': null,
						'reservable_asset[y1]': null,
						'reservable_asset[x2]': null,
						'reservable_asset[y2]': null
					},
					success: function(data) {
						overlay.btOff().remove();
						$('#loading').hide();
						$('#tooltipTools').show();
						methods.syncAssetsToOverlays();
					},
					error: function(response) {
						$('.bt-content').html('Error removing asset location: ' + response.status);
						if (typeof console != 'undefined')
							console.log(response.responseText);
					}
				});
			}
			else {
				overlay.btOff().remove();
			}
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

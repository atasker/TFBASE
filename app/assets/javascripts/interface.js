$(document).ready(function() {

	//MAIN-TOP-SLIDER
	if ($('.main-top__slider').length>0) {
		main_top_slider = $('.main-top__slider');
		// main_top_slider.on('init', function(){
  //   	   $('.slick-dots').insertBefore($('.main-top__events-title'))
	 //    });
		main_top_slider.slick({
			fade: true,
			dots:true,
			arrows: false,
			useTransform:true,
			accessibility: false,
			customPaging: function(slider, i) {
                return '<a href="javascript:void(0)">' + (i + 1) + '</a>';
            },
		});
	};

	//SUBMENU TOGGLE
	$("body").on("click", "#category-submenu-btn", function(e){
		e.preventDefault();
		$("header .menu-btn").toggleClass('active');
		$('.top-submenu').fadeToggle();
		$('body').toggleClass('fix');
	})


	if ($('.main-featured__slider').length>0) {
		$('.main-featured__slider').slick({
			infinite: true,
			slidesToShow: 4,
			slidesToScroll: 1,
			dots:false,
			useTransform:true,
			accessibility: false,
			responsive: [
			    {
			      	breakpoint: 1100,
						settings: {
							slidesToShow: 3,
							slidesToScroll: 1,
						}
			    },
			    {
			      	breakpoint: 850,
						settings: {
							slidesToShow: 2,
							slidesToScroll: 1,
						}
			    },
			    {
			      	breakpoint: 700,
						settings: {
							slidesToShow: 1,
							slidesToScroll: 1,
						}
			    },
		  	]
		});
	};

	if ($('.main-popular-events__slider').length>0) {
		$('.main-popular-events__slider').slick({
			infinite: true,
			slidesToShow: 2,
			slidesToScroll: 1,
			dots:false,
			useTransform:true,
			accessibility: false,
			responsive: [
			    {
			      	breakpoint: 850,
						settings: {
							slidesToShow: 1,
							slidesToScroll: 1,
						}
			    },
		  	]
		});
	};

	if ($('.main-services__slider').length>0) {
		$('.main-services__slider').slick({
			infinite: true,
			slidesToShow: 9,
			slidesToScroll: 3,
			dots:false,
			useTransform:true,
			accessibility: false,
			autoplay: true,
  			autoplaySpeed: 2000,
			responsive: [
			    {
			    	breakpoint: 1100,
					settings: {
						slidesToShow: 7,
						slidesToScroll: 2,
						infinite: true,
					}
			    },
			    {
			    	breakpoint: 850,
					settings: {
						slidesToShow: 5,
						slidesToScroll: 3,
						arrows:false,
						centerMode: true,
						infinite: true,
					}
			    },
			    {
			    	breakpoint: 700,
					settings: {
						slidesToShow: 4,
						slidesToScroll: 2,
						arrows:false,
						centerMode: true,
						infinite: true,
					}
			    },
			    {
			    	breakpoint: 550,
					settings: {
						slidesToShow: 2,
						slidesToScroll: 1,
						arrows:false,
						centerMode: false,
						infinite: true,
					}
			    },
		  	]
		});
	};

	if ($('.fs').length>0) {
		$('.fs').styler();
	};


	if ($('#map').length>0) {
		initMap();
	};


	if ($(".nano").length>0) {
		$(".nano").nanoScroller();
	};

	//show more or less text TOGGLE
	$("body").on("click", ".read-more", function(e){
		e.preventDefault();
		var previewer = $(this).closest('.info-preview');
		if (previewer.length) {
			var fuller = previewer.next();
			if (fuller.hasClass('info-full')) {
				previewer.hide();
				fuller.show();
			}
		}
	});
	$("body").on("click", ".read-less", function(e){
		e.preventDefault();
		var fuller = $(this).closest('.info-full');
		if (fuller.length) {
			var previewer = fuller.prev();
			if (previewer.hasClass('info-preview')) {
				fuller.hide();
				previewer.show();
			}
		}
	});


	//tickets info TOGGLE
	$("body").on("click", ".tickets__info-link", function(e){
		$(this).toggleClass('active');
		$(this).next('.tickets__info-txt').slideToggle();
		e.preventDefault();
	})

	//POPUP-INLINE
    $('.popup-inline').magnificPopup({
    	type:'inline',
    	closeBtnInside: false,
    	callbacks: {
		    beforeOpen: function() {
		       this.st.mainClass = this.st.el.attr('data-effect');
		    }
		 },
    });
    $('.popup-chart').magnificPopup({
    	type:'inline',
    	closeBtnInside: false,
    	callbacks: {
		    beforeOpen: function() {
		       this.st.mainClass = this.st.el.attr('data-effect');
		    }
		 },
    });


    //mobile-list TOGGLE
	$("body").on("click", ".mobile-link", function(e){
		e.preventDefault();
		$('.page-header__info--mobile-list').fadeIn();
	});
	$("body").on("click", ".page-header__info--mobile__close", function(e){
		e.preventDefault();
		$('.page-header__info--mobile-list').fadeOut();
	});

	//EVENTS MOBILE TABS
	$('.accordion-tabs').children('li').first().children('a').addClass('is-active').next().addClass('is-open').show();
	$('.accordion-tabs').on('click', 'li > a', function(event) {
		if (!$(this).hasClass('is-active')) {
			event.preventDefault();
			$('.accordion-tabs .is-open').removeClass('is-open').hide();
			$(this).next().toggleClass('is-open').toggle();
			$('.accordion-tabs').find('.is-active').removeClass('is-active');
			$(this).addClass('is-active');
		} else {
			event.preventDefault();
			// $(this).removeClass('is-active');
			// $('.accordion-tabs .is-open').addClass('is-open').hide();
		}
	});


	$("body").on("click", ".considered__title a", function(e){
		e.preventDefault();
		$(this).toggleClass('active');
		$(this).parents('.considered__left').siblings('.considered__info').slideToggle();
	})


	//CALENDAR
	if ($("#datepicker").length>0) {
		$("#datepicker").datepicker();
	};

	//CALENDAR-toggle
	$("body").on("click", ".considered__calendar-toggle", function(e){
		e.preventDefault();
		$(this).toggleClass('active');
		$('.considered__wrapper').toggleClass('toggle');

		if($(this).find('span').text()=== "Show Calendar"){
            $(this).find('span').text("Hide Calendar");
        }
        else{
            $(this).find('span').text("Show Calendar");
        }
	})

	//SCROLL-LINK
	$("body").on("click",".link-scroll", function (event) {
        event.preventDefault();
        var id  = $(this).attr('href'),
        top = $(id).offset().top;
        if ($(window).width() > 851){
	  		$('body,html').animate({scrollTop: top - 100}, 1000);
	  	}
	  	else $('body,html').animate({scrollTop: top - 60}, 1000);
    });
});





//HEADER-FIXED
var secondaryNav = $('.page-header'),
secondaryNavTopPosition = secondaryNav.offset().top;

$(window).on('scroll', function(){
	if($(window).scrollTop() > secondaryNavTopPosition ) {
		secondaryNav.addClass('fixed');
		$('.layout').addClass('fixed-top');
	}
	else if($(window).scrollTop() < secondaryNavTopPosition + 300) {
		secondaryNav.removeClass('fixed');
		$('.layout').removeClass('fixed-top');
	}
});

function initMap() {
		var placeLat = parseInt(gon.latitude)
		var placeLng = parseInt(gon.longitude)
    var googleMapOptions = {
        center: new google.maps.LatLng(placeLat, placeLng),
        zoom: 15,
        mapTypeControl: false,
        navigationControl: false,
        scrollwheel: false,
        streetViewControl: false,
        zoomControl: true,
        zoomControlOptions: {
            position: google.maps.ControlPosition.RIGHT_CENTER
        },
    };
    var map = new google.maps.Map(document.getElementById("map"), googleMapOptions);
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(placeLat, placeLng),
    });

    marker.setMap(map);

    if ($(window).width() < 700){
	    var infoBubble = new InfoBubble({
	        content: '<div class="map-label"><div class="map-label__txt">' + gon.placename + '</div></div>',
	        shadowStyle: 0,
	        padding: 0,
	        borderRadius: 0,
	        maxWidth: 500,
	        minHeight: 70,
	        arrowSize: 10,
	        borderWidth: 0,
	        borderColor: '#000000',
	        disableAutoPan: false,
	        hideCloseButton: true,
	        arrowPosition: 50,
	        backgroundClassName: 'label-wrap',
	        backgroundColor: '#2fa6cf',
	        arrowStyle: 0,
	    });
    }
	else{
		 var infoBubble = new InfoBubble({
	        content: '<div class="map-label"><div class="map-label__txt">' + gon.placename + '</div></div>',
	        shadowStyle: 0,
	        padding: 0,
	        borderRadius: 0,
	        minWidth: 500,
	        minHeight: 70,
	        arrowSize: 10,
	        borderWidth: 0,
	        borderColor: '#000000',
	        disableAutoPan: false,
	        hideCloseButton: true,
	        arrowPosition: 50,
	        backgroundClassName: 'label-wrap',
	        backgroundColor: '#2fa6cf',
	        arrowStyle: 0,
	    });
	}
	google.maps.event.addListener(infoBubble, 'domready', function() {
	    marker.setMap(null);
	});
	google.maps.event.addDomListener(window, "resize", function() {
		var center = map.getCenter();
		google.maps.event.trigger(map, "resize");
		map.setCenter(center);
    });

    infoBubble.open(map, marker);
}

function initMap() {
    var map = new google.maps.Map(document.getElementById('map'), {
      center: {lat: gon.latitude, lng: gon.longitude},
      zoom: 13,
      scrollwheel: false,
      navigationControl: false,
      mapTypeControl: false,
      scaleControl: false,
      draggable: false,
      zoomControl: false,
      streetViewControl: false,

    });

map.set('styles', [
  {
    featureType: 'water',
    elementType: 'geometry.fill',
    stylers: [
      { color: '#ABC1D6' }
    ]
  }, {
    featureType: 'road.highway',
    elementType: 'geometry.fill',
    stylers: [
      { color: '#FFF700' }
    ]
  }, {
    featureType: 'all',
    elementType: 'labels.icon',
    stylers: [
      { visibility: 'off' }
    ]
  }, {
    featureType: 'poi',
    elementType: 'geometry.fill',
    stylers: [
      { hue: '#C1D6AB' }
    ]
  }, {
    featureType: 'road',
    elementType: 'geometry.stroke',
    stylers: [
      { visibility: 'off' }
    ]
  }
]);

    var getCen = map.getCenter();
    google.maps.event.addDomListener(window, 'resize', function() {
      map.setCenter(getCen);
    });

    var marker = new google.maps.Marker({
      position: {lat: gon.latitude, lng: gon.longitude},
      map: map,
      icon: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
    });
}

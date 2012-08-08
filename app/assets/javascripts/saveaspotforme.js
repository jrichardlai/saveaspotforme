SaveASpotForMe = {
  GMAPS_STATIC_API_KEY: null,
  currentUser: null,

  initialize: function () {
    var that = this;

    // init login state and buttons
    if (this.currentUser) {
      this.markLoggedIn();
    } else {
      this.markLoggedOut();
    }

    $('.login.button').click(function (e) {
      e.preventDefault();
      window.open($(this).attr('href'), 'TaskRabbitLogin', 'height=700,width=670')
    });

    $('.logout.button').click(function (e) {
      $.cookie('_burgertome_session', null)
      that.markLoggedOut();
    });

    this.initalizeNewReservation();
  },

  initalizeNewReservation: function() {
    this.initializeAddress($('.fields'));
  },

  initializeAddress: function (el) {
    var center = new google.maps.LatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude);
    var radius = 20;
    var zoom   = 12;
    var size   = "700x200";
  
    var map_image_base_url = "//maps.googleapis.com/maps/api/staticmap?size="+size+"&maptype=roadmap&sensor=false";
    if (this.GMAPS_STATIC_API_KEY) {
      map_image_base_url += "&key="+this.GMAPS_STATIC_API_KEY
    }

    var field_name_map = _({ // this object maps our form fields to google maps place object fields
      'reservation_address': ['street_number', 'route'],
      'reservation_city'   : ['locality'],
      'reservation_state'  : ['administrative_area_level_1'],
      'reservation_zip'    : ['postal_code']
    });


    var bounds = new google.maps.LatLngBounds(
      google.maps.geometry.spherical.computeOffset(center, radius, 45+180,  this.EARTH_RADIUS), // calculate NE corner
      google.maps.geometry.spherical.computeOffset(center, radius, 45,      this.EARTH_RADIUS)  // calculate SW corner
    );
  
    var input = $('#search')[0];
    var map_image_initial_params = "&center=" + center.toUrlValue() + "&zoom=" + zoom;
    var map_image = $('<img src="' + map_image_base_url + map_image_initial_params + '" class="location_map">');
  
    // add map image, stash initial source URL for later
    el.append(map_image);
    map_image.data('startingSrc', map_image.attr('src'));

    var autocomplete = new google.maps.places.Autocomplete(input, { bounds: bounds, types: ['establishment'], componentRestrictions: {country: 'us'}});

    google.maps.event.addListener(autocomplete, 'place_changed', function () {
      var place  = autocomplete.getPlace();
      var center = place.geometry.location.toUrlValue();
      var map_image_location_params  = "&markers=size:mid%7Ccolor:red%7C";
          map_image_location_params += center;
          map_image_location_params += "&center=" + center;
          map_image_location_params += "&zoom=" + 15;

      // update map image
      map_image.attr('src', map_image_base_url + map_image_location_params);

      // update legacy address fields
      field_name_map.each(function (gmaps_name, form_name) {

        // extract value from gmaps place object (multiple fields are concatenated using inject())
        var value = _(gmaps_name).inject(function (s, name) {
          var target_component = _(place.address_components).filter(function (component) {
            return _.contains(component.types, name);
          });
          if (target_component.length > 0) {
            return $.trim([s, target_component[0].short_name].join(' '));
          }
        }, '');

        // insert into our form field
        var selector = ['#', form_name].join('');
        var input = el.find(selector);

        input.val(value);
      });

      // update lat/lng and full address fields
      var lat   = place.geometry.location.lat(),
          lng   = place.geometry.location.lng(),
          phone = place.international_phone_number,
          name  = place.name;
      el.find('#reservation_latitude').val(lat);
      el.find('#reservation_longitude').val(lng);
      el.find('#reservation_location_name').val(name);
      el.find('#reservation_phone').val(phone);
    });
    
    
    // add a listener for the blur event to handle clearing of fields if address was deleted, and other housekeeping
    $(input).bind('blur', function () { 
      // if address field is empty (user deleted input), blank out the fields we filled
      if ($(this).val().length == 0) {
        // clear hidden fields to allow them to be re-filled from place_changed handler
        field_name_map.each(function (gmaps_name, form_name) {
          var selector = ['#', form_name].join('');
          var input = el.find(selector);
          input.val('');
        });
        el.find('#address_lat').val('');
        el.find('#address_lng').val('');
        el.find('#address_full').val('');

        // also reset map image
        map_image.attr('src', map_image.data('startingSrc'));
      }
    });

  },

  // selectBusiness: function(business) {
  //   console.log(location);
  //   $('#reservation_yelp_id').val(business.id);
  //   SaveASpotForMe.displayMap(business.location);
  // },

  displayMap: function(location) {
    var size   = "700x200";
    var map_image_base_url = "//maps.googleapis.com/maps/api/staticmap?size="+size+"&maptype=roadmap&sensor=false";
    var center = new GLatLng(location.coordinate.lattitude, location.coordinate.longitude);

    if (this.GMAPS_STATIC_API_KEY) {
      map_image_base_url += "&key="+this.GMAPS_STATIC_API_KEY
    }

    var map_image_initial_params = "&center=" + center.toUrlValue() + "&zoom=" + zoom;
    var map_image = $('<img src="' + map_image_base_url + map_image_initial_params + '" class="location_map">');

  },

  markLoggedIn: function () {
    $('.logged-in .user-name').text(this.currentUser);
    $('.logged-in').show();
    $('.logged-out').hide();
  },
  
  markLoggedOut: function (userName) {
    $('.logged-in .user-name').text('');
    $('.logged-in').hide();
    $('.logged-out').show();
  }

};

$(document).ready(function() {
  SaveASpotForMe.initialize();
});

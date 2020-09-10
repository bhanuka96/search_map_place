part of search_map_place;

class Geolocation {
  Geolocation(this._coordinates, this._bounds);

  List<String> cities = [
    'sublocality_level_5',
    'sublocality_level_4',
    'sublocality_level_3',
    'sublocality_level_2',
    'sublocality_level_1',
    'locality',
    'administrative_area_level_5',
    'administrative_area_level_4',
    'administrative_area_level_3',
    'administrative_area_level_2',
    'administrative_area_level_1'
  ];

  Geolocation.fromJSON(geolocationJSON) {
    this._coordinates = geolocationJSON["results"][0]["geometry"]["location"];
    this._bounds = geolocationJSON["results"][0]["geometry"]["viewport"];
    this.fullJSON = geolocationJSON["results"][0];
//    this.cityComponent = findCity(geolocationJSON);
    OUTER:
    for (String city in cities) {
      for (var result in geolocationJSON['results']) {
        for (var address in result['address_components']) {
          for (var type in address['types']) {
            if (city == type) {
              this.cityComponent = address;
              break OUTER;
            }
          }
        }
      }
    }
    OUTER:
    for (var result in geolocationJSON['results']) {
      for (var address in result['address_components']) {
        for (var type in address['types']) {
          if ('country' == type) {
            this.countryComponent = address;
            break OUTER;
          }
        }
      }
    }
  }

//  dynamic findCity(var geolocationJSON){
//    List<String> cities = [
//      'sublocality_level_5',
//      'sublocality_level_4',
//      'sublocality_level_3',
//      'sublocality_level_2',
//      'sublocality_level_1',
//      'locality',
//      'administrative_area_level_5',
//      'administrative_area_level_4',
//      'administrative_area_level_3',
//      'administrative_area_level_2',
//      'administrative_area_level_1'
//    ];
//    for(String city in cities){
//      for(var result in geolocationJSON['results']){
//        for(var address in result['address_components']){
//          for(var type in address['types']){
//            if(city == type){
//              return address;
//            }
//          }
//        }
//      }
//    }
//  }

  /// Property that holds the JSON response that contains the location of the place.
  var _coordinates;

  /// Property that holds the JSON response that contains the viewport of the place.
  var _bounds;

  /// Has the full JSON response received from the Geolocation API. Can be used to extract extra information of the location. More info on the [Geolocation API documentation](https://developers.google.com/maps/documentation/geolocation/intro)
  ///
  /// All of its information can be accessed like a regular [Map]. For example:
  /// ```
  /// fullJSON["adress_components"][2]["short_name"]
  /// ```
  var fullJSON;

  var cityComponent;

  var countryComponent;

  /// If you have the `google_maps_flutter` package, this method will return the coordinates of the place as
  /// a `LatLng` object. Otherwise, it'll be returned as Map.
  get coordinates {
    try {
      return LatLng(_coordinates["lat"], _coordinates["lng"]);
    } catch (e) {
      print("You appear to not have the `google_maps_flutter` package installed. In this case, this method will return an object with the latitude and longitude");
      return _coordinates;
    }
  }

  /// If you have the `google_maps_flutter` package, this method will return the coordinates of the place as
  /// a `LatLngBounds` object. Otherwise, it'll be returned as Map.
  get bounds {
    try {
      return LatLngBounds(
        southwest: LatLng(_bounds["southwest"]["lat"], _bounds["southwest"]["lng"]),
        northeast: LatLng(_bounds["northeast"]["lat"], _bounds["northeast"]["lng"]),
      );
    } catch (e) {
      print("You appear to not have the `google_maps_flutter` package installed. In this case, this method will return an object with southwest and northeast bounds");
      return _bounds;
    }
  }
}

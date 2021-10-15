import 'dart:convert';

import 'package:forest_tracker/data_layer/models/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GeoLocator{

  Future<Location> getCurrentLocation() async{
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     return Location().copyWith(longitude: position.longitude,latitude: position.latitude);
  }

}

class SearchPlaces{
  static final String _apiKey = 'api';
  
  static Future<List<Place>> getSearchedPlaces(String searchPlace) async{
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchPlace&types=geocode&key=$_apiKey');
    var response = await http.get(url);
    if(response.statusCode==200){
      var jsonData = json.decode(response.body);
      var data = jsonData['predictions'] as List;
      return data.map((place) => Place.fromJson(place)).where((place) {
        final country = place.description.toLowerCase();
        return country.contains('sri lanka');
      }).toList();
    }
  }
  
  Future<SearchedPlace> searchPlace(String placeId) async{
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey');
    var response = await http.get(url);
    if(response.statusCode==200){
      var jsonData = json.decode(response.body);
      var data = jsonData['result'] as Map<String,dynamic>;
      return SearchedPlace.fromJson(data);
    }
  }
}

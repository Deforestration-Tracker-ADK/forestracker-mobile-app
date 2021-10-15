import 'dart:convert';

class Location{
  final double longitude;
  final double latitude;

  Location({this.longitude, this.latitude});

  Location copyWith({double longitude,double latitude}){
    return Location(
      latitude: latitude??this.latitude,
      longitude: longitude?? this.longitude
    );
  }

  factory Location.fromJson(Map <String,dynamic> jsonData){
    return Location(
        longitude: jsonData['lng'] as double,
        latitude: jsonData['lat'] as double,
    );
  }

  Map<String,dynamic> toJson() => {
    'longitude' : this.longitude,
    'latitude' : this.latitude,
  };

  @override
  String toString() {
    return ('lat :  ${this.latitude} , lan : ${this.longitude} '  );
  }

}

class Place{
  final String placeId;
  String description;

  Place({this.placeId,this.description});

  factory Place.fromJson(Map<String,dynamic> json){
    return Place(
      placeId: json['place_id'] as String,
      description: json['description'] as String
    );
  }

  Map<String,dynamic> toJson()=>{
    'place_id' : this.placeId
  };

  // @override
  // String toString() {
  //   return ('Description :  ${this.description}');
  // }
}

class Geometry{
  final Location location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String,dynamic> json){
    return Geometry(
      location: Location.fromJson(json['location'])
    );
  }
}

class SearchedPlace{
  final Geometry geometry;
  SearchedPlace({this.geometry});

  factory SearchedPlace.fromJson(Map<String,dynamic> json){
    return SearchedPlace(
      geometry: Geometry.fromJson(json['geometry'])
    );
  }
}
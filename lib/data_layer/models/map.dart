import 'package:equatable/equatable.dart';

class Location extends Equatable{
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
    'lng' : this.longitude,
    'lat' : this.latitude,
  };

  @override
  String toString() {
    return ('lat :  ${this.latitude} , lan : ${this.longitude} '  );
  }

  @override
  List<double> get props => [longitude,latitude];

}
class LocationName extends Equatable{
  final String locationName;

  LocationName({this.locationName});
  factory LocationName.fromJson(Map<String,dynamic> json){
    return LocationName(
        locationName: json['formatted_address'] as String,
    );
  }

  @override
  List<String> get props => [locationName];

}


class Place extends Equatable{
  final String placeId;
  final String description;

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

  @override
  List<String> get props => [placeId,description];

}

class Geometry extends Equatable{
  final Location location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String,dynamic> json){
    return Geometry(
      location: Location.fromJson(json['location'])
    );
  }

  @override
  List<Location> get props => [location];
}

class SearchedPlace extends Equatable{
  final Geometry geometry;
  SearchedPlace({this.geometry});

  factory SearchedPlace.fromJson(Map<String,dynamic> json){
    return SearchedPlace(
      geometry: Geometry.fromJson(json['geometry'])
    );
  }

  @override
  List<Geometry> get props => [geometry];
}
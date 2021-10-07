import 'dart:convert';

class Location{
  double longitude;
  double latitude;

  Location({this.longitude, this.latitude});

  Location copyWith({double longitude,double latitude}){
    return Location(
      latitude: latitude??this.latitude,
      longitude: longitude?? this.longitude
    );
  }

  factory Location.fromJson(Map <String,dynamic> jsonData){
    return Location(
        longitude: jsonData['longitude'] as double,
        latitude: jsonData['latitude'] as double,
    );
  }

  Map<String,dynamic> toJson() => {
    'longitude' : this.longitude,
    'latitude' : this.latitude,
  };

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

  @override
  String toString() {
    return ('Description :  ${this.description}');
  }
}

//test
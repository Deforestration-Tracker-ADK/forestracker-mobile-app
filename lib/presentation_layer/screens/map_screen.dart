import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:forest_tracker/data_layer/models/map.dart';
import 'package:forest_tracker/data_layer/services/location_service.dart';
import 'package:forest_tracker/logic_layer/blocs/map_bloc.dart';
import 'package:forest_tracker/logic_layer/events/map_event.dart';
import 'package:forest_tracker/logic_layer/states/map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  bool isSearch = false;
  double _lat;
  double _lon;
  Completer<GoogleMapController> _googleMapController = Completer();
  @override
  void initState() {
    context.read<MapBloc>().add(GetCurrentLocation());
    super.initState();
  }

  void _tapSearch() {
    if (!isSearch) {
      setState(() {
        isSearch = true;
      });
    }
  }

  Future<void> _updateLocation(Location location) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(location.latitude,location.longitude),
            zoom: 17.0),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: !isSearch
            ? Text('Map Page')
            : TypeAheadField<Place>(
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Colors.white10.withOpacity(0.7),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 18),
                  decoration: InputDecoration(hintText: 'Search Location...'),
                ),
                suggestionsCallback: SearchPlaces.getSearchedPlaces,
                itemBuilder: (context, place) {
                  return ListTile(
                    title: Text(place.description),
                  );
                },
                hideSuggestionsOnKeyboardHide: false,
                onSuggestionSelected: (suggestion) {
                  context.read<MapBloc>().add(SelectPlace(placeId: suggestion.placeId));
                },
        ),
        actions: [
          !isSearch
              ? IconButton(onPressed: _tapSearch, icon: Icon(Icons.search))
              : SizedBox()
        ],
      ),
      body: BlocConsumer<MapBloc, MapStates>(
        listener: (context, state) {
          if (state is CurrentLocation) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Updating location...'), duration: Duration(seconds: 2)));
          }
          if(state is SelectedPlace){
            _updateLocation(state.location);
          }
        },
        buildWhen: (prevState, state) {
          if (state is MapLoading || state is CurrentLocation ||state is SelectedPlace) return true;
          return false;
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CurrentLocation ||state is SelectedPlace) {
            return Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: GoogleMap(
                    markers: {buildMarker(state)},
                    onMapCreated: (GoogleMapController controller) {
                      _googleMapController.complete(controller);
                    },
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    minMaxZoomPreference: MinMaxZoomPreference(2, 20),
                    initialCameraPosition: setInitialCameraPosition(state),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 15,
                  child: FloatingActionButton(
                      child: Center(child: Icon(Icons.keyboard_arrow_right_sharp),),
                      onPressed: (){
                        print(_lat);
                        print(_lon);
                      }),
                )
              ],
            );
          } else {
            throw ('Undefined state in Map');
          }
        },
      ),
    );
  }

  CameraPosition setInitialCameraPosition(MapStates state) {
    _lat=_lat??state.location.latitude;
    _lon=_lon??state.location.longitude;
    return CameraPosition(
        target: LatLng(state.location.latitude, state.location.longitude),
        zoom: 17
    );
  }

  Marker buildMarker(MapStates state) {
    return Marker(
      markerId: MarkerId(UniqueKey().toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(state.location.latitude, state.location.longitude),
      draggable: true,
      onDragEnd: (value) => {
        _lon = value.longitude,
        _lat = value.latitude
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

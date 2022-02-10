import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:forest_tracker/data_layer/models/map.dart';
import 'package:forest_tracker/data_layer/services/location_service.dart';
import 'package:forest_tracker/logic_layer/blocs/map_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/report_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/location_appbar_cubit.dart';
import 'package:forest_tracker/logic_layer/cubits/select_location_cubit.dart';
import 'package:forest_tracker/logic_layer/events/map_event.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/location_appbar_states.dart';
import 'package:forest_tracker/logic_layer/states/map_state.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double _lat;
  double _lon;
  Completer<GoogleMapController> _googleMapController = Completer();
  @override
  void initState() {
    context.read<MapBloc>().add(GetCurrentLocation());
    super.initState();
  }

  Future<void> _updateLocation(Location location) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(location.latitude, location.longitude), zoom: 17.0),
      ),
    );
  }

  void _tapSearch(bool isTap) {
    context.read<LocationAppBarCubit>().isSearched(isTap);
  }

  void _setLatLngValue(double lat, double lon) {
    _lat = lat;
    _lon = lon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: BlocBuilder<LocationAppBarCubit, LocationAppBarStates>(
            builder: (context, state) {
          if (!state.isSearched) {
            return AppBar(
              title: Text('Map Page'),
              actions: [
                IconButton(
                    onPressed: () => _tapSearch(true), icon: Icon(Icons.search))
              ],
            );
          } else {
            return AppBar(
              title: TypeAheadField<Place>(
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Colors.white10.withOpacity(0.7),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 18),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: 'Search Location...'),
                ),
                suggestionsCallback: SearchPlaces.getSearchedPlaces,
                itemBuilder: (context, place) {
                  return ListTile(
                    title: Text(place.description),
                  );
                },
                hideSuggestionsOnKeyboardHide: false,
                onSuggestionSelected: (suggestion) {
                  context
                      .read<MapBloc>()
                      .add(SelectPlace(placeId: suggestion.placeId));
                },
              ),
            );
          }
        }),
      ),
      body: BlocConsumer<MapBloc, MapStates>(
        listener: (context, state) {
          if (state is CurrentLocation) {
            _updateLocation(state.location);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Updating location...'),
                duration: Duration(seconds: 1)));
          }
          if (state is SelectedPlace) {
            _updateLocation(state.location);
          }
        },
        buildWhen: (prevState, state) {
          if (state is MapLoading ||
              state is CurrentLocation ||
              state is SelectedPlace) return true;
          return false;
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CurrentLocation || state is SelectedPlace) {
            return Stack(children: [
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
                  minMaxZoomPreference: MinMaxZoomPreference(2, 20),
                  initialCameraPosition: setInitialCameraPosition(state),
                ),
              ),
              Positioned(
                  bottom: 100,
                  right: 15,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    elevation: 5,
                    child: IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.black,
                      ),
                      onPressed: ()=>context.read<MapBloc>().add(GetCurrentLocation()),
                    ),
                  ))
            ]);
          } else {
            throw ('Undefined state in Map');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Center(
            child: Icon(Icons.keyboard_arrow_right_sharp),
          ),
          onPressed: () => navigateToReportPage(context)
          ),
    );
  }

  void navigateToReportPage(BuildContext context) {
    //disable navigating to report page until the pointer gets a location
    if(_lat!=null && _lon!=null){
      _tapSearch(false);
      context.read<SelectLocationCubit>().getLocationName(_lat, _lon);
      context.read<ReportBloc>().add(ClearDataEvent());
      Navigator.pushNamed(context, ReportCreationPage.id,arguments: {'isCreated': true, 'report': null});
    }
  }

  CameraPosition setInitialCameraPosition(MapStates state) {
    _setLatLngValue(state.location.latitude, state.location.longitude);
    return CameraPosition(
        target: LatLng(state.location.latitude, state.location.longitude),
        zoom: 17);
  }

  Marker buildMarker(MapStates state) {
    return Marker(
      markerId: MarkerId(UniqueKey().toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(state.location.latitude, state.location.longitude),
      draggable: true,
      onDragEnd: (value) => _setLatLngValue(value.latitude, value.longitude),
    );
  }

}

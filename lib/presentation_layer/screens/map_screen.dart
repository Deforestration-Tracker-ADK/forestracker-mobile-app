import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:forest_tracker/data_layer/models/map.dart';
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

  Future<List<Place>> _onChanged(String place, BuildContext context, MapBloc bloc) async {
    if(place.isNotEmpty){
      bloc.add(SearchPlace(place: place));
      if (bloc.state is SearchedPlaces) {
        return  bloc.state.props.toList();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = BlocProvider.of<MapBloc>(context, listen: false);
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
                        style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontSize: 18),
                        decoration: InputDecoration(
                            hintText: 'Search Location...'),
                      ),
                      suggestionsCallback: (place) =>_onChanged(place, context,bloc),
                      itemBuilder: (context, place) {
                        return ListTile(
                          title: Text(place.description),
                        );
                      },
                      hideSuggestionsOnKeyboardHide: false,
                      onSuggestionSelected: null),
          actions: [
            !isSearch
                ? IconButton(onPressed: _tapSearch, icon: Icon(Icons.search))
                : SizedBox()
          ],
        ),
        body: BlocConsumer<MapBloc, MapStates>(listener: (context, state) {
          if (state is CurrentLocation) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Updating location...'),
              duration: Duration(seconds: 2),
            ));
          }
        }, buildWhen: (prevState, state) {
          if (state is MapLoading || state is CurrentLocation) {
            return true;
          } else {
            return false;
          }
        }, builder: (context, state) {
          if (state is MapLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CurrentLocation) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(2, 20),
                  cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                      southwest: LatLng(5.55, 79.41),
                      northeast: LatLng(9.51, 81.53))),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(state.latitude, state.longitude))),
            );
          } else {
            throw ('Undefined state in Map');
          }
        }));
  }

  @override
  bool get wantKeepAlive => true;

}

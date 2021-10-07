import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/services/project_services.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/map_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/news_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/projects_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/connection_cubit.dart';
import 'package:forest_tracker/logic_layer/cubits/navigation_cubit.dart';
import 'package:forest_tracker/presentation_layer/screens/applied_projects_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/fav_projects_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/login_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/main_screen.dart';
import 'package:forest_tracker/presentation_layer/pages/project_page.dart';
import 'package:forest_tracker/presentation_layer/screens/project_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/welcome_screen.dart';
import 'data_layer/services/location_service.dart';
import 'data_layer/services/news_services.dart';
import 'logic_layer/singleBlocObsever.dart';

void main() => runApp(ForestTracker(connectivity: Connectivity()));

class ForestTracker extends StatelessWidget {
  final Connectivity connectivity;
  final ProjectAPI projectAPI = ProjectAPI.getInstance();
  final NewsAPI newsAPI = NewsAPI();
  final geoLocator = GeoLocator();

  ForestTracker({@required this.connectivity});

  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocObserver();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectionCubit>(create: (context) => ConnectionCubit(connection: connectivity)),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
        BlocProvider<NewsBloc>(create: (context) => NewsBloc(newsAPI: newsAPI)),
        BlocProvider<ProjectBloc>(create: (create)=>ProjectBloc(projectAPI: projectAPI)),
        BlocProvider<ProjectsBloc>(create: (context) => ProjectsBloc(projectAPI:projectAPI,projectBloc: context.read<ProjectBloc>())),
        BlocProvider<MapBloc>(create: (context)=>MapBloc(geoLocator:geoLocator ))
      ],
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          MainPage.id: (context) => MainPage(),
          ProjectScreen.id: (context) => ProjectScreen(),
          ProjectPage.id : (context) => ProjectPage(),
          FavProjectScreen.id : (context) => FavProjectScreen(),
          AppliedProjectScreen.id : (context) => AppliedProjectScreen(),
        },
      ),
    );
  }
}

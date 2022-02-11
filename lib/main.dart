import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/services/project_services.dart';
import 'package:forest_tracker/logic_layer/blocs/report_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/map_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/news_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/projects_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/reports_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/connection_cubit.dart';
import 'package:forest_tracker/logic_layer/cubits/location_appbar_cubit.dart';
import 'package:forest_tracker/logic_layer/cubits/navigation_cubit.dart';
import 'package:forest_tracker/presentation_layer/pages/article_page.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation/report_creation_page.dart';
import 'package:forest_tracker/presentation_layer/pages/send_reports_page.dart';
import 'package:forest_tracker/presentation_layer/pages/applied_projects_page.dart';
import 'package:forest_tracker/presentation_layer/pages/fav_projects_page.dart';
import 'package:forest_tracker/presentation_layer/pages/view_send_report_page.dart';
import 'package:forest_tracker/presentation_layer/screens/login_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/main_screen.dart';
import 'package:forest_tracker/presentation_layer/pages/project_page.dart';
import 'package:forest_tracker/presentation_layer/screens/report_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/welcome_screen.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'data_layer/services/auth_service.dart';
import 'data_layer/services/location_service.dart';
import 'data_layer/services/news_services.dart';
import 'logic_layer/cubits/select_location_cubit.dart';
import 'logic_layer/singleBlocObsever.dart';


void main() => runApp(ForestTracker(connectivity: Connectivity()));

class ForestTracker extends StatefulWidget {
  final Connectivity connectivity;

  ForestTracker({@required this.connectivity});

  @override
  State<ForestTracker> createState() => _ForestTrackerState();
}

class _ForestTrackerState extends State<ForestTracker> {
  final ProjectAPI projectAPI = ProjectAPI.getInstance();
  final NewsAPI newsAPI = NewsAPI();
  final GeoLocator geoLocator = GeoLocator();
  final SearchPlaces searchPlace = SearchPlaces();



  @override
  void initState() {
    //create a singleton of shared preferences
    Authentication.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocObserver();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectionCubit>(create: (context) => ConnectionCubit(connection: widget.connectivity)),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
        BlocProvider<LocationAppBarCubit>(create: (context) => LocationAppBarCubit()),
        BlocProvider<NewsBloc>(create: (context) => NewsBloc(newsAPI: newsAPI)),
        BlocProvider<ProjectBloc>(create: (create)=>ProjectBloc(projectAPI: projectAPI)),
        BlocProvider<ProjectsBloc>(create: (context) => ProjectsBloc(projectAPI:projectAPI,projectBloc: context.read<ProjectBloc>())),
        BlocProvider<MapBloc>(create: (context)=>MapBloc(geoLocator:geoLocator ,searchPlaces: searchPlace)),
        BlocProvider<SelectLocationCubit>(create: (context) => SelectLocationCubit(searchPlaces: searchPlace)),
        BlocProvider<ReportsBloc>(create: (context)=> ReportsBloc(),),
        BlocProvider<ReportBloc>(create: (context)=>ReportBloc(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Colors.blue)),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          MainPage.id: (context) => MainPage(),
          ViewArticle.id : (context) => ViewArticle(),
          ProjectPage.id : (context) => ProjectPage(),
          ReportPage.id :(context)=> ReportPage(),
          FavProjectScreen.id : (context) => FavProjectScreen(),
          AppliedProjectScreen.id : (context) => AppliedProjectScreen(),
          ReportCreationPage.id : (context) => ReportCreationPage(),
          SendReportPage.id:(context)=> SendReportPage(),
          ReportReviewPage.id:(context)=>ReportReviewPage()
        },
      ),
    );
  }
}

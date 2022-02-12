import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/connection_cubit.dart';
import 'package:forest_tracker/logic_layer/cubits/navigation_cubit.dart';
import 'package:forest_tracker/logic_layer/states/connection_state.dart';
import 'package:forest_tracker/logic_layer/states/navigation_state.dart';
import 'package:forest_tracker/presentation_layer/screens/report_screen.dart';
import 'package:forest_tracker/presentation_layer/screens/user_screen.dart';

import 'project_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class MainPage extends StatelessWidget {
  static const String id = 'home_screen';

  static final PageController _controller = PageController();
  final List<Widget> _body = [
    HomePage(),
    ProjectScreen(),
    MapPage(),
    ReportPage(),
    UserPage(
      name: 'UserName',
    )
  ];

  static changePage(int value, BuildContext context) {
    final cubit = context.read<NavigationCubit>();
    cubit.navigate(value);
    _controller.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = true;
    return SafeArea(
      child: Scaffold(
          body: BlocListener<ConnectionCubit, ConnectionStates>(
            listener: (context, state) => {
            print(state),
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state is Connected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connected !'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  if (!isConnected) {
                    Navigator.pop(context);
                    isConnected = true;
                  }
                } else if (state is Disconnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No Connection!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        isConnected = false;
                        //to avoid dismissing pop up using back button
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                            content: Expanded(child: Image.asset('assets/images/no_connection.png')),
                            elevation: 30,
                          ),
                        );
                      });
                }
              })
            },
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) => changePage(value, context),
              controller: _controller,
              children: _body,
            ),
          ),
          bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationStates>(
              builder: (context, state) {
            return BottomNavigationBar(
              elevation: 2.0,
              backgroundColor: Colors.white10,
              selectedItemColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              onTap: (value) => changePage(value, context),
              currentIndex: state.index,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
                BottomNavigationBarItem(
                  // TODO: change the icon
                    icon: Icon(Icons.eleven_mp), label: "search"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.location_on_rounded), label: "location"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.folder_rounded), label: "folder"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_pin_rounded), label: "profile"),
              ],
            );
          })),
    );
  }
}

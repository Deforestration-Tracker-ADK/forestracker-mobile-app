
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_tracker/data_layer/services/news_services.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/news_bloc.dart';
import 'package:forest_tracker/presentation_layer/screens/home_screen.dart';

void main() {
  group('Home Screen', () {
    testWidgets('Screen Scafold.',
            (WidgetTester tester) async {

          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => NewsBloc(newsAPI: NewsAPI()),
                ),
                BlocProvider(
                  create: (context) => LoginBloc(),
                )
              ],
              child: HomePage(),
            ),
          ));
          expect(find.text('Forest Tracker'), findsOneWidget);
        });

    testWidgets('log out pop up.',
            (WidgetTester tester) async {

          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => NewsBloc(newsAPI: NewsAPI()),
                ),
                BlocProvider(
                  create: (context) => LoginBloc(),
                )
              ],
              child: HomePage()
            ),
          ));
          await tester.tap(find.byIcon(Icons.logout));
        });

  });
}


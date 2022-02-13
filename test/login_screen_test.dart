import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/connection_cubit.dart';
import 'package:forest_tracker/logic_layer/states/connection_state.dart';
import 'package:forest_tracker/presentation_layer/screens/login_screen.dart';
import 'package:mockito/mockito.dart';

class MockConnectionCubit extends MockCubit<ConnectionStates> implements ConnectionCubit{}

class MockConnectionState extends Mock implements Connected{}


void main() {
  testWidgets('Signin page renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlocProvider(
              create: (context) => LoginBloc(), child: LoginScreen()),
        )));


    expect(find.byKey(Key("password"),),findsOneWidget);
    expect(find.byKey(Key("name"),),findsOneWidget);
    expect(find.byKey(Key("forget_pw")), findsOneWidget);
  });
  testWidgets('Can enter email and password for signing in.',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                  create: (context) => LoginBloc(), child: LoginScreen()),
            )));

        final username = find.byKey(Key('name'));
        final password = find.byKey(Key('password'));

        await tester.enterText(username, 'user');
        await tester.enterText(password, '123456');

        expect(find.text('user'), findsOneWidget);
        expect(find.text('123456'), findsOneWidget);
      });
}
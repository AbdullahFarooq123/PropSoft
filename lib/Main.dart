import 'dart:convert';
import 'dart:ui';

import 'package:flashchat/Classes/API.dart';
import 'package:flashchat/Screens/LeadsFilter.dart';
import 'package:flashchat/Screens/Welcome.dart';
import 'package:flashchat/Widgets/ProgressHud.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/Screens/Login.dart';
import 'package:flashchat/Screens/Communications.dart';
import 'package:flashchat/Screens/HomeScreen.dart';
import 'package:flashchat/Screens/Settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flashchat/Screens/MyLeads.dart';

void main() {
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(context),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ur', ''),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        'welcome screen': (context) => const WelcomeScreen(),
        'login screen': (context) => const LoginScreen(),
        'buttoned screen': (context) => HomeScreen(
              tokenId: ExtractArguments('buttoned screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
        'settings screen': (context) => SettingsScreen(
              leadsFilter: ExtractArguments('settings screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
        'leads filter screen': (context) => LeadsFilterScreen(
              screenName: ExtractArguments('leads filter screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
        'communication screen': (context) => CommunicationScreen(
              leadId: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Lead Id'],
              tokenId: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Token Id'],
              assignedBy: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Assigned By'],
              teamId: ExtractArguments('communication screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments()['Team Id'].toString(),
            ),
        'MyLeads screen': (context) => MyLeadsScreen(
              tokenId: ExtractArguments('buttoned screen',
                      ModalRoute.of(context)?.settings.arguments)
                  .getArguments(),
            ),
      },
    );
  }
}

class ExtractArguments {
  final String screenName;
  final Object? arguments;

  ExtractArguments(this.screenName, this.arguments);

  dynamic getArguments() {
    switch (screenName) {
      case 'buttoned screen':
        return arguments;
      case 'settings screen':
        return arguments as Map<String, Map<String, bool>>;
      case 'leads screen':
        return arguments as Map<String, Object>;
      case 'leads filter screen':
        return arguments as String;
      case 'communication screen':
        return arguments as Map<String, dynamic>;
    }
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    tryLogin();
    return CustomModalProgress(
      icon: const Icon(
        Icons.access_time_filled_outlined,
        color: Colors.white,
      ),
      inAsyncCall: loading,
      child: Scaffold(
        body: Container(
          color: backgroundColor,
        ),
      ),
    );
  }

  void tryLogin() async {
    NavigatorState navigator = Navigator.of(context);
    try {
      final file = await localFile(credentialsFileName);
      Map<String, dynamic> data = await jsonDecode(file.readAsStringSync());
      final response = await API.getLoginResponse(
          username: data['username'], password: data['password']);
      response.statusCode == 200
          ? navigator.pushReplacementNamed(
              'MyLeads screen',
              arguments: json.decode(response.body)['token'],
            )
          : navigator.pushReplacementNamed('welcome screen');
    } catch (socketException) {
      navigator.pushReplacementNamed('welcome screen');
    }
  }
}

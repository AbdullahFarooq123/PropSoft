import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

const errorMsgDuration = 5;
const successMsgDuration = 2;

const kLightColor = Color.fromRGBO(84, 77, 129, 1);
const kDarkColor = Color.fromRGBO(84, 77, 129, 1);
const kLighterColor = Color.fromRGBO(138, 147, 180, 1);
const Color backgroundColor = Color(0xfff5eddc);
const Color foregroundColor1 = Color(0xffCFD2CF);
const Color foregroundColor2 = Color(0xffA2B5BB);
const Color appBarColor = Color(0xff1B2430);

const String credentialsFileName = 'credentials.json';
const String totalLeadsFiltersFileName = 'totalLeadsFilter.json';
const String newLeadsFiltersFileName = 'newLeadsFilter.json';
const String unAttendedLeadsFiltersFileName = 'unAttendedLeadsFilter.json';
const String visitRequestsFiltersFileName = 'visitRequestsFilter.json';
const String pendingLeadsFiltersFileName = 'pendingLeadsFilter.json';
const String soldFiltersFileName = 'soldFilter.json';

ThemeData Function(BuildContext context) get theme => (BuildContext context) {
      return Theme.of(context).copyWith(
        appBarTheme: const AppBarTheme(color: appBarColor),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
          overline: TextStyle(color: Colors.white),
        ),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.white),
      );
    };

Future<File> localFile(String fileName) async {
  final path = await _localPath();
  return File('$path/$fileName');
}
Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

String getFilterFileName(String screenName) {
  switch (screenName) {
    case 'Total Leads':
      return totalLeadsFiltersFileName;
    case 'New Leads':
      return newLeadsFiltersFileName;
    case 'Un-Attended Leads':
      return unAttendedLeadsFiltersFileName;
    case 'Visit Requests':
      return visitRequestsFiltersFileName;
    case 'Pending Leads':
      return pendingLeadsFiltersFileName;
    case 'Sales':
      return soldFiltersFileName;
    default:
      return '';
  }
}

String getDate(DateTime today) {
  return DateFormat('dd-MM-yyyy').format(today);
}

String getFormattedDate(String date) {
  String day = date.split('-')[0];
  String month = date.split('-')[1];
  String year = date.split('-')[2];
  return '$year-$month-$day';
}

class LeadsLengths{
  int noOfTotalLeads = 0;
  int noOfNewLeads = 0;
  int noOfUnAttendedLeads = 0;
  int noOfVisitRequests = 0;
  int noOfPendingLeads = 0;
  int noOfSales = 0;
}

import 'dart:convert';
import 'dart:developer';

import 'package:flashchat/Classes/API.dart';
import 'package:flashchat/Classes/AwesomeDialogue.dart';
import 'package:flashchat/Widgets/LeadTab.dart';
import 'package:flashchat/Widgets/PopupMenu.dart';
import 'package:flashchat/Widgets/ProgressHud.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyLeadsScreen extends StatefulWidget {
  final String tokenId;

  const MyLeadsScreen({Key? key, required this.tokenId}) : super(key: key);

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  Map<String, List<dynamic>> separateData = {};
  List<dynamic> data = [];
  Map<String, Map<String, bool>> settings = Map.identity();
  Map<String, int?> statuses = Map.identity();
  List<Widget> pages = [];
  bool loading = true;
  LeadsLengths leadsLengths = LeadsLengths();

  @override
  void initState() {
    super.initState();
    leadsLengths = LeadsLengths();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    print(statuses);
    return CustomModalProgress(
      icon: const Icon(
        Icons.access_time_filled_outlined,
        color: Colors.white,
      ),
      inAsyncCall: loading,
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            leading: PopupButton(
              textColor: Colors.white,
              onSelected: (value) async {
                bool selection =
                    await AwesomeDialogueBox.showDialogueWithCancel(
                        title: 'Logout?',
                        dialogType: DialogType.QUESTION,
                        okText: 'Yes',
                        cancelText: 'No',
                        context: context);
                if (selection) {
                  Navigator.pushReplacementNamed(context, 'login screen');
                }
              },
              menuItems: const ['Logout'],
              menuColor: appBarColor,
              child: const Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
                size: kToolbarHeight * 0.75,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    AwesomeDialogueBox.showDialogueWithoutCancel(
                        title: 'Under Development',
                        dialogType: DialogType.INFO,
                        context: context,
                        btnColor: Colors.green,
                        btnText: 'OK',
                        btnIcon: Icons.done_all,
                        duration: successMsgDuration,
                    );
                  }, //retrieveSettingsData,
                  icon: const Icon(Icons.settings))
            ],
            title: const Text('Welcome'),
          ),
          bottomNavigationBar: Container(
            color: appBarColor,
            child: TabBar(
              isScrollable: true,
              indicatorColor: foregroundColor1,
              tabs: [
                Tab(
                  icon: IconBadge(
                    badgeColor: const Color(0xff51557E),
                    icon: const Icon(Icons.all_inbox),
                    itemCount: leadsLengths.noOfTotalLeads,
                  ),
                  text: 'Total Leads',
                ),
                Tab(
                  icon: IconBadge(
                    badgeColor: const Color(0xff51557E),
                    icon: const Icon(Icons.new_releases_rounded),
                    itemCount: leadsLengths.noOfNewLeads,
                  ),
                  text: 'New Leads',
                ),
                Tab(
                  icon: IconBadge(
                    badgeColor: const Color(0xff51557E),
                    icon: const Icon(Icons.mark_chat_unread_rounded),
                    itemCount: leadsLengths.noOfUnAttendedLeads,
                  ),
                  text: 'Un-Attended Leads',
                ),
                Tab(
                  icon: IconBadge(
                    badgeColor: const Color(0xff51557E),
                    icon: const Icon(Icons.call),
                    itemCount: leadsLengths.noOfVisitRequests,
                  ),
                  text: 'Visit Requests',
                ),
                Tab(
                  icon: IconBadge(
                    badgeColor: const Color(0xff51557E),
                    icon: const Icon(Icons.pending_actions_sharp),
                    itemCount: leadsLengths.noOfPendingLeads,
                  ),
                  text: 'Pending Leads',
                ),
                Tab(
                  icon: IconBadge(
                    badgeColor: const Color(0xff51557E),
                    icon: const Icon(Icons.done_all),
                    itemCount: leadsLengths.noOfSales,
                  ),
                  text: 'Sold',
                ),
              ],
            ),
          ),
          body: LiquidPullToRefresh(
            color: appBarColor,
            backgroundColor: backgroundColor,
            onRefresh: () async {
              setState(() {
                fetchUserData();
              });
            },
            child: TabBarView(
              children: pages.length == 6
                  ? pages
                  : const [
                      Icon(Icons.circle_outlined),
                      Icon(Icons.circle_outlined),
                      Icon(Icons.circle_outlined),
                      Icon(Icons.circle_outlined),
                      Icon(Icons.circle_outlined),
                      Icon(Icons.circle_outlined),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, bool> getFilterSettings(
      {required bool filter,
      int? filterValue = 0,
      bool isPendingLeads = false}) {
    Map<String, bool> tempStatus = {};
    statuses.forEach((key, value) {
      !filter
          ? tempStatus[key] = (!isPendingLeads
              ? true
              : ((value == 4 || value == null) ? true : false))
          : (value == filterValue ? tempStatus[key] = true : null);
    });
    return tempStatus;
  }

  void fetchUserData() async {
    final tokenId = widget.tokenId;
    Response leadsResponse = await API.getMyLeads(tokenId);
    Response statusResponse = await API.getStatuses(tokenId);
    print(statusResponse.body);
    if (leadsResponse.statusCode == 200 && statusResponse.statusCode == 200) {
      List<dynamic> status = json.decode(statusResponse.body)['data'];
      data = json.decode(leadsResponse.body)['data'];
      for (var element in status) {
        statuses[element['description'] ?? 'No Communication'] =
            element['description'] == null ? null : element['statusID'];
      }
      settings = {
        'Total Leads': getFilterSettings(filter: false),
        'Un-Attended Leads': getFilterSettings(filter: true, filterValue: null),
        'Visit Requests': getFilterSettings(filter: true, filterValue: 3),
        'Pending Leads': getFilterSettings(filter: false, isPendingLeads: true),
        'Sold': getFilterSettings(filter: true, filterValue: 4),
      };
      filterUserData();
      pages = [
        GetLeads(
          screenData: separateData['Total Leads']!,
          leadsName: 'Total Leads',
          tokenId: widget.tokenId,
          leadsLengths: leadsLengths,
          onChanged: () {
            setState(() {});
          },
        ),
        GetLeads(
          screenData: separateData['New Leads']!,
          leadsName: 'New Leads',
          tokenId: widget.tokenId,
          leadsLengths: leadsLengths,
          onChanged: () {
            setState(() {});
          },
        ),
        GetLeads(
          screenData: separateData['Un-Attended Leads']!,
          leadsName: 'Un-Attended Leads',
          tokenId: widget.tokenId,
          leadsLengths: leadsLengths,
          onChanged: () {
            setState(() {});
          },
        ),
        GetLeads(
          screenData: separateData['Visit Requests']!,
          leadsName: 'Visit Requests',
          tokenId: widget.tokenId,
          leadsLengths: leadsLengths,
          onChanged: () {
            setState(() {});
          },
        ),
        GetLeads(
          screenData: separateData['Pending Leads']!,
          leadsName: 'Pending Leads',
          tokenId: widget.tokenId,
          leadsLengths: leadsLengths,
          onChanged: () {
            setState(() {});
          },
        ),
        GetLeads(
          screenData: separateData['Sales']!,
          leadsName: 'Sales',
          tokenId: widget.tokenId,
          leadsLengths: leadsLengths,
          onChanged: () {
            setState(() {});
          },
        ),
      ];
      loading = false;
      if (mounted) {
        setState(() {
          leadsLengths.noOfTotalLeads = separateData['Total Leads']!.length;
          leadsLengths.noOfNewLeads = separateData['New Leads']!.length;
          leadsLengths.noOfUnAttendedLeads =
              separateData['Un-Attended Leads']!.length;
          leadsLengths.noOfVisitRequests =
              separateData['Visit Requests']!.length;
          leadsLengths.noOfPendingLeads = separateData['Pending Leads']!.length;
          leadsLengths.noOfSales = separateData['Sales']!.length;
        });
      }
    } else {
      Navigator.pushReplacementNamed(context, 'login screen');
    }
  }

  void filterUserData() {
    Map<String, List<int?>> arraySettings = Map.identity();
    settings.forEach((name, map) {
      arraySettings[name] = [];
      map.forEach((key, value) {
        if (value == true) {
          arraySettings[name]?.add(statuses[key]);
        }
      });
    });
    separateData['Total Leads'] = data
        .where((element) =>
            (arraySettings['Total Leads']!.contains(element['statusID'])))
        .toList();
    separateData['New Leads'] = data
        .where((element) => (element['leadDate']
            .contains(DateTime.now().toString().split(' ')[0])))
        .toList();
    separateData['Un-Attended Leads'] = data
        .where((element) =>
            (arraySettings['Un-Attended Leads']!
                .contains(element['statusID'])) &&
            element['statusID'] == null)
        .toList();
    separateData['Visit Requests'] = data
        .where((element) =>
            (arraySettings['Visit Requests']!.contains(element['statusID'])) &&
            element['statusID'] == 3)
        .toList();
    separateData['Pending Leads'] = data
        .where((element) =>
            (arraySettings['Pending Leads']!.contains(element['statusID'])))
        .toList();
    separateData['Sales'] = data
        .where((element) =>
            (arraySettings['Sold']!.contains(element['statusID'])) &&
            element['statusID'] == 4)
        .toList();
  }

  void retrieveSettingsData() async {
    Map<String, Map<String, bool>>? tempSettings = await Navigator.pushNamed(
            context, 'settings screen', arguments: settings)
        as Map<String, Map<String, bool>>?;
    print(tempSettings);
    if (tempSettings != null) {
      settings = tempSettings;
      filterUserData();
      setState(() {});
    }
  }
}

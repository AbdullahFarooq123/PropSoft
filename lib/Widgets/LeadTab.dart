import 'dart:convert';

import 'package:flashchat/Classes/AwesomeDialogue.dart';
import 'package:flashchat/Widgets/LeadsBubble.dart';
import 'package:flashchat/Constants.dart';
import 'package:flashchat/Widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GetLeads extends StatefulWidget {
  final List<dynamic> screenData;
  final String leadsName;
  final String tokenId;
  final VoidCallback onChanged;
  final LeadsLengths leadsLengths;

  const GetLeads(
      {Key? key,
      required this.screenData,
      required this.leadsName,
      required this.tokenId,
      required this.onChanged,
      required this.leadsLengths})
      : super(key: key);

  @override
  State<GetLeads> createState() => _GetLeadsState();
}

class _GetLeadsState extends State<GetLeads> {
  String search = '';
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  Map<String, String> dataFilter = {
    'Date Type': '',
    'From': '',
    'To': '',
  };
  List<dynamic> filteredData = [];
  bool loading = false;

  @override
  initState() {
    super.initState();
    _readFromFile();
  }

  void sendWhatsAppMessage() {
    // for(var data in filteredData){
    //   String leadContact = data['contact'];
    //   launchUrl(
    //       "https://wa.me/${number}?text=Hello");
    // }
    //   launchUrl(Uri.parse('https://wa.me/+923314058192?text=Hello'));
    String link = "whatsapp://send?phone=+923314058191&text=hello";
    launchUrl(Uri.parse(link));
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CustomTextField(
                    labelText: null,
                    onChanged: (value) {
                      setState(() {
                        search = value.toUpperCase();
                        filteredData = getData();
                      });
                    },
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          search = '';
                          filteredData = getData();
                        });
                      },
                    ),
                    hintText: 'Search',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    autoFocus: false,
                    controller: searchController,
                    textFieldColor: appBarColor,
                    secondaryColors: foregroundColor1,
                    textColor: Colors.white,
                    focusNode: searchFocusNode,
                    readOnly: false,
                    widthPercentage: 100,
                    heightPercentage: 0.075),
              ),
              Container(
                width: mediaSize.height * 0.060,
                height: mediaSize.height * 0.060,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  border: Border.all(color: foregroundColor1, width: 1),
                  color: appBarColor,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.filter_alt_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    searchFocusNode.unfocus();
                    await Navigator.pushNamed(context, 'leads filter screen',
                        arguments: widget.leadsName);
                    try {
                      final file =
                          await localFile(getFilterFileName(widget.leadsName));
                      String data = await file.readAsString();
                      setState(() {
                        Map<String, dynamic> filterSettings = jsonDecode(data);
                        String? tempDateType = filterSettings['Date Type'];
                        String? from = filterSettings['From'];
                        String? to = filterSettings['To'];
                        dataFilter = {
                          'Date Type': tempDateType ?? '',
                          'From': from ?? '',
                          'To': to ?? '',
                        };
                        filteredData = getData();
                        setLength(filteredData.length);
                        widget.onChanged();
                      });
                    } catch (fileSystemException) {
                      return;
                    }
                  },
                ),
              ),
              Container(
                width: mediaSize.height * 0.060,
                height: mediaSize.height * 0.060,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  border: Border.all(color: foregroundColor1, width: 1),
                  color: Colors.green,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.whatsapp,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    searchFocusNode.unfocus();
                    AwesomeDialogueBox.showDialogueWithoutCancel(
                      title: 'Under Development',
                      dialogType: DialogType.INFO,
                      context: context,
                      btnColor: Colors.green,
                      btnText: 'OK',
                      btnIcon: Icons.done_all,
                      duration: successMsgDuration,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Listener(
            onPointerHover: (event) {
              if (searchFocusNode.hasFocus) {
                setState(() {
                  searchFocusNode.unfocus();
                });
              }
            },
            child: Scrollbar(
              child: ListView(
                children: getChildren(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<dynamic> getData() {
    List<dynamic> filteredData = [];
    for (var element in widget.screenData) {
      if (search.isEmpty || isSearchPresent(element)) {
        if (isDateFilter(element)) {
          filteredData.add(element);
        }
      }
    }
    return filteredData;
  }

  List<Widget> getChildren() {
    List<Widget> children = [];
    for (var element in filteredData) {
      children.add(LeadsBubble(
        leadData: element,
        tokenId: widget.tokenId,
      ));
    }
    return children;
  }

  void setLength(int length) {
    switch (widget.leadsName) {
      case 'Total Leads':
        widget.leadsLengths.noOfTotalLeads = length;
        break;
      case 'New Leads':
        widget.leadsLengths.noOfNewLeads = length;
        break;
      case 'Un-Attended Leads':
        widget.leadsLengths.noOfUnAttendedLeads = length;
        break;
      case 'Visit Requests':
        widget.leadsLengths.noOfVisitRequests = length;
        break;
      case 'Pending Leads':
        widget.leadsLengths.noOfPendingLeads = length;
        break;
      case 'Sales':
        widget.leadsLengths.noOfSales = length;
        break;
    }
  }

  void _readFromFile() async {
    try {
      final file = await localFile(getFilterFileName(widget.leadsName));
      String data = await file.readAsString();
      setState(() {
        Map<String, dynamic> filterSettings = jsonDecode(data);
        String? tempDateType = filterSettings['Date Type'];
        String? from = filterSettings['From'];
        String? to = filterSettings['To'];
        dataFilter = {
          'Date Type': tempDateType ?? '',
          'From': from ?? '',
          'To': to ?? '',
        };
        filteredData = getData();
        setState(() {
          setLength(filteredData.length);
        });
        if (mounted) {
          widget.onChanged();
        }
      });
    } catch (fileSystemException) {
      filteredData = widget.screenData;
      setState(() {
        setLength(filteredData.length);
      });
      if (mounted) {
        widget.onChanged();
      }
      return;
    }
  }

  bool isSearchPresent(var element) {
    if (element['leadID'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['client'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['contact'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['project'].toString().toUpperCase().contains(search)) {
      return true;
    } else if (element['product'].toString().toUpperCase().contains(search)) {
      return true;
    } else {
      return false;
    }
  }

  bool isDateFilter(var element) {
    Map<String, String> data = {
      'Lead Date': 'leadDate',
      'Assign Date': 'assignedAT',
      'Follow-up Date': 'followUpOn',
      'Communication': 'communicationAT'
    };
    String? dateType = dataFilter['Date Type'];
    if (dateType != null && dateType.isNotEmpty) {
      DateTime from = DateTime.parse(dataFilter['From']!);
      DateTime to = DateTime.parse(dataFilter['To']!);
      String? elementDateTime = element[data[dateType]];
      if (elementDateTime != null) {
        DateTime elementDate = DateTime.parse(elementDateTime.split('T')[0]);
        if (elementDate.isBefore(from) || elementDate.isAfter(to)) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
    return true;
  }
}

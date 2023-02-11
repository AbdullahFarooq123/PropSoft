import 'dart:convert';
import 'dart:developer';

import 'package:flashchat/Classes/API.dart';
import 'package:flashchat/Constants.dart';
import 'package:flashchat/Widgets/CircularContainer.dart';
import 'package:flashchat/Widgets/CustomTextField.dart';
import 'package:flashchat/Widgets/FlexibleBar.dart';
import 'package:flashchat/Widgets/NotesBubble.dart';
import 'package:flashchat/Widgets/PopupCalendar.dart';
import 'package:flashchat/Widgets/PopupMenu.dart';
import 'package:flashchat/Widgets/PopupMenuContainer.dart';
import 'package:flashchat/Widgets/ProgressHud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class CommunicationScreen extends StatefulWidget {
  final String tokenId;
  final String leadId;
  final String teamId;
  final String assignedBy;

  const CommunicationScreen({
    Key? key,
    required this.leadId,
    required this.tokenId,
    required this.teamId,
    required this.assignedBy,
  }) : super(key: key);

  @override
  CommunicationScreenState createState() => CommunicationScreenState();
}

class CommunicationScreenState extends State<CommunicationScreen> {
  bool loading = true;
  String leadName = '';
  String leadContact = '';
  String leadProject = '';
  String leadProduct = '';
  String leadInventoryId = '';
  int editableIndex = -1;
  int indexToChange = -1;
  String selectedCommunicationType = '';
  String selectedLeadStatus = '';
  String selectedProduct = '';
  String editableCommunicationDate = '';
  String leadCommunicationId = '0';
  TextEditingController notesController = TextEditingController();
  FocusNode notesFocusNode = FocusNode();
  String followUpDate = getFormattedDate(getDate(DateTime.now()));
  List<dynamic> communicationsTable = [];
  Map<String, String> communicationTypes = {};
  Map<String, String> leadCommunicationStatuses = {};

  @override
  initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalProgress(
      inAsyncCall: loading,
      icon: const Icon(
        Icons.access_time_filled_outlined,
        color: Colors.white,
      ),
      child: Listener(
        onPointerHover: (event) {
          notesFocusNode.unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: FlexibleBar(
                    leadId: widget.leadId,
                    leadName: leadName,
                    leadContact: leadContact,
                    leadProject: leadProject,
                    leadProduct: leadProduct,
                    parentContext: context,
                    actions: [
                      GestureDetector(
                        child: CircularContainer(
                          containerColor: Colors.yellow.withOpacity(0.8),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 2),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          notesFocusNode.unfocus();
                          followUpDate = await PopupCalendar(
                                  dialogCalendarPickerValue: [
                                DateTime.parse(
                                    getFormattedDate(getDate(DateTime.now())))
                              ],
                                  context: context,
                                  calendarType: CalendarDatePicker2Type.single)
                              .getDates();
                        },
                      ),
                      PopupButton(
                        onSelected: (value) {
                          selectedLeadStatus = value;
                        },
                        menuItems: leadCommunicationStatuses.values.toList(),
                        textColor: Colors.white,
                        menuColor: appBarColor,
                        child: const CircularContainer(
                          containerColor: Colors.red,
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.contact_support,
                            color: Colors.white,
                            // size: 24,
                          ),
                        ),
                      ),
                      PopupButton(
                        onSelected: (value) {
                          selectedCommunicationType = value;
                        },
                        menuItems: communicationTypes.values.toList(),
                        textColor: Colors.white,
                        menuColor: appBarColor,
                        child: const CircularContainer(
                          containerColor: Colors.blue,
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            CupertinoIcons
                                .rectangle_stack_fill_badge_person_crop,
                            color: Colors.white,
                            // size: 24,
                          ),
                        ),
                      ),
                    ],
                    children: getHistory(),
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                            prefixIcon: null,
                            suffixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IntrinsicWidth(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.attach_file_sharp,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ] +
                                        (notesController.text.isNotEmpty
                                            ? []
                                            : [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.camera_enhance,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {},
                                                )
                                              ]),
                                  ),
                                )
                              ],
                            ),
                            hintText: 'Notes',
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            autoFocus: false,
                            controller: notesController,
                            textFieldColor: appBarColor,
                            secondaryColors: foregroundColor1,
                            textColor: Colors.white,
                            focusNode: notesFocusNode,
                            readOnly: false,
                            widthPercentage: 1,
                            heightPercentage: double.infinity,
                            maxLines: 6,
                            onChanged: (value) {
                              setState(() {});
                            },
                            labelText: null),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: notesController.text.isEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  Map<String, Object?> communication = {
                                    "leadCommunicationID": leadCommunicationId,
                                    "leadID": int.parse(widget.leadId),
                                    "communicationTypeID": int.parse(
                                        communicationTypes.keys.firstWhere(
                                            (k) =>
                                                communicationTypes[k] ==
                                                selectedCommunicationType)),
                                    "description": notesController.text,
                                    "at": indexToChange == -1
                                        ? DateTime.now()
                                            .toString()
                                            .replaceAll(' ', 'T')
                                            .split('.')[0]
                                        : editableCommunicationDate,
                                    "followUpOn":
                                        '${followUpDate.replaceAll(' ', '')}T00:00:00',
                                    "statusID": int.parse(
                                        leadCommunicationStatuses.keys
                                            .firstWhere(
                                      (k) =>
                                          leadCommunicationStatuses[k] ==
                                          (selectedLeadStatus ==
                                                  'No Communication'
                                              ? null
                                              : selectedLeadStatus),
                                    )),
                                    "teamID": int.parse(widget.teamId),
                                    "by": widget.assignedBy,
                                    "inventoryId": leadInventoryId
                                  };
                                  print(jsonEncode(communication));
                                  Response response = await (indexToChange == -1 ?  API.saveCommunications(widget.tokenId, communication) : API.updateCommunications(widget.tokenId, communication, widget.leadId));
                                  print(response.statusCode);
                                  print(response.body);
                                  Navigator.pop(context);
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getHistory() {
    List<Widget> history = [];
    int index = 0;
    for (var data in communicationsTable) {
      history.add(
        PopupMenuContainer(
          items: [
            PopupMenuItem(
              padding: const EdgeInsets.all(0),
              height: 0,
              value: 'Edit',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    CupertinoIcons.pencil_circle_fill,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
          onItemSelected: (index) async{
            Response response = await API.getCommunicationInfo(widget.tokenId, widget.leadId);

            leadCommunicationId = jsonDecode(response.body)['data'][0]['leadCommunicationID'].toString();
            log(response.body);
            setState(()  {
              Map<String, dynamic> currentCommunicationData =
                  communicationsTable[index];
              selectedLeadStatus = currentCommunicationData['status'] ?? '';
              selectedCommunicationType =
                  currentCommunicationData['communicationType'] ?? '';
              followUpDate =
                  currentCommunicationData['followUpOn']!.split('T')[0] ?? '';
              notesController.text = currentCommunicationData['comment'] ?? '';
              editableCommunicationDate = currentCommunicationData['at'] ?? '';
              indexToChange = index;
            });
          },
          key: null,
          menuColor: appBarColor,
          child: NotesBubble(
            communicationDate: getDate(DateTime.parse(data['at'])),
            leadStatus: data['status'],
            leadCommunication: data['communicationType'],
            leadFollowUp: getDate(DateTime.parse(data['followUpOn'])),
            comments: data['comment'],
            leadIndex: index,
          ),
        ),
      );
      index += 1;
    }
    return history;
  }

  Map<String, String> dataAsMap(List<dynamic> data) {
    Map<String, String> types = {};
    for (var values in data) {
      types[values['id'].toString()] = values['description'];
    }
    return types;
  }

  void fetchData() async {
    // try {
      Response communicationResponse =
          await API.getCommunications(widget.tokenId, widget.leadId);
      print('Body' + communicationResponse.statusCode.toString());
      Map<dynamic, dynamic> data =
          jsonDecode(communicationResponse.body)['data'];
      Map<dynamic, dynamic> leadInformation = data['table1'][0];
      communicationsTable = data['table2'];
      leadName = leadInformation['client'];
      leadContact = leadInformation['contact'];
      leadProject = leadInformation['project'];
      leadProduct = leadInformation['product'];
      leadInventoryId = leadInformation['inventoryId'].toString();
      communicationTypes = dataAsMap(data['table3']);
      leadCommunicationStatuses = dataAsMap(data['table4']);
      selectedLeadStatus = leadCommunicationStatuses.values.first;
      selectedCommunicationType = communicationTypes.values.first;
      setState(() {
        loading = false;
      });
    // } catch (serverTimedOut) {
    //   print(serverTimedOut);
    //   Navigator.pop(context, serverTimedOut);
    // }
  }
}

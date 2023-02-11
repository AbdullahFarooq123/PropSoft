import 'dart:convert';
import 'dart:io';

import 'package:flashchat/Widgets/CustomButton.dart';
import 'package:flashchat/Widgets/CustomDropBox.dart';
import 'package:flashchat/Widgets/CustomTextField.dart';
import 'package:flashchat/Widgets/PopupCalendar.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';

class LeadsFilterScreen extends StatefulWidget {
  final String screenName;

  const LeadsFilterScreen({Key? key, required this.screenName})
      : super(key: key);

  @override
  State<LeadsFilterScreen> createState() => _LeadsFilterScreenState();
}

class _LeadsFilterScreenState extends State<LeadsFilterScreen> {
  String dateType = 'Lead Date';
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  @override
  initState() {
    super.initState();
    readFiltersFromFile();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomDropBox(
                            color: foregroundColor1,
                            secondaryColor: foregroundColor2,
                            border:
                                Border.all(color: foregroundColor2, width: 2),
                            borderRadius: BorderRadius.circular(18),
                            type: const {
                              'Lead Date': 'Lead Date',
                              'Assign Date': 'Assign Date',
                              'Follow-up Date': 'Follow-up Date',
                              'Communication': 'Communication'
                            },
                            onChanged: (data) {
                              setState(() {
                                dateType = data!;
                              });
                            },
                            value: dateType,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: '',
                          labelText: 'From',
                          widthPercentage: 0.50,
                          heightPercentage: 0.07,
                          controller: fromController,
                          focusNode: null,
                          keyboardType: null,
                          obscureText: false,
                          autoFocus: false,
                          readOnly: true,
                          textFieldColor: foregroundColor1,
                          secondaryColors: foregroundColor2,
                          textColor: Colors.white,
                          prefixIcon: null,
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              String value = await PopupCalendar(
                                      dialogCalendarPickerValue: [
                                    (fromController.text.isNotEmpty
                                        ? DateTime.parse(getFormattedDate(
                                            fromController.text))
                                        : DateTime.parse(getFormattedDate(
                                            getDate(DateTime.now())))),
                                  ],
                                      context: context)
                                  .getDates();
                              List<String> dates = value.split('  to ');
                              if (dates.length == 2) {
                                String from = getDate(DateTime.parse(dates[0]));
                                String to = dates[1].contains('null')
                                    ? ''
                                    : getDate(DateTime.parse(
                                        dates[1].replaceAll(" ", '')));
                                fromController.text = from;
                                toController.text =
                                    to.isNotEmpty ? to : toController.text;
                              }
                            },
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          hintText: '',
                          labelText: 'To',
                          widthPercentage: 1,
                          heightPercentage: 0.07,
                          controller: toController,
                          focusNode: null,
                          keyboardType: null,
                          obscureText: false,
                          autoFocus: false,
                          readOnly: true,
                          textFieldColor: foregroundColor1,
                          secondaryColors: foregroundColor2,
                          textColor: Colors.white,
                          prefixIcon: null,
                          suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                String value = await PopupCalendar(
                                        dialogCalendarPickerValue: [
                                      (toController.text.isNotEmpty
                                          ? DateTime.parse(getFormattedDate(
                                              toController.text))
                                          : DateTime.parse(getFormattedDate(
                                              getDate(DateTime.now())))),
                                    ],
                                        context: context)
                                    .getDates();
                                List<String> dates = value.split('  to ');
                                if (dates.length == 2) {
                                  String from =
                                      getDate(DateTime.parse(dates[0]));
                                  String to = dates[1].contains('null')
                                      ? ''
                                      : getDate(DateTime.parse(
                                          dates[1].replaceAll(" ", '')));
                                  fromController.text = to.isNotEmpty
                                      ? from
                                      : fromController.text;
                                  toController.text = to.isEmpty ? from : to;
                                }
                              }),
                          onChanged: (value) {},
                          // },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'Today',
                        onPressed: () {
                          setState(() {
                            fromController.text = getDate(DateTime.now());
                            toController.text = getDate(DateTime.now());
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                          text: 'Yesterday',
                          onPressed: () {
                            setState(() {
                              fromController.text = getDate(DateTime.now()
                                  .subtract(const Duration(days: 1)));
                              toController.text = getDate(DateTime.now()
                                  .subtract(const Duration(days: 1)));
                            });
                          },
                          mediaSize: mediaSize,
                          buttonIcon: Icons.today),
                      getCustomButton(
                        text: 'Tomorrow',
                        onPressed: () {
                          setState(() {
                            fromController.text = getDate(DateTime.now()
                                .subtract(const Duration(days: -1)));
                            toController.text = getDate(DateTime.now()
                                .subtract(const Duration(days: -1)));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'This Week',
                        onPressed: () {
                          setState(() {
                            DateTime thisWeekStart = DateTime.now().subtract(
                                Duration(days: DateTime.now().weekday - 1));
                            fromController.text = getDate(thisWeekStart);
                            toController.text = getDate(DateTime.now());
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'Last Week',
                        onPressed: () {
                          setState(() {
                            DateTime lastWeekStart = DateTime.now().subtract(
                                Duration(days: DateTime.now().weekday + 6));
                            fromController.text = getDate(lastWeekStart);
                            toController.text = getDate(
                                lastWeekStart.add(const Duration(days: 6)));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                      getCustomButton(
                        text: 'Next Week',
                        onPressed: () {
                          setState(() {
                            DateTime nextWeekStart = DateTime.now().add(
                                Duration(days: DateTime.now().weekday + 6));
                            fromController.text = getDate(nextWeekStart);
                            toController.text = getDate(
                                nextWeekStart.add(const Duration(days: 6)));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'This Month',
                        onPressed: () {
                          setState(() {
                            DateTime today = DateTime.now();
                            fromController.text =
                                getDate(DateTime(today.year, today.month, 1));
                            toController.text = getDate(DateTime.now());
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'Last Month',
                        onPressed: () {
                          setState(() {
                            DateTime today = DateTime.now();
                            fromController.text = getDate(
                                DateTime(today.year, today.month - 1, 1));
                            toController.text =
                                getDate(DateTime(today.year, today.month, 0));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                      getCustomButton(
                        text: 'Next Month',
                        onPressed: () {
                          setState(() {
                            DateTime today = DateTime.now();
                            fromController.text = getDate(
                                DateTime(today.year, today.month + 1, 1));
                            toController.text = getDate(
                                DateTime(today.year, today.month + 2, 0));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'This Year',
                        onPressed: () {
                          setState(() {
                            DateTime today = DateTime.now();
                            fromController.text = getDate(
                                DateTime(today.year, DateTime.january, 1));
                            toController.text = getDate(DateTime.now());
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                        text: 'Last Year',
                        onPressed: () {
                          setState(() {
                            DateTime today = DateTime.now();
                            fromController.text = getDate(
                                DateTime(today.year - 1, DateTime.january, 1));
                            toController.text = getDate(
                                DateTime(today.year, DateTime.january, 0));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                      getCustomButton(
                        text: 'Next Year',
                        onPressed: () {
                          setState(() {
                            DateTime today = DateTime.now();
                            fromController.text = getDate(
                                DateTime(today.year + 1, DateTime.january, 1));
                            toController.text = getDate(
                                DateTime(today.year + 2, DateTime.january, 0));
                          });
                        },
                        mediaSize: mediaSize,
                        buttonIcon: Icons.today,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                          text: 'Clear',
                          onPressed: () {
                            setState(() {
                              dateType = 'Lead Date';
                              fromController.text = '';
                              toController.text = '';
                            });
                          },
                          mediaSize: mediaSize,
                          buttonIcon: Icons.clear,
                          buttonColor: Colors.redAccent),
                    ],
                  ),
                  Row(
                    children: [
                      getCustomButton(
                          text: 'Done',
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            final file = await localFile(getFilterFileName(widget.screenName));
                            await file.writeAsString(jsonEncode({
                              'Date Type': fromController.text.isNotEmpty &&
                                      toController.text.isNotEmpty
                                  ? dateType
                                  : '',
                              'From': fromController.text.isNotEmpty
                                  ? getFormattedDate(fromController.text)
                                  : '',
                              'To': toController.text.isNotEmpty
                                  ? getFormattedDate(toController.text)
                                  : '',
                            }));
                            navigator.pop();
                          },
                          mediaSize: mediaSize,
                          buttonIcon: Icons.done_all,
                          buttonColor: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void readFiltersFromFile() async {
    try {
      File file = await localFile(getFilterFileName(widget.screenName));
      String data = await file.readAsString();
      Map<String, dynamic> filterSettings = jsonDecode(data);
      String? tempDateType = filterSettings['Date Type'];
      String? from = filterSettings['From'];
      String? to = filterSettings['To'];
      if (tempDateType != null && tempDateType.isNotEmpty) {
        dateType = tempDateType;
        fromController.text = getDate(DateTime.parse(from!));
        toController.text = getDate(DateTime.parse(to!));
      }
      setState(() {});
    }catch(fileSystemException){
      return;
    }
  }

  Widget getCustomButton(
      {required String text,
      required VoidCallback onPressed,
      required Size mediaSize,
      required IconData buttonIcon,
      Color buttonColor = foregroundColor1}) {
    return Expanded(
      child: CustomButton(
        buttonChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(buttonIcon), Text(text)],
        ),
        onPressed: onPressed,
        mediaSize: mediaSize,
        percentHeight: 0.05,
        percentWidth: 1,
        buttonColor: buttonColor,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

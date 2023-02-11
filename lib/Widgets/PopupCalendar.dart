import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';

class PopupCalendar {
  var config = null;
  List<DateTime?> dialogCalendarPickerValue;
  final BuildContext context;
  final CalendarDatePicker2Type calendarType;


  PopupCalendar({
    required this.dialogCalendarPickerValue,
    required this.context,
    this.calendarType = CalendarDatePicker2Type.range,
  }){
    config = CalendarDatePicker2WithActionButtonsConfig(
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      calendarType: calendarType,
      selectedDayHighlightColor: kLighterColor,
      shouldCloseDialogAfterCancelTapped: true,
      weekdayLabelTextStyle:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      controlsTextStyle:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      dayTextStyle: const TextStyle(color: Colors.white),
      selectedDayTextStyle:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      disabledDayTextStyle: const TextStyle(color: kLighterColor),
      okButtonTextStyle:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      cancelButtonTextStyle:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      lastMonthIcon: const Icon(Icons.navigate_before, color: Colors.white),
      nextMonthIcon: const Icon(Icons.navigate_next, color: Colors.white),
    );
  }

  Future<String> getDates() async {
    var values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      borderRadius: 15,
      initialValue: dialogCalendarPickerValue,
      dialogBackgroundColor: kLightColor,
    );
    if (values != null) {
      dialogCalendarPickerValue = values;
      return _getValueText(
        config.calendarType,
        values,
      );
    } else {
      return DateTime.now().toString();
    }
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');
    if(datePickerType == CalendarDatePicker2Type.single){
      return valueText;
    }
    if (values.isNotEmpty) {
      var startDate = values[0].toString().replaceAll('00:00:00.000', '');
      var endDate = values.length > 1
          ? values[1].toString().replaceAll('00:00:00.000', '')
          : 'null';
      valueText = '$startDate to $endDate';
    } else {
      return 'null';
    }
    return valueText;
  }
}

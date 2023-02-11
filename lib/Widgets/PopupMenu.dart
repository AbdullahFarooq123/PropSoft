import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  final Function(String) onSelected;
  final Widget child;
  final List<String> menuItems;
  final Color menuColor;
  final Color textColor;

  const PopupButton(
      {Key? key,
      required this.onSelected,
      required this.child,
      required this.menuItems, required this.menuColor, required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: menuColor,
      onSelected: onSelected,
      child: child,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[]+getItems(),
    );
  }

  List<PopupMenuItem<String>> getItems() {
    List<PopupMenuItem<String>> items = [];
    for (String? menuItem in menuItems) {
      String value = menuItem ?? 'No Communication';
      items.add(
        PopupMenuItem(
          value: value,
          child: Text(value, style: TextStyle(color: textColor)),
        ),
      );
    }
    return items;
  }

}

import 'package:flutter/material.dart';

class CustomDropBox extends StatefulWidget {
  final Color color;
  final Color secondaryColor;
  final Border ?border;
  final BorderRadius ?borderRadius;
  final Map<String,String> type;
  final Function(String?) onChanged;
  final String value;
  const CustomDropBox({Key? key, required this.color, required this.border, required this.borderRadius, required this.type, required this.onChanged, required this.value, required this.secondaryColor}) : super(key: key);

  @override
  State<CustomDropBox> createState() => _CustomDropBoxState();
}

class _CustomDropBoxState extends State<CustomDropBox> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.color,
        border: widget.border,
        borderRadius: widget.borderRadius,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            iconEnabledColor: widget.secondaryColor,
            dropdownColor: widget.color,
            items: (() {
              List<DropdownMenuItem<String>> items = [];
              widget.type.forEach((key, value) {
                items.add(
                  DropdownMenuItem<String>(
                    value: key,
                    child: Text(value),
                  ),
                );
              });
              return items;
            })(),
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
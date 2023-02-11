import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final bool obscureText;
  final bool autoFocus;
  final bool readOnly;
  final Color textFieldColor;
  final Color secondaryColors;
  final Color textColor;
  final String? labelText;
  final String? hintText;
  final double heightPercentage;
  final double widthPercentage;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final int maxLines;
  final EdgeInsetsGeometry margin;
  const CustomTextField({
    Key? key,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.hintText,
    required this.keyboardType,
    required this.obscureText,
    required this.autoFocus,
    required this.controller,
    required this.textFieldColor,
    required this.secondaryColors,
    required this.textColor,
    required this.focusNode,
    required this.readOnly,
    required this.widthPercentage,
    required this.heightPercentage,
    required this.onChanged,
    required this.labelText,
    this.maxLines = 1,
    this.margin = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  }) : super(key: key);

  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final double borderRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    BorderSide borderSide =
    BorderSide(color: widget.secondaryColors, width: 2.0);
    return IntrinsicHeight(
      child: Container(
        margin: widget.margin,
        width: mediaSize.width * widget.widthPercentage,
        height: mediaSize.height * widget.heightPercentage,
        decoration: BoxDecoration(
          color: widget.textFieldColor,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: TextField(
          minLines: 1,
          textAlign: TextAlign.justify,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: TextStyle(color: widget.textColor),
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            hintStyle: TextStyle(
              color: widget.secondaryColors.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
            labelStyle: TextStyle(
              color: widget.secondaryColors,
              fontWeight: FontWeight.w500,
            ),
            // focusColor: foregroundColor1,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              borderSide: borderSide,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              borderSide: borderSide,
            ),
          ),
        ),
      ),
    );
  }
}
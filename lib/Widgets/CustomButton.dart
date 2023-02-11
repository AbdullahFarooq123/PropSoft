import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget buttonChild;
  final VoidCallback onPressed;
  final Size mediaSize;
  final double percentHeight;
  final double percentWidth;
  final Color buttonColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry borderRadius;

  const CustomButton({
    Key? key,
    required this.buttonChild,
    required this.onPressed,
    required this.mediaSize,
    required this.percentHeight,
    required this.percentWidth,
    required this.buttonColor,
    required this.margin,
    required this.padding,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaSize.width * percentWidth,
      height: mediaSize.height * percentHeight,
      margin: margin,
      padding: padding,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(10),
          backgroundColor: MaterialStateProperty.all(
            buttonColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide(
                color: buttonColor,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}
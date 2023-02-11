import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color containerColor;
  final BoxBorder? border;
  final Widget child;

  const CircularContainer(
      {Key? key,
      this.padding = const EdgeInsets.all(5),
      this.margin = const EdgeInsets.all(5),
      required this.containerColor,
      this.border,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        color: containerColor,
        border: border,
      ),
      child: child,
    );
  }
}

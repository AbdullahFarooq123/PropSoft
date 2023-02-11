import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:blur/blur.dart';

class CustomModalProgress extends StatefulWidget {
  final bool inAsyncCall;
  final Widget child;
  final Icon icon;

  const CustomModalProgress(
      {Key? key,
      required this.inAsyncCall,
      required this.child,
      required this.icon})
      : super(key: key);

  @override
  State<CustomModalProgress> createState() => _CustomModalProgressState();
}

class _CustomModalProgressState extends State<CustomModalProgress> {
  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: widget.inAsyncCall,
      opacity: 0,
      color: backgroundColor,
      progressIndicator: HeartbeatProgressIndicator(
        child: widget.icon,
      ),
      child: widget.inAsyncCall
          ? Blur(
              blur: 2,
              blurColor: kDarkColor,
              child: widget.child,
            )
          : widget.child,
    );
    ;
  }
}

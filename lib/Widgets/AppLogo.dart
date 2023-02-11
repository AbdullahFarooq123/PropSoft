import 'package:flashchat/Constants.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final Size mediaSize;
  final double percentLogoSize;
  final Color backgroundColor;
  final String url;

  const AppLogo(
      {Key? key,
      required this.mediaSize,
      required this.percentLogoSize,
      required this.backgroundColor,
      required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaSize.width * percentLogoSize,
      width: mediaSize.width * percentLogoSize,
      margin: EdgeInsets.only(
        top: (mediaSize.height * 0.40) / 2 - (mediaSize.width * 0.30) / 2,
        left: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        border: Border.all(
          color: foregroundColor1,
          width: 5.0,
        ),
      ),
      child: IntrinsicHeight(
        child: Material(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image(
              image: AssetImage(
                url,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
class SoftwareHouseLogo extends StatelessWidget {
  final Size mediaSize;
  final double percentHeight;
  final double percentWidth;
  final String url;
  const SoftwareHouseLogo({Key? key, required this.mediaSize, required this.percentHeight, required this.percentWidth, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaSize.height * percentHeight,
      width: mediaSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: mediaSize.width * percentWidth,
            child: Image(
              image: AssetImage(
                url,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


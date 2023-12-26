import 'dart:ui';

import 'package:flutter/material.dart';

class BackBlurWidget extends StatelessWidget {
  final double width;
  final double height;
  final String image1;
  final String image2;
  const BackBlurWidget({
    super.key,
    required this.width,
    required this.height,
    required this.image1,
    required this.image2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: width / 2,
              height: height,
              child: Image.asset(
                'assets/images/$image1',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: width / 2,
              height: height,
              child: Image.asset(
                'assets/images/$image2',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withOpacity(0.0),
            ),
          ),
        ),
      ],
    );
  }
}

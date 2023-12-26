import 'dart:ui';

import 'package:blur/blur.dart';
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
        Blur(
          blur: 5,
          blurColor: Colors.black,
          child: SizedBox(
            width: width,
            height: height,
          ),
        ),
        // ClipRRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        //     child: Container(
        //       color: Colors.white.withOpacity(.1),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

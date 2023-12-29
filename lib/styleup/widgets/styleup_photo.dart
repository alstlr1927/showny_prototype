import 'package:flutter/material.dart';

class StyleUpImageItem extends StatelessWidget {
  final List<String> imageList;
  const StyleUpImageItem({
    Key? key,
    required this.imageList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        children: imageList
            .map(
              (path) => SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/images/$path',
                  fit: BoxFit.cover,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {
  final String path;
  const NextPage({
    super.key,
    required this.path,
  });

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.path.isEmpty
          ? Container(
              color: Colors.amber,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.file(
                  File(widget.path),
                ),
              ],
            ),
    );
  }
}

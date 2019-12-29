import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final List<Widget> children;

  Wrapper({@required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

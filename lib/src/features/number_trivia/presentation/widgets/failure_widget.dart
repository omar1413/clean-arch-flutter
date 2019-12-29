import 'package:flutter/material.dart';

import 'base_wrapper.dart';
import 'bottom_body.dart';
import 'message.dart';

class FailureWidget extends StatelessWidget {
  final String content;

  FailureWidget(this.content);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      children: <Widget>[
        Message(
          title: 'Error',
          content: content,
        ),
        BottomBody(),
      ],
    );
  }
}

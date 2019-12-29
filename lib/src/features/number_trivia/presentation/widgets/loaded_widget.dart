import 'package:flutter/material.dart';

import 'base_wrapper.dart';
import 'bottom_body.dart';
import 'message.dart';

class LoadedWidget extends StatelessWidget {
  final String title;
  final String content;

  LoadedWidget(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      children: <Widget>[
        Message(
          title: title,
          content: content,
        ),
        BottomBody(),
      ],
    );
  }
}

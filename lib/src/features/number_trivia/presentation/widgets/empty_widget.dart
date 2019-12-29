import 'package:clean_arch/src/features/number_trivia/presentation/widgets/base_wrapper.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/widgets/message.dart';
import 'package:flutter/material.dart';

import 'bottom_body.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrapper(
      children: <Widget>[
        const Message(title: 'Start Searching!'),
        BottomBody(),
      ],
    );
  }
}

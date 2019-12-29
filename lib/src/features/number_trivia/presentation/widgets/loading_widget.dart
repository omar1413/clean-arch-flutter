import 'package:clean_arch/src/features/number_trivia/presentation/widgets/base_wrapper.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/widgets/bottom_body.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrapper(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.40,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
        BottomBody(),
      ],
    );

//      Container(
//      width: double.infinity,
//      height: double.infinity,
//      alignment: Alignment.center,
//      child: CircularProgressIndicator(),
//    );
  }
}

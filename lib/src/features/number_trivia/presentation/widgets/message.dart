import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String title;
  final String content;

  const Message({
    @required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          if (content != null)
            Flexible(
              child: AutoSizeText(
                content,
                maxFontSize: 20.0,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

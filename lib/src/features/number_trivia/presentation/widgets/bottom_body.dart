import 'package:clean_arch/src/features/number_trivia/presentation/bloc/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBody extends StatefulWidget {
  @override
  _BottomBodyState createState() => _BottomBodyState();
}

class _BottomBodyState extends State<BottomBody> {
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (str) {
              inputStr = str;
            },
            keyboardType: TextInputType.number,
            style: TextStyle(
              height: 1.0,
              fontSize: 20.0,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 40.0,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: dispatchConcreteNumberTriviaEvent,
                    child: Text('Search'),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: dispatchRandomNumberTriviaEvent,
                    child: Text('Random'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void dispatchConcreteNumberTriviaEvent() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandomNumberTriviaEvent() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

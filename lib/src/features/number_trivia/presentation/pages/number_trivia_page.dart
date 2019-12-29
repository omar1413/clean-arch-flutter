import 'package:clean_arch/src/features/number_trivia/presentation/bloc/block.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/widgets/empty_widget.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/widgets/failure_widget.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/widgets/loaded_widget.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_arch/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocProvider<NumberTriviaBloc>(
      create: (context) {
        return di();
      },
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (ctx, state) {
          print(state);
          if (state is Empty) return EmptyWidget();
          if (state is Loading) return LoadingWidget();
          if (state is Loaded)
            return LoadedWidget(
                state.trivia.number.toString(), state.trivia.text);
          if (state is Error) return FailureWidget(state.msg);

          return Placeholder();
        },
      ),
    );
  }
}

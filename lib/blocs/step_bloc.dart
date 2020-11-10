import 'dart:async';
import 'package:test_app/blocs/bloc.dart';

class StepBloc extends Bloc {
  StreamController _controller = StreamController.broadcast();

  Stream get getStep => _controller.stream;

  dispose() {
    _controller.close();
  }
}

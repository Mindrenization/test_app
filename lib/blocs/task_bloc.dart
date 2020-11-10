import 'dart:async';
import 'package:test_app/blocs/bloc.dart';

class TaskBloc extends Bloc {
  StreamController _controller = StreamController.broadcast();

  Stream get getTask => _controller.stream;

  dispose() {
    _controller.close();
  }
}

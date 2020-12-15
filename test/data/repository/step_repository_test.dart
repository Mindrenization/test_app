import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/repository/step_repository.dart';

class StepRepositoryMock extends Mock implements StepRepository {}

void main() {
  group('StepRepository', () {
    StepRepository stepRepository;
    setUp(() {
      stepRepository = StepRepositoryMock();
    });
    test('Создание шага', () async {
      TaskStep step = TaskStep('');
      await stepRepository.createStep('', '', step);
      verify(stepRepository.createStep(any, any, any));
    });
    test('Удаление шага', () async {
      await stepRepository.deleteStep('', '', '');
      verify(stepRepository.deleteStep(any, any, any));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:test_app/data/repository/step_repository.dart';

class RepositoryMock extends Mock implements Repository {}

class DbStepWrapperMock extends Mock implements DbStepWrapper {}

void main() {
  group('StepRepository', () {
    StepRepository stepRepository;
    Repository repository;
    DbStepWrapper dbStepWrapper;
    setUp(() {
      repository = RepositoryMock();
      dbStepWrapper = DbStepWrapperMock();
      stepRepository = StepRepository(repository, dbStepWrapper);
    });
    test('Создание шага', () async {
      TaskStep step = TaskStep('');
      await stepRepository.createStep('', '', step);
      verify(dbStepWrapper.createStep(any));
      verify(repository.createStep(any, any, any));
    });
    test('Удаление шага', () async {
      await stepRepository.deleteStep('', '', '');
      verify(dbStepWrapper.deleteStep(any));
      verify(repository.deleteStep(any, any, any));
    });
  });
}

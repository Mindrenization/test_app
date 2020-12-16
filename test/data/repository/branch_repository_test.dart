import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/database/db_branch_wrapper.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/branch_repository.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:test_app/data/repository/task_repository.dart';

// class BranchRepositoryMock extends Mock implements BranchRepository {}

class DbBranchWrapperMock extends Mock implements DbBranchWrapper {}

class RepositoryMock extends Mock implements Repository {}

class TaskRepositoryMock extends Mock implements TaskRepository {}

void main() {
  group('BranchRepository', () {
    List<Branch> branchList = [
      Branch('1', '', tasks: [Task('1', '', '', DateTime(1), DateTime(1), DateTime(1))]),
      Branch('2', '', tasks: [Task('2', '', '', DateTime(1), DateTime(1), DateTime(1))]),
    ];
    BranchRepository branchRepository;
    DbBranchWrapper dbBranchWrapper;
    Repository repository;
    TaskRepository taskRepository;
    setUp(() {
      taskRepository = TaskRepositoryMock();
      repository = RepositoryMock();
      dbBranchWrapper = DbBranchWrapperMock();
      branchRepository = BranchRepository(
        repository,
        dbBranchWrapper,
        taskRepository,
      );
    });
    test('Создание ветки', () async {
      Branch branch = Branch('', '');
      await branchRepository.createBranch(branch);
      verify(dbBranchWrapper.createBranch(any));
    });
    test('Удаление ветки', () async {
      when(repository.getBranchList()).thenAnswer((_) async => branchList);
      await branchRepository.deleteBranch('1');
      verify(dbBranchWrapper.deleteBranch(any));
      verify(repository.deleteBranch(any));
    });
  });
}

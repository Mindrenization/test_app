import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/branch_repository.dart';

class BranchRepositoryMock extends Mock implements BranchRepository {}

void main() {
  group('BranchRepository', () {
    BranchRepository branchRepository;
    setUp(() {
      branchRepository = BranchRepositoryMock();
    });
    test('Создание ветки', () async {
      Branch branch = Branch('', '');
      await branchRepository.createBranch(branch);
      verify(branchRepository.createBranch(any));
    });
    test('Удаление ветки', () async {
      await branchRepository.deleteBranch('');
      verify(branchRepository.deleteBranch(any));
    });
  });
}

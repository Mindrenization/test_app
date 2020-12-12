import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/data/repository/branch_repository.dart';

class MockBranchRepository extends Mock implements BranchRepository {}

void main() {
  group('BranchRepository', () {
    BranchRepository branchRepository;
    setUp(() {
      branchRepository = MockBranchRepository();
    });
    test('Создание ветки', () async {
      await branchRepository.createBranch(Branch('', ''));
      verify(branchRepository.createBranch(any));
    });
    test('Удаление ветки', () async {
      await branchRepository.deleteBranch('');
      verify(branchRepository.deleteBranch(any));
    });
  });
}

import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/repository/repository.dart';

class StepRepository {
  final Repository repository;
  final DbStepWrapper dbStepWrapper;
  StepRepository(this.repository, this.dbStepWrapper);
  Future<void> createStep(String branchId, String taskId, TaskStep step) async {
    await dbStepWrapper.createStep(step);
    repository.createStep(branchId, taskId, step);
  }

  Future<void> deleteStep(String branchId, String taskId, String stepId) async {
    await dbStepWrapper.deleteStep(stepId);
    repository.deleteStep(branchId, taskId, stepId);
  }
}

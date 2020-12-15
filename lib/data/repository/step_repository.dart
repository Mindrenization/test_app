import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/repository/repository.dart';

class StepRepository {
  DbStepWrapper _dbStepWrapper = DbStepWrapper();

  Future<void> createStep(String branchId, String taskId, TaskStep step) async {
    await _dbStepWrapper.createStep(step);
    Repository.instance.createStep(branchId, taskId, step);
  }

  Future<void> deleteStep(String branchId, String taskId, String stepId) async {
    await _dbStepWrapper.deleteStep(stepId);
    Repository.instance.deleteStep(branchId, taskId, stepId);
  }
}

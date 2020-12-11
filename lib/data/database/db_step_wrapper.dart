import 'package:test_app/data/database/db_step.dart';
import 'package:test_app/data/models/task_step.dart';

class DbStepWrapper {
  DbStep _dbStep = DbStep();

  Future<List<TaskStep>> getStepList(String id) async {
    return _dbStep.fetchStepList(id);
  }

  Future<void> createStep(TaskStep step) async {
    await _dbStep.createStep(step);
  }

  Future<void> updateStep(TaskStep step) async {
    await _dbStep.updateStep(step);
  }

  Future<void> deleteStep(String stepId) async {
    await _dbStep.deleteStep(stepId);
  }
}

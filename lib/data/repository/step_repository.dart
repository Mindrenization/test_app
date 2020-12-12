import 'package:test_app/data/database/db_step_wrapper.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/models/task_step.dart';
import 'package:test_app/data/repository/repository.dart';

class StepInteractor {
  DbStepWrapper _dbStepWrapper = DbStepWrapper();

  Future<Task> createStep(
      String _branchId, String _taskId, TaskStep _step) async {
    Task _task = Repository.instance.getTask(_branchId, _taskId);
    await _dbStepWrapper.createStep(_step);
    _task.steps.add(_step);
    return _task;
  }

  Future<Task> deleteStep(_branchId, _taskId, _stepId) async {
    Task _task = Repository.instance.getTask(
      _branchId,
      _taskId,
    );
    TaskStep _step = Repository.instance.getStep(_branchId, _taskId, _stepId);
    await _dbStepWrapper.deleteStep(_step);
    _task.steps.removeWhere((element) => _step.id == element.id);
    return _task;
  }
}

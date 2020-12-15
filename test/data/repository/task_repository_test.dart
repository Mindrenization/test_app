import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/repository/task_repository.dart';

class TaskRepositoryMock extends Mock implements TaskRepository {}

void main() {
  group('TaskRepository', () {
    TaskRepository taskRepository;
    setUp(() {
      taskRepository = TaskRepositoryMock();
    });
    test('Создание задачи', () async {
      Task task = Task('', '', '', DateTime(1), DateTime(1), DateTime(1));
      await taskRepository.createTask(task, '');
      verify(taskRepository.createTask(any, any));
    });
    test('Удаление задачи', () async {
      await taskRepository.deleteTask('', '');
      verify(taskRepository.deleteTask(any, any));
    });
    test('Удаление выполненных задач', () async {
      await taskRepository.deleteCompletedTasks('');
      verify(taskRepository.deleteCompletedTasks(any));
    });
    test('Сохранение изображения', () async {
      await taskRepository.saveImage('', '', FlickrImage('', '', ''));
      verify(taskRepository.saveImage(any, any, any));
    });
    test('Удаление изображения', () async {
      await taskRepository.deleteImage('', '', '');
      verify(taskRepository.deleteImage(any, any, any));
    });
  });
}

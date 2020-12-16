import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/database/db_task_wrapper.dart';
import 'package:test_app/data/models/flickr_image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/notification_service.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:test_app/data/repository/task_repository.dart';

class DbTaskWrapperMock extends Mock implements DbTaskWrapper {}

class RepositoryMock extends Mock implements Repository {}

class DbFlickrMock extends Mock implements DbFlickr {}

class NotificationServiceMock extends Mock implements NotificationService {}

void main() {
  group('TaskRepository', () {
    TaskRepository taskRepository;
    DbTaskWrapper dbTaskWrapper;
    DbFlickr dbFlickr;
    Repository repository;
    NotificationService notificationService;
    Task task = Task('', '', '', DateTime(1), DateTime(1), DateTime(1));
    setUp(() {
      dbTaskWrapper = DbTaskWrapperMock();
      dbFlickr = DbFlickrMock();
      repository = RepositoryMock();
      notificationService = NotificationServiceMock();
      taskRepository = TaskRepository(repository, dbTaskWrapper, dbFlickr, notificationService);
    });
    test('Создание задачи', () async {
      await taskRepository.createTask(task, '');
      verify(dbTaskWrapper.createTask(any));
      verify(repository.createTask(any, any));
    });
    test('Удаление задачи', () async {
      when(repository.getTask(any, any)).thenReturn(task);
      await taskRepository.deleteTask('', '');
      verify(notificationService.cancelNotification(any));
      verify(dbTaskWrapper.deleteTask(any));
      verify(dbTaskWrapper.deleteAllSteps(any));
      verify(dbTaskWrapper.deleteAllImages(any));
      verify(repository.deleteTask(any, any));
    });
    test('Сохранение изображения', () async {
      await taskRepository.saveImage('', '', FlickrImage('', '', ''));
      verify(dbFlickr.saveImage(any));
      verify(repository.saveImage(any, any, any));
    });
    test('Удаление изображения', () async {
      await taskRepository.deleteImage('', '', '');
      verify(dbTaskWrapper.deleteImage(any));
      verify(repository.deleteImage(any, any, any));
    });
  });
}

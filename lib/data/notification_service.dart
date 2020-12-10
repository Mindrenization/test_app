import 'package:flutter/services.dart';
import 'package:test_app/data/models/task.dart';

class NotificationService {
  static const platform = MethodChannel('test_app/notifications');

  Future<bool> scheduleNotification(Task task) async {
    const method = 'scheduleNotification';
    return await platform.invokeMethod(method, {
      "task_id": task.id,
      "title": task.title,
      "time": task.notification.millisecondsSinceEpoch,
    });
  }

  Future<bool> cancelNotification(Task task) async {
    const method = 'cancelNotification';
    return await platform.invokeMethod(method, {
      "task_id": task.id,
      "title": task.title,
      "time": task.notification.millisecondsSinceEpoch,
    });
  }
}

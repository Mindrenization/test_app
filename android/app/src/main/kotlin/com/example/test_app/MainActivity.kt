package com.example.test_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.AlarmManager
import android.app.Notification
import android.app.PendingIntent
import android.content.Intent
// import android.content.Context
// import android.content.ContextWrapper
// import android.content.IntentFilter
// import android.os.Build.VERSION
// import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
//   private val CHANNEL = "notifications"
//   override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//     super.configureFlutterEngine(flutterEngine)
//     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//       call, result ->   
//         when (call.method) {
//          "scheduleNotification" -> {
//              val taskId = call.argument<String>("task_id")
//              val title = call.argument<String>("title")
//              val time = call.argument<Long>("time_millis")
//              val notification = getNotification(title, time)
//              val id = taskId.hashCode()
//              scheduleNotification(notification, id, time)
//              return@setMethodCallHandler result.success(true)
//          }
//          else -> {
//              return@setMethodCallHandler result.notImplemented()
//          }
//       }
//     }
//   }
//   private fun scheduleNotification(){}

//   private fun getNotification(){}
}

package com.example.tamfinans_case

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.WindowManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.tamfinans/security"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableProtection" -> {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                "disableProtection" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                "isScreenRecording" -> {
                    result.success(false) 
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        io.flutter.plugin.common.EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.tamfinans/security/events").setStreamHandler(
            object : io.flutter.plugin.common.EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: io.flutter.plugin.common.EventChannel.EventSink?) {
                }

                override fun onCancel(arguments: Any?) {
                }
            }
        )
    }
}

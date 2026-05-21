package com.safmeh.safmeh

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.safmeh/hardware_button_events"
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    eventSink = sink
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        val type = when (keyCode) {
            KeyEvent.KEYCODE_POWER -> "power_button"
            KeyEvent.KEYCODE_VOLUME_UP -> "volume_up"
            KeyEvent.KEYCODE_VOLUME_DOWN -> "volume_down"
            else -> return super.onKeyDown(keyCode, event)
        }
        eventSink?.success(mapOf(
            "type" to type,
            "timestamp" to System.currentTimeMillis()
        ))
        return true
    }
}

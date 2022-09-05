import io.flutter.plugins.GeneratedPluginRegistrant
package com.example.appo

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
   super.configureFlutterEngine(flutterEngine)
   GeneratedPluginRegistrant.registerWith(flutterEngine);
   configureChannels(flutterEngine)
}

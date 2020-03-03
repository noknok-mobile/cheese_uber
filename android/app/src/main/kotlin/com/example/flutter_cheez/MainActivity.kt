package com.example.flutter_cheez

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory;

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("4ab2a4cc-4b90-4a52-a0c3-151d3f135450");
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}

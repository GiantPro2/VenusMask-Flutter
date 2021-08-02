//package com.thatproject.flutter_app_esp32_dust_sensor;
//
//import io.flutter.app.FlutterApplication;
//import io.flutter.plugin.common.PluginRegistry;
//import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
//import io.flutter.plugins.GeneratedPluginRegistrant;
////import io.flutter.plugins.pathprovider.PathProviderPlugin;
//import com.ryanheise.audioservice.AudioServicePlugin;
//import com.ryanheise.just_audio.JustAudioPlugin;
//import com.ryanheise.audio_session.AudioSessionPlugin;
//
//class Application : FlutterApplication(), PluginRegistrantCallback {
//      override fun onCreate() {
//        super.onCreate();
////          PathProviderPlugin.registerWith(PluginRegistry.Registrar!);
//          AudioServicePlugin.setPluginRegistrantCallback(this);
////          AudioSessionPlugin.setPluginRegistrant(this);
//      }
//
//    override fun registerWith(reg: PluginRegistry?) {
////        GeneratedPluginRegistrant.registerWith(reg)
//        AudioServicePlugin.registerWith(reg?.registrarFor("com.ryanheise.audioservice.AudioServicePlugin"))
////        AudioSessionPlugin.registerWith(reg?.registrarFor("com.ryanheise.audio_session.AudioSessionPlugin"))
//        JustAudioPlugin.registerWith(reg?.registrarFor(".ryanheise.just_audio.JustAudioPlugin"))
//
//    }
//}
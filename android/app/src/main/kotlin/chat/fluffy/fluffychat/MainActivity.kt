package chat.fluffy.fluffychat

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return provideEngine(this)
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Plugin registration is handled in provideEngine (automaticallyRegisterPlugins = true).
        // The vibrator channel is registered in provideEngine so it works in the
        // FCM background isolate too. Activity-only channels stay here.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chat.fluffy.fluffychat/permissions",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "canUseFullScreenIntent" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                        result.success(nm.canUseFullScreenIntent())
                    } else {
                        result.success(true)
                    }
                }
                "openFullScreenIntentSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        try {
                            startActivity(
                                Intent(
                                    Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                                    Uri.parse("package:$packageName"),
                                ),
                            )
                        } catch (_: Exception) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                                    Uri.parse("package:$packageName"),
                                ),
                            )
                        }
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    companion object {
        var engine: FlutterEngine? = null

        fun provideEngine(context: Context): FlutterEngine {
            val eng = engine ?: FlutterEngine(context, emptyArray(), true, false)
            engine = eng
            registerRingerVibrationChannel(context.applicationContext, eng)
            return eng
        }

        // Repeating ringtone-class vibration. Owned by the engine so it works in
        // both the foreground activity and the FCM background isolate.
        private var vibrator: Vibrator? = null

        private fun registerRingerVibrationChannel(
            appContext: Context,
            engine: FlutterEngine,
        ) {
            MethodChannel(
                engine.dartExecutor.binaryMessenger,
                "chat.fluffy.fluffychat/ringer_vibration",
            ).setMethodCallHandler { call, result ->
                when (call.method) {
                    "start" -> {
                        startRingerVibration(appContext)
                        result.success(true)
                    }
                    "stop" -> {
                        stopRingerVibration()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
        }

        private fun ensureVibrator(context: Context): Vibrator? {
            val cached = vibrator
            if (cached != null) return cached
            val v = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE)
                    as VibratorManager
                vm.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }
            vibrator = v
            return v
        }

        private fun startRingerVibration(context: Context) {
            val v = ensureVibrator(context) ?: return
            if (!v.hasVibrator()) return
            v.cancel()
            // wait 0ms, vibrate 1000ms, pause 1000ms — repeat from index 0.
            val timings = longArrayOf(0L, 1000L, 1000L)
            val attrs = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .build()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                v.vibrate(VibrationEffect.createWaveform(timings, 0), attrs)
            } else {
                @Suppress("DEPRECATION")
                v.vibrate(timings, 0, attrs)
            }
        }

        private fun stopRingerVibration() {
            vibrator?.cancel()
        }
    }
}

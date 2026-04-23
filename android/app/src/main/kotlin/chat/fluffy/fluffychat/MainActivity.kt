package chat.fluffy.fluffychat

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
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
        resetCallkitChannelIfNeeded(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Plugin registration is handled in provideEngine (automaticallyRegisterPlugins = true).
        // We only register custom method channels here.
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
            return eng
        }

        // Ensures the callkit incoming channel has vibration disabled so the
        // CallkitSoundPlayerManager's repeating vibration is not overridden by
        // the one-shot channel vibration triggered when the notification is posted.
        fun resetCallkitChannelIfNeeded(context: Context) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channelId = "callkit_incoming_channel_id"
            val existing = nm.getNotificationChannel(channelId)
            // Don't recreate if the user deliberately blocked the channel.
            if (existing != null && existing.importance == NotificationManager.IMPORTANCE_NONE) return
            // Recreate whenever vibration is enabled (wrong state) or channel is missing.
            if (existing == null || existing.shouldVibrate()) {
                nm.deleteNotificationChannel(channelId)
                val channel = NotificationChannel(
                    channelId,
                    "Incoming Call",
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    setSound(null, null)
                    enableVibration(false)
                    lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
                }
                nm.createNotificationChannel(channel)
            }
        }
    }
}

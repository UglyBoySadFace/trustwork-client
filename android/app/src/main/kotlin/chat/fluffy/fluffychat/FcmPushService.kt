package chat.fluffy.fluffychat

import com.famedly.fcm_shared_isolate.FcmSharedIsolateService

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import android.content.Context

class FcmPushService : FcmSharedIsolateService() {

    override fun onCreate() {
        super.onCreate()
        // Ensure the callkit incoming channel has vibration disabled before any
        // notification is shown. MainActivity.onCreate() does the same for the
        // foreground case, but it is never called when the app is killed.
        MainActivity.resetCallkitChannelIfNeeded(applicationContext)
    }

    override fun getEngine(): FlutterEngine {
        return provideEngine(getApplicationContext())
    }

    companion object {
        fun provideEngine(context: Context): FlutterEngine {
            var engine = MainActivity.engine
            if (engine == null) {
                engine = MainActivity.provideEngine(context)
                engine.getLocalizationPlugin().sendLocalesToFlutter(
                    context.getResources().getConfiguration())
                engine.getDartExecutor().executeDartEntrypoint(
                    DartEntrypoint.createDefault())
            }
            return engine
        }
    }
}

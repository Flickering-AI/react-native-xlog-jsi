package com.reactnativexlogjsi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.tencent.mars.xlog.Log;
import com.tencent.mars.xlog.Xlog;

@ReactModule(name = XlogJsiModule.NAME)
public class XlogJsiModule extends ReactContextBaseJavaModule {
    public static final String NAME = "XlogJsi";

    public XlogJsiModule(ReactApplicationContext reactContext) {
        super(reactContext);
      String externalPath = reactContext.getExternalFilesDir(null).getAbsolutePath();
      String logPath = externalPath + "/ahaaa_math/ahaaa_math_log";
      // this is necessary, or may crash for SIGBUS
      String cachePath = reactContext.getFilesDir().toString() + "/ahaaa_math_log";

      // init xlog
      Log.setLogImp(new Xlog());
      if (BuildConfig.DEBUG) {
        Log.appenderOpen(Xlog.LEVEL_ALL, Xlog.AppednerModeSync, cachePath, logPath, "AhaaaMath", 3);
        Log.setConsoleLogOpen(true);
      } else {
        Log.appenderOpen(
          Xlog.LEVEL_ALL,
          Xlog.AppednerModeSync,
          cachePath,
          logPath,
          "AhaaaMath",
          3
        );
        Log.setConsoleLogOpen(false);
      }
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    static {
        try {
          System.loadLibrary("c++_shared");
          System.loadLibrary("marsxlog");
            // Used to load the 'native-lib' library on application startup.
            System.loadLibrary("cpp");
            interceptAllReactNativeLog();
        } catch (Exception ignored) {
        }
    }

    public static native int interceptAllReactNativeLog();
}

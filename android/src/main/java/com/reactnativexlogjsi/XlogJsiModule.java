package com.reactnativexlogjsi;

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
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    public boolean install(String rootDirectory, String namePrefix, int cacheDays, boolean isConsoleLogOpen) {
        try {
            ReactApplicationContext reactContext = getReactApplicationContext();
            Log.setLogImp(new Xlog());
            Log.appenderOpen(Xlog.LEVEL_ALL, Xlog.AppednerModeAsync, rootDirectory, rootDirectory, namePrefix, cacheDays);
            Log.setConsoleLogOpen(isConsoleLogOpen);

            interceptAllReactNativeLog(reactContext.getJavaScriptContextHolder().get());
            return true;
        } catch (Exception exception) {
            Log.e(NAME, "Failed to install Xlog JSI Bindings!", exception);
            return false;
        }
    }

    @ReactMethod
    public void appenderFlush(boolean isSync, Promise promise) {
        Log.appenderFlushSync(isSync);
        promise.resolve(true);
    }

    @Override
    public String getName() {
        return NAME;
    }

    static {
        try {
          System.loadLibrary("c++_shared");
          System.loadLibrary("marsxlog");
            // Used to load the 'native-lib' library on application startup.
            System.loadLibrary("cpp");
        } catch (Exception ignored) {
        }
    }

    public static native int interceptAllReactNativeLog(long jsiPtr);
}

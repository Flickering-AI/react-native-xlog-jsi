package com.reactnativexlogjsi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

@ReactModule(name = XlogJsiModule.NAME)
public class XlogJsiModule extends ReactContextBaseJavaModule {
    public static final String NAME = "XlogJsi";

    public XlogJsiModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    static {
        try {
            // Used to load the 'native-lib' library on application startup.
            System.loadLibrary("cpp");
            interceptAllReactNativeLog();
        } catch (Exception ignored) {
        }
    }

    public static native int interceptAllReactNativeLog();
}

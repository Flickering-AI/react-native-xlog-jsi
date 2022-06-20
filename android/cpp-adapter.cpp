#include <jni.h>
#include "react-native-xlog-jsi.h"

extern "C"
JNIEXPORT jint JNICALL
Java_com_reactnativexlogjsi_XlogJsiModule_interceptAllReactNativeLog(JNIEnv *env, jclass clazz) {
    return ReactNativeXLog::interceptAllReactNativeLog();
}

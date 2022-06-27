#include "react-native-xlog-jsi.h"

extern "C"
JNIEXPORT jint JNICALL
Java_com_reactnativexlogjsi_XlogJsiModule_interceptAllReactNativeLog(JNIEnv *env, jclass clazz, jlong jsiPtr) {
    jsi::Runtime * runtime = reinterpret_cast<jsi::Runtime*>(jsiPtr);
    return ReactNativeXLog::interceptAllReactNativeLog(*runtime);
}

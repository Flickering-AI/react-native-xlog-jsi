#include "react-native-xlog-jsi.h"

namespace ReactNativeXLog {
	int interceptAllReactNativeLog(jsi::Runtime& jsiRuntime) {
#ifdef ANDROID
        setLogHandler([](int priority, const char *tag, const char *message) {
            __ComLog(priority - 2, tag, message, "", 0, "");
        });
#endif
        auto xlogAppenderFlush = jsi::Function::createFromHostFunction(jsiRuntime,
                                                                       jsi::PropNameID::forAscii(jsiRuntime, "xlogAppenderFlush"),
                                                                       1,
                                                                       [](jsi::Runtime& runtime,
                                                                          const jsi::Value& thisValue,
                                                                          const jsi::Value* arguments,
                                                                          size_t count) -> jsi::Value {
                                                                           if (count != 1) {
                                                                               throw jsi::JSError(runtime, "xlogAppenderFlush expects one argument (boolean isSync)!");
                                                                           }
//                                                                           jsi::Object config = arguments[0].asObject(runtime);
//                                                                           jsi::Value value = config.getProperty(runtime, "isSync");
                                                                           bool isSync = arguments[0].getBool();
#ifdef ANDROID
                                                                           Java_com_tencent_mars_xlog_Xlog_appenderFlush(
                                                                                   nullptr, nullptr, 0, isSync);
//                                                                           std::string className = "com/tencent/mars/xlog/Log";
//                                                                           jclass clazz = globalJNIEnv->FindClass(className.c_str());
//                                                                           jmethodID methodID = globalJNIEnv->GetStaticMethodID(clazz, "appenderFlush", nullptr);
//                                                                           globalJNIEnv->CallStaticVoidMethod(clazz, methodID);
#endif
#ifdef __APPLE__
                                                                          if (isSync) {
                                                                            mars::xlog::appender_flush_sync();
                                                                          } else {
                                                                            mars::xlog::appender_flush();
                                                                          }
#endif
                                                                           return jsi::Value(runtime, jsi::Value(1));
                                                                       });
        (jsiRuntime).global().setProperty(jsiRuntime, "xlogAppenderFlush", std::move(xlogAppenderFlush));
		return 1;
	}

	void install() {

	}
}

#include "react-native-xlog-jsi.h"

#ifdef ANDROID
#include <fb/log.h>
#include "xlogger/xloggerbase.h"
#include "xlogger/xlogger.h"
#include "xlogger/android_xlog.h"
#endif

namespace ReactNativeXLog {
	int interceptAllReactNativeLog() {
#ifdef ANDROID
        setLogHandler([](int priority, const char *tag, const char *message) {
            __ComLog(priority - 2, tag, message, "", 0, "");
        });
#endif
		return 200;
	}
}

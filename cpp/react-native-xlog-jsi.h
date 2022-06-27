#ifndef EXAMPLE_H
#define EXAMPLE_H

#include <jsi/jsi.h>

#ifdef ANDROID
#include <jni.h>
#include <fb/log.h>
#include "xlog/android_xlog.h"
#include "xlog/xlogger_interface.h"
#endif

#ifdef __APPLE__
#include "mars/xlog/xlogger_interface.h"
#endif

using namespace facebook;
namespace ReactNativeXLog {
  int interceptAllReactNativeLog(jsi::Runtime& jsiRuntime);
}

#endif /* EXAMPLE_H */

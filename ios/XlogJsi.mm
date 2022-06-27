#import "XlogJsi.h"
#import "react-native-xlog-jsi.h"
#import "React/RCTLog.h"
#include "LogHelper.h"
#include "mars/xlog/appender.h"
#import <sys/xattr.h>
#import <React/RCTBridge+Private.h>

@implementation XlogJsi

+(void)applicationWillTerminate {
  mars::xlog::appender_close();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install:(nonnull NSString*)storageDirectory namePrefix:(nonnull NSString*)namePrefix cacheDays:(nonnull NSNumber*)cacheDays isConsoleLogOpen:(BOOL)isConsoleLogOpen)
{
  // set do not backup for logpath
  const char* attrName = "com.apple.MobileBackup";
  u_int8_t attrValue = 1;
  setxattr([storageDirectory UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
  // init xlog
#if DEBUG
  xlogger_SetLevel((TLogLevel)kLevelDebug);
#else
  xlogger_SetLevel((TLogLevel)kLevelInfo);
#endif
  mars::xlog::appender_set_console_log(isConsoleLogOpen);
  mars::xlog::XLogConfig config;
  config.mode_ = mars::xlog::kAppenderAsync;
  config.logdir_ = [storageDirectory UTF8String];
  config.nameprefix_ = [namePrefix UTF8String];
  config.pub_key_ = "";
  config.compress_mode_ = mars::xlog::kZlib;
  config.compress_level_ = 0;
  config.cachedir_ = "";
  config.cache_days_ = [cacheDays intValue];
  appender_open(config);
  RCTSetLogFunction(^(
                      RCTLogLevel level,
                      __unused RCTLogSource source,
                      NSString *fileName,
                      NSNumber *lineNumber,
                      NSString *message) {
                        NSString *content = RCTFormatLog([NSDate date], level, fileName, lineNumber, message);
                        const char *tag = "RN";
                        TLogLevel tLogLevel = kLevelAll;
                        switch (level) {
                          case RCTLogLevelTrace:
                            tLogLevel = kLevelAll;
                            break;
                          case RCTLogLevelInfo:
                            tLogLevel = kLevelInfo;
                            break;
                          case RCTLogLevelWarning:
                            tLogLevel = kLevelWarn;
                            break;
                          case RCTLogLevelError:
                            tLogLevel = kLevelError;
                            break;
                          case RCTLogLevelFatal:
                            tLogLevel = kLevelFatal;
                            break;

                          default:
                            tLogLevel = kLevelNone;
                            break;
                        }
                        [LogHelper logWithLevel:tLogLevel moduleName:"RN" fileName:fileName.UTF8String lineNumber:lineNumber.intValue funcName:"" message:message];
                      });

    RCTBridge* bridge = [RCTBridge currentBridge];
    RCTCxxBridge* cxxBridge = (RCTCxxBridge*)bridge;
    if (cxxBridge == nil) {
        return @false;
    }

    using namespace facebook;

    auto jsiRuntime = (jsi::Runtime*) cxxBridge.runtime;
    if (jsiRuntime == nil) {
        return @false;
    }
    auto& runtime = *jsiRuntime;

    ReactNativeXLog::interceptAllReactNativeLog(runtime);
    return @true;
}

RCT_EXPORT_METHOD(appenderFlush: (bool)isSync resolver:(RCTPromiseResolveBlock) resolve rejecter:(RCTPromiseRejectBlock) reject) {
  if (isSync) {
    mars::xlog::appender_flush_sync();
  } else {
    mars::xlog::appender_flush();
  }
  resolve(@YES);
}

@end

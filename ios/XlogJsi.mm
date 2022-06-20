#import "XlogJsi.h"
#import "react-native-xlog-jsi.h"
#import "React/RCTLog.h"
#include "xloggerbase.h"
#include "xlogger.h"
#include "LogHelper.h"
#include "mars/xlog/appender.h"
#import <sys/xattr.h>

@implementation XlogJsi

+(void)applicationWillTerminate {
  mars::xlog::appender_close();
}

RCT_EXPORT_MODULE()
NSNumber *result = @(ReactNativeXLog::interceptAllReactNativeLog());

int interceptAllReactNativeLog() {
  NSString* logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/ahaaa_math/ahaaa_math_log"];
  
  // set do not backup for logpath
  const char* attrName = "com.flickering.mathufo";
  u_int8_t attrValue = 1;
  setxattr([logPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
  
  // init xlog
#if DEBUG
  xlogger_SetLevel((TLogLevel)kLevelDebug);
  mars::xlog::appender_set_console_log(true);
#else
  xlogger_SetLevel((TLogLevel)kLevelInfo);
  appender_set_console_log(false);
#endif
  
  mars::xlog::XLogConfig config;
  config.mode_ = mars::xlog::kAppenderAsync;
  config.logdir_ = [logPath UTF8String];
  config.nameprefix_ = "AhaaaMath";
  config.pub_key_ = "";
  config.compress_mode_ = mars::xlog::kZlib;
  config.compress_level_ = 0;
  config.cachedir_ = "";
  config.cache_days_ = 0;
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
  return 200;
}
int status = interceptAllReactNativeLog();

// Example method for C++
// See the implementation of the example module in the `cpp` folder
RCT_EXPORT_METHOD(multiply:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withReject:(RCTPromiseRejectBlock)reject)
{
    NSNumber *result = @(ReactNativeXLog::interceptAllReactNativeLog());

    resolve(result);
  
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
//                        [LogHelper logWithLevel:tLogLevel moduleName:"RN" fileName:fileName.UTF8String lineNumber:lineNumber.intValue funcName:"" message:message];
                      });
}

@end

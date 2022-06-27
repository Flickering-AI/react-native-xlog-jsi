cmake_minimum_required(VERSION 3.4.1)

set (CMAKE_VERBOSE_MAKEFILE ON)
set (CMAKE_CXX_STANDARD 11)

add_library(cpp
            SHARED
            ../cpp/react-native-xlog-jsi.cpp
            cpp-adapter.cpp
)

file (GLOB XLOG_PATH "${BUILD_DIR}/unzipXlog/jni/${ANDROID_ABI}")
find_library(XLOG_LIB marsxlog PATHS ${XLOG_PATH} NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)

file (GLOB LIBRN_DIR "${BUILD_DIR}/unzipReactNative/jni/${ANDROID_ABI}")
find_library(
        FB_LIB
        fb
        PATHS ${LIBRN_DIR}
        NO_CMAKE_FIND_ROOT_PATH
)
find_library(JSI jsi PATHS ${LIBRN_DIR} NO_CMAKE_FIND_ROOT_PATH)

# Specifies a path to native header files.
include_directories(
            ../cpp
        "../ios/mars.framework/Headers"
        "${NODE_MODULES_DIR}/react-native/ReactAndroid/src/main/jni/first-party/fb/include/"
        "${NODE_MODULES_DIR}/react-native/ReactCommon/jsi"
)

target_link_libraries(cpp ${XLOG_LIB} ${FB_LIB} ${JSI})


cmake_minimum_required(VERSION 3.4.1)

set (CMAKE_VERBOSE_MAKEFILE ON)
set (CMAKE_CXX_STANDARD 11)

add_library(cpp
            SHARED
            ../cpp/react-native-xlog-jsi.cpp
            cpp-adapter.cpp
)
file (GLOB LIBRN_DIR "${BUILD_DIR}/unzipReactNative/jni/${ANDROID_ABI}")
find_library(
        FB_LIB
        fb
        PATHS ${LIBRN_DIR}
        NO_CMAKE_FIND_ROOT_PATH
)
file (GLOB XLOG_PATH "${BUILD_DIR}/unzipXlog/jni/${ANDROID_ABI}")
find_library(XLOG_LIB marsxlog PATHS ${XLOG_PATH} NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH) # ${ANDROID_ABI}

# Specifies a path to native header files.
include_directories(
            ../cpp
        "../cpp/xlogger"
        "${NODE_MODULES_DIR}/react-native/ReactAndroid/src/main/jni/first-party/fb/include/"
)

target_link_libraries(cpp ${FB_LIB} ${XLOG_LIB})


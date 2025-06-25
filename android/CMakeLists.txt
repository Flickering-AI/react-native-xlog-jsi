project(ReactNativeXlog)
cmake_minimum_required(VERSION 3.9.0)

set (PACKAGE_NAME "react-native-xlog")

#add_subdirectory(${NODE_MODULES_DIR}/react-native/ReactAndroid/src/main/jni/first-party/fb) # /CMakeLists.txt

find_package(ReactAndroid REQUIRED CONFIG)
get_target_property(JSI_LIB ReactAndroid::jsi IMPORTED_LOCATION)
get_filename_component(JSI_DIR ${JSI_LIB} DIRECTORY)
file (GLOB LIBRN_DIR "${JSI_DIR}/../../../../../jni/${ANDROID_ABI}")
find_library(
        FB_LIB
        fb
        PATHS ${LIBRN_DIR}
        NO_CMAKE_FIND_ROOT_PATH
)

add_library(reactnativexlog
        SHARED
        ../cpp/react-native-xlog-jsi.cpp
        cpp-adapter.cpp
)

file (GLOB XLOG_PATH "${BUILD_DIR}/unzipXlog/jni/${ANDROID_ABI}")
find_library(XLOG_LIB marsxlog PATHS ${XLOG_PATH} NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)

# Specifies a path to native header files.
include_directories(
        ../cpp
        "../ios/mars.framework/Headers"
        "${NODE_MODULES_DIR}/react-native/ReactAndroid/src/main/jni/first-party/fb/include/"
        "${NODE_MODULES_DIR}/react-native/ReactCommon/jsi"
)

target_link_libraries(reactnativexlog ${XLOG_LIB} ${FB_LIB} ReactAndroid::jsi)


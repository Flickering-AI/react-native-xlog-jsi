import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-xlog-jsi' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

// global func declaration for JSI functions
declare global {
  function xlogAppenderFlush(isSync: boolean): unknown;
}

const XlogJsi = NativeModules.XlogJsi
  ? NativeModules.XlogJsi
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default class Xlog {
  constructor(
    rootDirectory: string = 'xlogs',
    namePrefix: string = 'XLog',
    cacheDays: number = 3,
    isConsoleLogOpen: boolean = !!__DEV__
  ) {
    if (!global.xlogAppenderFlush) {
      XlogJsi.install(rootDirectory, namePrefix, cacheDays, isConsoleLogOpen);
    }
  }

  static async appenderFlush(isSync: boolean = true) {
    return global.xlogAppenderFlush(isSync);
    // return XlogJsi.appenderFlush(isSync);
  }
}

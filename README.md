# react-native-xlog-jsi

It allows you to easily use mars-xlog inside your React Native applications.

[![Node.js Package](https://github.com/Flickering-AI/react-native-xlog-jsi/actions/workflows/npm-publish.yml/badge.svg)](https://github.com/Flickering-AI/react-native-xlog-jsi/actions/workflows/npm-publish.yml)

## Installation

```sh
yarn add react-native-xlog-jsi
```

## Usage

```javascript
import Xlog from 'react-native-xlog-jsi';

// init
const xlog = new Xlog();

// flush before pull xlog file
Xlog.appenderFlush();
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

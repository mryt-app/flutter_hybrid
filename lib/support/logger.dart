enum LogLevel {
  off, // No logs
  error, // Error logs only
  warning, // Error and warning logs
  info, // Error, warning and info logs
  debug, // Error, warning, info and debug logs
  verbose, // Error, warning, info, debug and verbose logs
}

String _logLevelDesc(LogLevel logLevel) {
  switch (logLevel) {
    case LogLevel.error:
      return 'error';
    case LogLevel.warning:
      return 'warning';
    case LogLevel.info:
      return 'info';
    case LogLevel.debug:
      return 'debug';
    case LogLevel.verbose:
      return 'verbose';
    default:
      return '';
  }
}

class Logger {
  static LogLevel logLevel = LogLevel.verbose;

  static void error(String msg) {
    log(msg, LogLevel.error);
  }

  static void warn(String msg) {
    log(msg, LogLevel.warning);
  }

  static void info(String msg) {
    log(msg, LogLevel.info);
  }

  static void debug(String msg) {
    log(msg, LogLevel.debug);
  }

  static void verbose(String msg) {
    log(msg, LogLevel.verbose);
  }

  static void log(String msg, LogLevel logLevel) {
    if (Logger.logLevel == LogLevel.off) {
      return;
    }
    if (logLevel.index <= Logger.logLevel.index) {
      print('FlutterHybrid ${_logLevelDesc(logLevel)}: $msg');
    }
  }
}
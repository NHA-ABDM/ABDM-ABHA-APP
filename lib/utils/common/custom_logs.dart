import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger customLogger(Type? type) {
  // type is class name
  final logger = Logger(
    printer: CustomPrinter(type.toString()),
    filter: CustomFilter(),
    // level: Level.verbose, // to print only specific logs
  );
  return logger;
}

class CustomPrinter extends LogPrinter {
  final String className;

  CustomPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji $className: $message')];
  }
}

class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    event.stackTrace;
    if (kReleaseMode) {
      return false;
    }
    return true;
  }
}

import 'dart:async';

import 'package:computer/computer.dart';

Future<void> run() async {
  await Computer().turnOn(areLogsEnebled: true);
  try {
    var a = await Computer().compute<int, int>(fib, param: null);
    print('Calculated a: $a');
  } catch (error) {
    print(error);
    print('Task a failed');
  }
  var b = await Computer().compute<int, int>(asyncFib, param: 40);
  print('Calculated b: $b');
  var c = await Computer().compute<int, int>(fib, param: 30);
  print('Calculated c: $c');

  await Computer().turnOff();
}

int fib(int n) {
  int number1 = n - 1;
  int number2 = n - 2;

  if (n == 1) {
    return 0;
  } else if (n == 0) {
    return 1;
  } else {
    return (fib(number1) + fib(number2));
  }
}

Future<int> asyncFib(int n) async {
  await Future.delayed(const Duration(seconds: 2));

  int number1 = n - 1;
  int number2 = n - 2;

  if (n == 1) {
    return 0;
  } else if (n == 0) {
    return 1;
  } else {
    return (fib(number1) + fib(number2));
  }
}

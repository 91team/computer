import 'dart:async';

import 'package:computer/computer.dart';

Future<void> main() async {
  final computer = Computer();

  await computer.turnOn(verbose: false);
  try {
    final a = await computer.compute<int, int>(fib, param: null);
    print('Calculated a: $a');
  } catch (error) {
    print(error);
    print('Task a failed');
  }
  final b = await computer.compute<int, int>(asyncFib, param: 40);
  print('Calculated b: $b');
  final c = await computer.compute<int, int>(fib, param: 30);
  print('Calculated c: $c');

  await computer.turnOff();
}

int fib(int n) {
  final number1 = n - 1;
  final number2 = n - 2;

  if (n == 1) {
    return 0;
  } else if (n == 0) {
    return 1;
  } else {
    return fib(number1) + fib(number2);
  }
}

Future<int> asyncFib(int n) async {
  await Future<void>.delayed(const Duration(seconds: 2));

  final number1 = n - 1;
  final number2 = n - 2;

  if (n == 1) {
    return 0;
  } else if (n == 0) {
    return 1;
  } else {
    return fib(number1) + fib(number2);
  }
}

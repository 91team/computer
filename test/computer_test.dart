import 'package:computer/computer.dart';
import 'package:test/test.dart';

void main() {
  test('Turn on computer', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(computer.isRunning, equals(true));

    await computer.turnOff();
  });

  test('Execute function with param', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(await computer.compute(fib, param: 20), equals(4181));

    await computer.turnOff();
  });

  test('Execute function without params', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(await computer.compute(fib20), equals(4181));

    await computer.turnOff();
  });

  test('Turn off computer', () async {
    final computer = Computer();
    await computer.turnOn();
    await computer.turnOff();
    expect(computer.isRunning, equals(false));
  });
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

int fib20() {
  const n = 20;

  const number1 = n - 1;
  const number2 = n - 2;

  if (n == 1) {
    return 0;
  } else if (n == 0) {
    return 1;
  } else {
    return fib(number1) + fib(number2);
  }
}

import 'package:computer/computer.dart';
import 'package:computer/src/errors.dart';
import 'package:test/test.dart';

void main() {
  test('Computer turn on', () async {
    final computer = Computer();
    await computer.turnOn();
    expect(computer.isRunning, equals(true));
    await computer.turnOff();
  });

  test('Computer initially turned off', () async {
    final computer = Computer();
    expect(computer.isRunning, equals(false));
  });

  test('Computer turn off', () async {
    final computer = Computer();
    await computer.turnOn();
    await computer.turnOff();
    expect(computer.isRunning, equals(false));
  });

  test('Computer reload', () async {
    final computer = Computer();
    await computer.turnOn();
    expect(computer.isRunning, equals(true));
    await computer.turnOff();
    expect(computer.isRunning, equals(false));
    await computer.turnOn();
    expect(computer.isRunning, equals(true));
    expect(await computer.compute<int, int>(fib, param: 20), equals(fib(20)));
    await computer.turnOff();
  });

  test('Execute function with param', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(await computer.compute<int, int>(fib, param: 20), equals(fib(20)));

    await computer.turnOff();
  });

  test('Stress test', () async {
    final computer = Computer();
    await computer.turnOn();

    const numOfTasks = 500;

    final result = await Future.wait(
      List<Future<int>>.generate(
        numOfTasks,
        (_) async => await computer.compute(fib, param: 30),
      ),
    );

    final forComparison = List<int>.generate(
      numOfTasks,
      (_) => 832040,
    );

    expect(result, forComparison);

    await computer.turnOff();
  });

  test('Execute function without params', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(await computer.compute<int, int>(fib20), equals(fib20()));

    await computer.turnOff();
  });

  test('Execute static method', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(
      await computer.compute<int, int>(Fibonacci.fib, param: 20),
      equals(Fibonacci.fib(20)),
    );

    await computer.turnOff();
  });

  test('Execute async method', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(
      await computer.compute<int, int>(fibAsync, param: 20),
      equals(await fibAsync(20)),
    );

    await computer.turnOff();
  });

  test('Error method', () async {
    final computer = Computer();
    await computer.turnOn();

    expect(
      () async => await computer.compute<int, int>(errorFib, param: 20),
      throwsA(isA<RemoteExecutionError>()),
    );

    await computer.turnOff();
  });

  test('Computer is a singleton', () async {
    final computer1 = Computer();
    final computer2 = Computer();

    expect(computer1 == computer2, equals(true));
  });
}

int fib(int n) {
  if (n < 2) {
    return n;
  }
  return fib(n - 2) + fib(n - 1);
}

int errorFib(int n) {
  throw Exception('Something went wrong');
}

Future<int> fibAsync(int n) async {
  await Future<void>.delayed(const Duration(milliseconds: 100));

  return fib(n);
}

int fib20() {
  return fib(20);
}

abstract class Fibonacci {
  static int fib(int n) {
    if (n < 2) {
      return n;
    }
    return fib(n - 2) + fib(n - 1);
  }
}

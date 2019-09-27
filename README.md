# Computer

Computer is a lightweight library for concurrent computations, which provides Flutter's compute() like API.

## Features

- Easy to use API
- No overhead for creating & releasing isolates for each task. Workers initialized on start and ready to solve your tasks
- Strictly defined count of workers

## How to use

Computer is a singleton, that provides just 3 methods

### turnOn()

```dart
await Computer().turnOn(
  workersCount: 4, // optional, default 2
  areLogsEnabled: false, // optional, default false
);
```
Before using the `Computer` you need to `turnOn` it. This will create workers and initialize them. Then you may use `compute()` method.

### compute()

```dart
vat answer = await Computer().compute(
  fib,
  param: 45, // optional
);
```
`compute` will execute your function inside one of the workers. Function may be `async`

### turnOff()

```dart
await Computer().turnOff();
```
If you don't need workers anymore, you should `turnOff` the Computer. It will destroy workers.


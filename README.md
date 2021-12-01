# Computer

`Computer` is a lightweight library for concurrent computations, which provides Flutter's [compute](https://api.flutter.dev/flutter/foundation/compute.html) like API.

## Features

- Easy to use API
- No overhead on creating & releasing isolates for each task. Workers initialized on start and ready to solve your tasks
- Strictly defined number of workers

## Note

`Computer.shared()` is a singleton, use `Computer.create()` to create new instances

## How to use

`Computer` provides just 3 methods

### turnOn()

Before using the `Computer` you need to `turnOn` it. This will create workers and initialize them. Then you may use `compute()` method.

```dart
final computer = Computer.create(); //Or Computer.shared()

await computer.turnOn(
  workersCount: 4, // optional, default 2
  verbose: false, // optional, default false
);
```

### compute()

`compute` will execute your function inside one of the workers. Function may be `async`. The callback argument must be a top-level or static method of a class.

```dart
final result = await computer.compute(
  fib,
  param: 45, // optional
);
```

### turnOff()

If you don't need workers anymore, you can `turnOff` the `Computer`. It will destroy workers.

```dart
await computer.turnOff();
```

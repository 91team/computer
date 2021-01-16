# Computer

`Computer` is a lightweight library for concurrent computations, which provides Flutter's [compute](https://api.flutter.dev/flutter/foundation/compute.html) like API.

## Features

- Easy to use API
- No overhead on creating & releasing isolates for each task. Workers initialized on start and ready to solve your tasks
- Strictly defined number of workers

## Update

`Computer` is no longer a singleton. If you still need a singleton solution, you can make it on your own like in example

<!--
TODO:

- Add a singleton example
-->

## How to use

`Computer` provides just 3 methods

### turnOn()

Before using the `Computer` you need to `turnOn` it. This will create workers and initialize them. Then you may use `compute()` method.

```dart
final computer = Computer();

await computer.turnOn(
  workersCount: 4, // optional, default 2
  areLogsEnabled: false, // optional, default false
);
```

### compute()

`compute` will execute your function inside one of the workers. Function may be `async`. The callback argument must be a top-level function, not a closure or an instance or static method of a class.

```dart
var answer = await computer.compute(
  fib,
  param: 45, // optional
);
```

### turnOff()

If you don't need workers anymore, you can `turnOff` the `Computer`. It will destroy workers.

```dart
await computer.turnOff();
```

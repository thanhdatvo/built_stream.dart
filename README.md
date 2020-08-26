# Built Stream for Dart
<!-- [![Build Status](https://travis-ci.org/google/built_value.dart.svg?branch=master)](https://travis-ci.org/google/built_value.dart) -->
## Introduction

Built Stream provides:

- Concrete params and results type for the method
- SingleStream class wraps an asynchronous method
- ComposedStreams class wrap SingleStream objects
- A graceful error handler


<!-- See the [API docs](https://pub.dev/documentation/built_value/latest/built_value/built_value-library.html). -->


## Examples

For an Flutter example see the
[example](https://github.com/vo9312/built_stream.dart/tree/master/example)

### Generating boilerplate for SingleStream and ComposedStreams

SingleStream and ComposedStreams types require a bit of boilerplate in order to connect it to generated
code. Luckily, even this bit of boilerplate can be got automated using code
snippets support in your favourite text editor. For example, in IntelliJ you
can use following live template:

```dart
@SingleStream(UserRepository, '$METHOD$')
class $CAPITALIZED_METHOD$Stream extends _$CAPITALIZED_METHOD$StreamOrigin {
  @override
  String get errorMessage => '';
}
```
```dart
@ComposedStreams(const [])
class $CAPITALIZED_METHOD$Stream extends _$CAPITALIZED_METHOD$StreamOrigin {
  @override
  Stream<StreamState> process(_) async* {
    // your logic code here
  }
}
```

Using this template you would only have to manually enter a name of your data
class name which is something that can't be automated.

## Common Usage

While full, compiled examples are available in
[`example/lib`](https://github.com/google/built_value.dart/tree/master/example/lib),
a common usage example is shown here. This example assumes that you are writing
a client for method that login to the system in AuthRepository:

```dart
class AuthRepository {
  Future<LoginResults> login(LoginParams params) async {
    await Future.delayed(Duration(milliseconds: 1000));
    String token = "1234abc";
    return LoginResults(token, firstLogin: false);
  }
}
```

The corresponding SingleStream for the method login inside class AuthRepository is like this

```dart
import 'package:example/repositories/auth_repository.dart';
import 'package:built_stream/built_stream.dart';
import 'dart:async';
import 'package:customized_streams/customized_streams.dart';

part "login_stream.g.dart";

@SingleStream(AuthRepository, 'login')
@StreamParam(String, 'email')
@StreamParam(String, 'password', optional: true)
@StreamResult(String, 'token')
@StreamResult(bool, 'firstLogin', optional: true)
class LoginStream extends _LoginStreamOrigin {
  @override
  String get errorMessage => 'Cannot login';
}
```
This declaration will render two classes, one for method's params - `LoginParams` and one for method's results - `LoginResults`;
three class for each states of the stream: `LoginStart`, `LoginSuccess` and `LoginError`;
one class that wrap the method: `LoginStream` and one class that handle the life circle of
above stream class: `LoginBloc`


## FAQ

### Should I check in and/or publish in the generated `.g.dart` files?

See the [build_runner](https://pub.dev/packages/build_runner#source-control)
docs. You usually should not check in generated files, but you _do_ need to publish
them.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/vo9312/built_stream.dart/issues
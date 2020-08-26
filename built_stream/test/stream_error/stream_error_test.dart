import 'package:built_stream/src/interface/stream_state.dart';
import 'package:built_stream/src/data_types/error_location.dart';
import 'package:built_stream/src/data_types/stream_error.dart';
import 'package:test/test.dart';

class SomeException extends Error {
  @override
  String toString() {
    return 'Some unexpected error';
  }
}

class Example1 {
  StreamState someMethod1(dynamic params) {
    ErrorLocation errorLocation =
        ErrorLocation(this.runtimeType, 'Cannot execute some method 1');
    try {
      throw SomeException();
    } catch (error) {
      return StreamError.init(errorLocation, error, params);
    }
  }
}

class Example2 {
  StreamState someMethod2() {
    ErrorLocation errorLocation =
        ErrorLocation(this.runtimeType, 'Cannot execute some method 2');
    var example1 = Example1();
    StreamState streamState = example1.someMethod1("someParams");
    if (streamState is StreamError) {
      streamState = StreamError.composeLocation(streamState, errorLocation);
    }
    return streamState;
  }
}

void main() {
  test('Should compose 2 location errors', () {
    var example2 = Example2();
    var streamState = example2.someMethod2();
    expect(streamState, TypeMatcher<StreamError>());
    if (streamState is StreamError) {
      expect(streamState.payload, "someParams");
      expect(streamState.error, TypeMatcher<SomeException>());
      List<ErrorLocation> errorLocations = streamState.locations;
      expect(errorLocations[0].type, Example2);
      expect(errorLocations[1].type, Example1);
      expect(
          streamState.toString(),
          '--- START ERROR INFO ---\n'
          'Error: Some unexpected error\n'
          'Payload: someParams\n'
          'From Example2: Cannot execute some method 2\n'
          'From Example1: Cannot execute some method 1\n'
          '--- END ERROR INFO ---\n');
    }
  });
}

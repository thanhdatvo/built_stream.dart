library stream_types;

import 'package:meta/meta.dart';

/// Interface for generated state classes
///
abstract class StreamState {
  const StreamState();
}

/// Interface for generated BLoC classes
///
abstract class StreamBloc {
  void dispose();
}

/// The value to trigger stream with no params
///
class EmptyParams {
  const EmptyParams();
}

/// Locate where the method that cause the error and a description message
///
class ErrorLocation {
  @visibleForTesting
  final Type type;
  final String _message;

  ErrorLocation(this.type, this._message);

  @override
  String toString() {
    return type.toString() + ": " + _message;
  }
}

/// A helper class that helps to handle error gracefully
///
class StreamError implements StreamState {
  StreamError(this._locations, this._error, this._payload);

  /// Init the [StreamError] from initial [ErrorLocation], [Error], and a dynamic payload
  StreamError.init(ErrorLocation location, this._error, this._payload) {
    this._locations = [location];
  }

  /// Init the [StreamError] from a previous [StreamError], and add new [ErrorLocation] to [StreamError.locations]
  StreamError.composeLocation(StreamError streamError, ErrorLocation location) {
    this
      .._locations = [location, ...streamError.locations]
      .._error = streamError.error
      .._payload = streamError.payload;
  }

  Error _error;
  dynamic _payload;
  List<ErrorLocation> _locations;

  dynamic get payload => _payload;
  Error get error => _error;
  List<ErrorLocation> get locations => _locations;

  @override
  String toString() {
    var result = "--- START ERROR INFO ---\n";
    result += "Error: " + _error.toString() + "\n";
    result += "Payload: " + _payload.toString() + "\n";
    _locations.forEach((location) {
      result += "From " + location.toString() + "\n";
    });
    result += "--- END ERROR INFO ---\n";
    return result;
  }
}

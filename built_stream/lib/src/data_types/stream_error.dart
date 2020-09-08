import 'package:built_stream/src/data_types/error_location.dart';
import 'package:built_stream/src/interface/stream_state.dart';

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

  dynamic _error;
  dynamic _payload;
  List<ErrorLocation> _locations;

  dynamic get payload => _payload;
  dynamic get error => _error;
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

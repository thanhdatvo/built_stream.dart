import 'package:meta/meta.dart';

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

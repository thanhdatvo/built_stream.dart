/// A multi streams handler that cover many stream
///
/// [ComposedStreams.streams] list all of the stream class to generate.
///
/// You can use ComposedStreams like this:
///
/// ```
/// @ComposedStreams(const [
///  LoginStream,
///])
///class StartAppStream extends _StartAppStreamOrigin {
///  @override
///  Stream<StreamState> process(StartAppParams params) async* {
///    ...
///  }
///}
/// ```
///
/// to generate
///
/// ```
/// class StartAppError extends StreamError {
///   StartAppError(StreamError streamError, ErrorLocation location)
///       : super.composeLocation(streamError, location);
/// }
///
/// abstract class _StartAppStreamOrigin {
///   LoginStream _loginStream;
///   Stream<StreamState> process(StartAppParams params);
/// }
/// ```
class ComposedStreams {
  final List<Type> streams;
  const ComposedStreams(this.streams);
}

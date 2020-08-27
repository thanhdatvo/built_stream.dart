library stream_annotations;

/// Declare param to trigger the stream.
/// All of the params [@StreamParam] declaration will become the propety of [${action}Params] class
///
/// Consider we have a two [@StreamParam] annotation declaration for class [LoginStream]
///
/// ```
/// @StreamParam(String, 'username')
/// @StreamParam(String, 'password', optional: true)
/// class LoginStream {...}
/// ```
///
/// will create
/// ```
/// class LoginParams {
///  final String username;
///  final String password;
///  const LoginParams(this.username, {this.password});
///}
/// ```
///
/// However a stream class without any [@StreamParam] annotation will create a [${action}Params] class
/// without any property
///
/// ```
/// class LoginStream {...}
/// ```
/// will create
/// ```
/// class LoginParams {
///  const LoginParams();
///}
/// ```
class StreamParam {
  final Type propertyType;
  final String propertyName;
  final bool optional;
  const StreamParam(this.propertyType, this.propertyName,
      {this.optional = false});
}

/// Declare param to trigger the stream.
/// All of the params [@StreamResult] declaration will become the propety of [${action}Results] class
///
/// Consider we have a two [@StreamResult] annotation declaration for class [LoginStream]
///
/// ```
/// @StreamResult(UserProfile, 'userProfile')
/// @StreamResult(bool, 'isFirstLogin', optional: true)
/// class LoginStream {...}
/// ```
///
/// will create
/// ```
/// class LoginResults {
///  final UserProfile userProfile;
///  final bool isFirstLogin;
///  const LoginResults(this.isFirstLogin, {this.isFirstLogin});
///}
/// ```
///
/// However a stream class without any [@StreamResult] annotation will create a [${action}Results] class
/// without any property
///
/// ```
/// class LoginStream {...}
/// ```
/// will create
/// ```
/// class LoginResults {
///  const LoginResults();
///}
/// ```
class StreamResult {
  final Type propertyType;
  final String propertyName;
  final bool optional;
  const StreamResult(this.propertyType, this.propertyName,
      {this.optional = false});
}

/// A single stream hanlder that cover one method
///
/// [SingleStream.executor] is the class that has the method.
/// [SingleStream.method] is the method that need to be covered by the stream
///
/// You can use SingleStream like this:
///
/// ```
/// @SingleStream(LoginRepository, 'readMultiple')
/// class LoginStream extends _LoginStreamOrigin{
///   @override
///   String get errorMessage => 'Cannot login';
/// }
/// ```
///
/// to generate
///
/// ```
/// class LoginError extends StreamError {
///  LoginError(ErrorLocation location, Error error, payload)
///      : super.init(location, error, payload);
///}
///
/// abstract class _LoginStreamOrigin {
///  String get errorMessage;
///  LoginRepository loginRepository = LoginRepository();
///  Stream<StreamState> process(LoginParams params) async* {
///    try {
///      yield const LoginStart();
///      LoginResults results = await loginRepository.readMultiple(params);
///      yield LoginSucceed(results);
///    } catch (error) {
///      ErrorLocation location = ErrorLocation(this.runtimeType, errorMessage);
///      yield LoginError(location, error, params);
///    }
///  }
///}
/// ```
class SingleStream {
  final Type executor;
  final String method;
  const SingleStream(this.executor, this.method);
}

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

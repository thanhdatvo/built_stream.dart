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

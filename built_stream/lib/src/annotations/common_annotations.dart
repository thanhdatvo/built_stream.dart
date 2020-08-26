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

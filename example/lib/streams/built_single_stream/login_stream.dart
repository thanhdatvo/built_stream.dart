import 'package:example/repositories/auth_repository.dart';

import 'package:built_stream/stream_annotations.dart';
import 'package:built_stream/stream_types.dart';

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

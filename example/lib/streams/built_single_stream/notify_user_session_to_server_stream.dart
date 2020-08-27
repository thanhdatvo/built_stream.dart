import 'package:built_stream/stream_annotations.dart';
import 'package:built_stream/stream_types.dart';
import 'dart:async';
import 'package:customized_streams/customized_streams.dart';
import 'package:example/repositories/user_repository.dart';

part "notify_user_session_to_server_stream.g.dart";

@SingleStream(UserRepository, 'notifyUserSessionToServer')
@StreamParam(String, 'token')
class NotifyUserSessionToServerStream
    extends _NotifyUserSessionToServerStreamOrigin {
  @override
  String get errorMessage => 'Cannot notify user session to server';
}

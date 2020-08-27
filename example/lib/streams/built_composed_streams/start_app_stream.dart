import 'dart:async';
import 'package:example/streams/built_single_stream/notify_user_session_to_server_stream.dart';
import 'package:rxdart/rxdart.dart';

import 'package:built_stream/stream_annotations.dart';
import 'package:built_stream/stream_types.dart';

import 'package:example/streams/built_single_stream/load_user_email_from_sqlite_stream.dart';
import 'package:example/streams/built_single_stream/load_user_language_from_server_stream.dart';
import 'package:example/streams/built_single_stream/load_user_profile_from_server_stream.dart';
import 'package:example/streams/built_single_stream/login_stream.dart';
import 'package:customized_streams/customized_streams.dart';

part "start_app_stream.g.dart";

@ComposedStreams(const [
  LoginStream,
  LoadUserEmailFromSQLiteStream,
  LoadUserLanguageFromServerStream,
  LoadUserProfileFromServerStream,
  NotifyUserSessionToServerStream
])
@StreamResult(String, 'token')
class StartAppStream extends _StartAppStreamOrigin {
  @override
  Stream<StreamState> process(_) async* {
    ErrorLocation errorLocation =
        ErrorLocation(this.runtimeType, "Could not start app");

    yield const StartAppStart();
    String email;
    await for (StreamState state
        in _loadUserEmailFromSQLiteStream.process(const EmptyParams())) {
      if (state is LoadUserEmailFromSQLiteError) {
        yield StartAppError(state, errorLocation);
        return;
      }
      if (state is LoadUserEmailFromSQLiteSucceed) {
        email = state.results.email;
      }
      yield state;
    }

    String token;
    LoginParams loginParams = LoginParams(email, password: "password");
    await for (StreamState state in _loginStream.process(loginParams)) {
      if (state is LoginError) {
        yield StartAppError(state, errorLocation);
        return;
      }
      if (state is LoginSucceed) {
        token = state.results.token;
      }
      yield state;
    }

    Stream combinedStream = Rx.merge([
      _loadUserProfileFromServerStream
          .process(LoadUserProfileFromServerParams(token)),
      _loadUserLanguageFromServerStream
          .process(LoadUserLanguageFromServerParams(token)),
      _notifyUserSessionToServerStream
          .process(NotifyUserSessionToServerParams(token)),
    ]);
    
    await for (StreamState state in combinedStream) {
      if (state is StateError) {
        yield StartAppError(state, errorLocation);
        return;
      }
      yield state;
    }

    yield StartAppSucceed(StartAppResults(token));
  }
}

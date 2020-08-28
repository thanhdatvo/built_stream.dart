import 'package:built_stream/stream_annotations.dart';
import 'package:built_stream/stream_types.dart';
import 'dart:async';
import 'package:customized_streams/customized_streams.dart';
import 'package:example/repositories/user_repository.dart';

part "load_user_language_from_server_stream.g.dart";

@SingleStream(UserRepository, 'loadUserLanguageFromServer')
@StreamParam('String', 'token')
@StreamResult('String', 'language')
class LoadUserLanguageFromServerStream
    extends _LoadUserLanguageFromServerStreamOrigin {
  @override
  String get errorMessage => 'Cannot load user language from server';
}

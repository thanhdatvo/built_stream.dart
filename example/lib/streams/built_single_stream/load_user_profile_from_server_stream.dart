import 'package:example/modal/user_profile.dart';
import 'package:built_stream/stream_annotations.dart';
import 'package:built_stream/stream_types.dart';
import 'dart:async';
import 'package:customized_streams/customized_streams.dart';
import 'package:example/repositories/user_repository.dart';

part "load_user_profile_from_server_stream.g.dart";

@SingleStream(UserRepository, 'loadUserProfileFromServer')
@StreamParam('String', 'token')
@StreamResult('UserProfile', 'userProfile')
class LoadUserProfileFromServerStream extends _LoadUserProfileFromServerStreamOrigin {
  @override
  String get errorMessage => 'Cannot load user profile from server';
}

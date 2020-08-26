import 'package:built_stream/built_stream.dart';
import 'dart:async';
import 'package:customized_streams/customized_streams.dart';
import 'package:example/repositories/user_repository.dart';

part "load_user_email_from_sqlite_stream.g.dart";

@SingleStream(UserRepository, 'loadUserEmailFromSQLite')
@StreamResult(String, 'email')
class LoadUserEmailFromSQLiteStream extends _LoadUserEmailFromSQLiteStreamOrigin {
  @override
  String get errorMessage => 'Cannot load user\'s email from SQLite';
}

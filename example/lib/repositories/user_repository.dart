import 'dart:async';
import 'package:example/modal/user_profile.dart';
import 'package:example/streams/built_single_stream/load_user_email_from_sqlite_stream.dart';
import 'package:example/streams/built_single_stream/load_user_language_from_server_stream.dart';
import 'package:example/streams/built_single_stream/load_user_profile_from_server_stream.dart';
import 'package:example/streams/built_single_stream/notify_user_session_to_server_stream.dart';

class UserRepository {
  Future<LoadUserEmailFromSQLiteResults> loadUserEmailFromSQLite() async {
    await Future.delayed(Duration(milliseconds: 1000));
    String email = 'flutter@google.com';
    return LoadUserEmailFromSQLiteResults(email);
  }

  Future<LoadUserLanguageFromServerResults> loadUserLanguageFromServer(
      LoadUserLanguageFromServerParams params) async {
    await Future.delayed(Duration(milliseconds: 1000));
    String language = 'en';
    return LoadUserLanguageFromServerResults(language);
  }

  Future<LoadUserProfileFromServerResults> loadUserProfileFromServer(
      LoadUserProfileFromServerParams params) async {
    await Future.delayed(Duration(milliseconds: 1000));
    var userProfile = UserProfile("Flutter",
        "https://cdn.iconscout.com/icon/free/png-256/flutter-2038877-1720090.png");
    return LoadUserProfileFromServerResults(userProfile);
  }

  Future notifyUserSessionToServer(
      NotifyUserSessionToServerParams params) async {
    await Future.delayed(Duration(milliseconds: 1000));
  }
}

import 'dart:async';
import 'package:example/streams/built_single_stream/login_stream.dart';

class AuthRepository {
  Future<LoginResults> login(LoginParams params) async {
    await Future.delayed(Duration(milliseconds: 1000));
    String token = "1234abc";
    return LoginResults(token, firstLogin: false);
  }
}

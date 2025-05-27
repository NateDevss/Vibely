import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class SpotifyAuth {
  static const String clientId = 'b09663febe374bfd97c7eee448408333';
  static const String clientSecret = 'a7f761db55c9490c8bbcbd838415fdc3';
  static const String redirectUri = 'http://127.0.0.1:8080/callback';
  static const List<String> scopes = [
    'user-read-recently-played',
    'user-top-read',
    'user-read-playback-position',
    'user-library-read',
  ];

  static Future<String?> authenticateWithSpotify() async {
    final authUrl =
        'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=${scopes.join('%20')}';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'http',
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) return 'Authorization failed.';

      final tokenResponse = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      final tokenJson = json.decode(tokenResponse.body);
      return 'Logged in! Token: ${tokenJson['access_token']}';
    } catch (e) {
      return 'Login error: $e';
    }
  }
}

import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
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

    final url = Uri.parse(authUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      return 'Could not launch Spotify login';
    }

    // Simulate waiting for redirect and extracting the code manually
    // In production, use a local server or app deep linking to capture the redirect
    return 'Redirect handled outside of app. Implement deep linking to complete login.';
  }

  static Future<String?> exchangeCodeForToken(String code) async {
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
  }
}

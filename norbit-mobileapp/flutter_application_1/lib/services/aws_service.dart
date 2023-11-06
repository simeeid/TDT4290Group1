import 'package:amplify_core/amplify_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwsService {
  final String token;
  final String username;
  final String deviceId;

  AwsService(this.token, this.username, this.deviceId);

  Future<http.Response> getCreds() async {
    const modelVersion = "model_002";

    final url = Uri.parse(
        'https://9wixxl72v8.execute-api.eu-north-1.amazonaws.com/beta/deviceManagement/$deviceId');

    final headers = <String, String>{
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(<String, String>{
      'identityId': username,
      'modelVersion': modelVersion,
      'deviceName': deviceId,
    });

    final response = await http.post(url, headers: headers, body: body);
    final responseBody = response.body;
    safePrint('This is response: $responseBody');
    return response;
  }
}

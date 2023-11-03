import 'package:http/http.dart' as http;
import 'dart:convert';

class AwsService {
  final String token;

  AwsService(this.token);

  Future<http.Response> getCreds() async {
    const username = "antonhs";
    const modelVersion = "model_002";
    const deviceName = "device_137";
    const deviceId = 'device_137';

    final url = Uri.parse(
        'https://9wixxl72v8.execute-api.eu-north-1.amazonaws.com/beta/deviceManagement/$deviceId');

    final headers = <String, String>{
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(<String, String>{
      'identityId': username,
      'modelVersion': modelVersion,
      'deviceName': deviceName,
    });

    final response = await http.post(url, headers: headers, body: body);
    return response;
  }
}

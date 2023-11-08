import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/device_name_bloc.dart';
import '../blocs/connectivity/token_bloc.dart';
import '../blocs/connectivity/username_bloc.dart';
import '../screens/home_screen.dart';
import '../services/login_service.dart';
import '../services/mqtt_service.dart';
import 'device_popup.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final logInService = Provider.of<LogInService>(context, listen: false);
    final mqttService = Provider.of<MqttService>(context, listen: false);
    return ElevatedButton(
      onPressed: () async {
        Map<String, dynamic> loginResult = await logInService.signInWithWebUI();
        bool isSignedIn = loginResult['isSignedIn'];

        if (isSignedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          final deviceNickname = DeviceNickname(
              deviceNameBloc:
              Provider.of<DeviceNameBloc>(context, listen: false));
          if (await deviceNickname.getNickname() == false) {
            _showDevicePopup(context);
          }
        } else {
          safePrint("Something went wrong with the login");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(250, 50),
      ),
      child: const Text(
        'Sign in with AWS',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
  void _showDevicePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DevicePopupWrapper(
          usernameBloc: Provider.of<UsernameBloc>(context),
          tokenBloc: Provider.of<TokenBloc>(context),
          deviceNameBloc: Provider.of<DeviceNameBloc>(context),
        );
      },
    );
  }
}

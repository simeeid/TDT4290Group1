import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/device_name_bloc.dart';
import '../blocs/token_bloc.dart';
import '../blocs/username_bloc.dart';
import '../screens/home_screen.dart';
import '../services/login_service.dart';
import 'register_device_popup.dart';

/*
This is the sign in button displayed on the sign in screen.
If sign in is successfull, it redirects the user to the home screen.
If the device has not been registered before, it displays the popup for registering a device.
 */

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final logInService = Provider.of<LogInService>(context, listen: false);
    return ElevatedButton(
      onPressed: () async {
        Map<String, dynamic> loginResult = await logInService.signInWithWebUI();
        bool isSignedIn = loginResult['isSignedIn'];

        if (isSignedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          final deviceNickname = DeviceName(
              deviceNameBloc:
                  Provider.of<DeviceNameBloc>(context, listen: false));
          if (await deviceNickname.getDeviceName() == false) {
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
        return RegisterDevicePopupWrapper(
          usernameBloc: Provider.of<UsernameBloc>(context),
          tokenBloc: Provider.of<TokenBloc>(context),
          deviceNameBloc: Provider.of<DeviceNameBloc>(context),
        );
      },
    );
  }
}

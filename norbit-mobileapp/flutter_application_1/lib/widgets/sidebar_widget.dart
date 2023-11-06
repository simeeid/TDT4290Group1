import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/connectivity/username_bloc.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/token_bloc.dart';
import '../services/login_service.dart';
import 'device_popup.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final logInService = Provider.of<LogInService>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Register Device'),
            onTap: () {
              _showDevicePopup(context);
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              logInService.signOutWithWebUI();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDevicePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DevicePopupWrapper(
            usernameBloc: Provider.of<UsernameBloc>(context),
            tokenBloc: Provider.of<TokenBloc>(context));
      },
    );
  }
}

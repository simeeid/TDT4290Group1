import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/device_name_bloc.dart';
import 'package:flutter_application_1/blocs/username_bloc.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:provider/provider.dart';
import '../blocs/token_bloc.dart';
import '../services/login_service.dart';
import 'device_data.dart';
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
            title: const Text('Device Data'),
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
        return DeviceData(
          deviceNameBloc: Provider.of<DeviceNameBloc>(context),
        );
      },
    );
  }
}

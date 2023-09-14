import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isConnected = false;
  bool isRunning = false;

  void toggleConnect() {
    setState(() {
      isConnected = !isConnected;
      isRunning = false;
    });
  }

  void toggleStartStop() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTT App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                // MQTT Broker input field
                // Add your logic here
                ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isConnected ? null : toggleConnect,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('Connect'),
                ),
                ElevatedButton(
                  onPressed: isConnected ? toggleConnect : null,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Disconnect'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            FloatingActionButton(
              onPressed: isConnected ? toggleStartStop : null,
              backgroundColor: isRunning ? Colors.red : Colors.green,
              child: Icon(isRunning ? Icons.stop : Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}

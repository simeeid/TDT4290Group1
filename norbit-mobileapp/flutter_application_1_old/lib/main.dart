import 'dart:async';

import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(NoiseMeterApp());

class NoiseMeterApp extends StatefulWidget {
  @override
  _NoiseMeterAppState createState() => _NoiseMeterAppState();
}

class _NoiseMeterAppState extends State<NoiseMeterApp> {
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;
  double _maxNoiseLevel = double.negativeInfinity;

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      _latestReading = noiseReading;
      if (noiseReading.maxDecibel > _maxNoiseLevel) {
        _maxNoiseLevel = noiseReading.maxDecibel;
      }
    });
  }

  void onError(Object error) {
    print(error);
    stop();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  Future<void> start() async {
    noiseMeter ??= NoiseMeter();

    if (!(await checkPermission())) await requestPermission();

    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);
  }

  void stop() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                    margin: EdgeInsets.all(25),
                    child: Column(children: [
                      Container(
                        child: Text(_isRecording ? "Mic: ON" : "Mic: OFF",
                            style: TextStyle(fontSize: 25, color: Colors.blue)),
                        margin: EdgeInsets.only(top: 20),
                      ),
                      Container(
                        child: Text(
                          'Noise: ${_latestReading?.meanDecibel.toStringAsFixed(2)} dB',
                        ),
                        margin: EdgeInsets.only(top: 20),
                      ),
                      Container(
                        child: Text(
                          'Max: ${_maxNoiseLevel.toStringAsFixed(2)} dB',
                        ),
                      )
                    ])),
              ])),
          floatingActionButton: FloatingActionButton(
            backgroundColor: _isRecording ? Colors.red : Colors.green,
            child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
            onPressed: _isRecording ? stop : start,
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isVoiceActivatedSOS = false;
  bool _isShakeAlert = false;


  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  Future<void> _loadSwitchStates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVoiceActivatedSOS = prefs.getBool('voiceActivatedSOS') ?? false;
      isvoice = _isVoiceActivatedSOS;
      _isShakeAlert = prefs.getBool('shakeAlert') ?? false;
      isShake = _isShakeAlert;

    });
  }

  Future<void> _saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
      if (key == 'shakeAlert') {
      setState(() {
      isShake = value; // Update the global isShakeAlert variable
    }); // Update the global isShake variable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                  child: Text(
                    'Voice activated SOS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(122.7, 30.0, 0.0, 0.0),
                  child: Transform.scale(
                    scale: 1.1,
                    child: Switch(
                      value: _isVoiceActivatedSOS,
                      onChanged: (value) {
                        setState(() {
                          _isVoiceActivatedSOS = value;
                        });
                        _saveSwitchState('voiceActivatedSOS', value);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
                  child: Text(
                    'Shake alert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(201.7, 10.0, 0.0, 0.0),
                  child: Transform.scale(
                    scale: 1.1,
                    child: Switch(
                      value: _isShakeAlert,
                      onChanged: (value) {
                        setState(() {
                          _isShakeAlert = value;
                        });
                        _saveSwitchState('shakeAlert', value);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

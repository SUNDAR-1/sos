import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_sms/background_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:women_safety_app/pages/appbar.dart';
import 'globals.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   static const double shakeThreshold = 9.0; // Adjust as needed
   final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool isSendingSOS = false;
  Timer? sosTimer;
  bool isSOSActive = false;
  


  StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    if(isShake){
    // Start listening for gyroscope events
    gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      // Calculate the magnitude of gyroscope readings
      final double gyroscopeMagnitude = event.x.abs() + event.y.abs() + event.z.abs();
  
      // Check if the magnitude exceeds the shake threshold
      if (gyroscopeMagnitude > shakeThreshold) {
        // Device is shaken, trigger SOS action
        if (!isSOSActive) {
          toggleSOS();
        } else {
          stopSOS();
        }
        vibrateIfHasVibrator();
      }
    });
  }
    
  }
    Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              // Handle the recognized speech result
              if (result.recognizedWords.toLowerCase() == 'help') {
                // Detected the phrase "help," trigger SOS action
                toggleSOS();
                vibrateIfHasVibrator();
              }
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }
  @override
  void dispose() {
    gyroscopeSubscription?.cancel();
    _speech.stop();
    super.dispose();
  }
  void toggleSOS() {
    setState(() {
      isSendingSOS = true;
      isSOSActive = true;
      sendSOS(); // Send the first message immediately

      // Start sending subsequent SOS messages with a one-minute interval
      sosTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (isSendingSOS) {
          sendSOS();
        }
      });
    });
  }

  void stopSOS() {
    setState(() {
      isSendingSOS = false;
      isSOSActive = false;
      sosTimer?.cancel();
    });
  }

  Future<void> vibrateIfHasVibrator() async {
    final hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator == true) {
      Vibration.vibrate(duration: 500);
    }
  }

  Future<void> sendSOS() async {
    final LocationPermission locationPermissionStatus = await Geolocator.requestPermission();
    final smsPermissionStatus = await Permission.sms.status;

    if (globalContacts.isNotEmpty) {
      if (locationPermissionStatus == LocationPermission.whileInUse ||
          locationPermissionStatus == LocationPermission.always) {
        // Location permission is granted
        if (smsPermissionStatus.isGranted) {
          try {
            final Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );

            final String googleMapsUrl =
                "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
            final String message = "Help! My location: $googleMapsUrl";

            for (final contact in globalContacts) {
              // Send a message to each contact in globalContacts
              final SmsStatus result = await BackgroundSms.sendMessage(
                phoneNumber: contact.phone,
                message: message,
                simSlot: 1,
              );

              if (result == SmsStatus.sent) {
                // Handle success for each contact
                print("SMS sent successfully to ${contact.name}");
              } else {
                // Handle failure for each contact
                print("Failed to send SMS to ${contact.name}");
              }
            }

            Fluttertoast.showToast(
              msg: "SOS alert clicked",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            );
          } catch (e) {
            print("Error retrieving location: $e");
          }
        } else {
          // Handle the case where SMS permission is not granted.
          _showPermissionRequiredDialog("SMS permission is required for this feature.");
        }
      } else {
        // Handle the case where location permission is not granted.
        _showPermissionRequiredDialog("Location permission is required for this feature.");
      }
    } else {
      const snackBar = SnackBar(
        content: Text('Add at least one contact'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _showPermissionRequiredDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permissions Required"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "To use this feature, please grant the necessary permissions in the app settings:",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                _openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Open the app settings using app_settings package
  void _openAppSettings() {
    AppSettings.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFB3CEE5),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isSOSActive) {
                stopSOS();
              } else {
                toggleSOS();
              }
            },
            child: Center(
              child: isSOSActive
                  ? Image.asset(
                      'assets/icons/stop_sos.png',
                      width: 200,
                      height: 200,
                    )
                  : Image.asset(
                      'assets/icons/sos_button.png',
                      width: 200,
                      height: 200,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

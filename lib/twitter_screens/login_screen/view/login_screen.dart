import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitter_clone/twitter_screens/home/view/home_main_screen.dart';
import 'package:twitter_clone/twitter_screens/room/view/room_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum WidgetType { mobile, otp }

class _LoginScreenState extends State<LoginScreen> {
  bool isOtpSent = false;
  WidgetType widgetType = WidgetType.mobile;

  TextEditingController mobileNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? verificationIdData;

  Timer? timer;
  int timerLeft = 60;

  @override
  void initState() {
    super.initState();
  }

// Firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login Screen",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: mobileNoController,
                  maxLength: 10,
                  onChanged: (v) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      labelText: "Enter your Mobile Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widgetType == WidgetType.otp)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                        labelText: "Enter your OTP",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                  ),
                ),
              if (widgetType == WidgetType.otp) Text('$timerLeft'),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () {
                    switch (widgetType) {
                      case WidgetType.mobile:
                        sendOtp();
                        break;
                      case WidgetType.otp:
                        verifyOtp();
                        break;
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black),
                    child: Center(
                        child: Text(
                      widgetType == WidgetType.mobile
                          ? 'Send Otp'
                          : 'Verify Otp',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> sendOtp() async {
    try {
      await firebaseAuth
          .verifyPhoneNumber(
              phoneNumber: '+91 ${mobileNoController.text}',
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException error) {
                print(error.message);
                SnackBar snackBar = SnackBar(
                  content: Text(
                    'Error Found ${error.message.toString()}',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  snackBar,
                );
              },
              codeSent: (String verificationId, int? resendToken) {
                setState(() {
                  widgetType = WidgetType.otp;
                  verificationIdData = verificationId;
                  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    setState(() {
                      if (timer.tick <= 60) {
                        timerLeft--;
                      } else {
                        timer.cancel();
                      }
                    });
                  });
                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
              timeout: const Duration(seconds: 60))
          .onError((error, stackTrace) {
        print(error);
        SnackBar snackBar = SnackBar(
          content: Text(
            'Error Found $error',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar,
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      SnackBar snackBar = SnackBar(
        content: Text(
          'Error Found $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    } catch (e) {
      SnackBar snackBar = SnackBar(
        content: Text(
          'Error Found $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    }
  }

  Future<void> verifyOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIdData!, smsCode: otpController.text);
      Future<UserCredential> userCredential =
          firebaseAuth.signInWithCredential(credential);
      userCredential.onError((error, stackTrace) async {
        SnackBar snackBar = SnackBar(
          content: Text(
            'Error Found ${error.toString().split(']').last}',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar,
        );
        return userCredential;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RoomMainScreen()),
          (route) => false);
    } on FirebaseAuthException catch (error) {
      SnackBar snackBar = SnackBar(
        content: Text(
          'Error Found ${error.toString().split(']').last}',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    } catch (error) {
      SnackBar snackBar = SnackBar(
        content: Text(
          'Error Found ${error.toString().split(']').last}',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}

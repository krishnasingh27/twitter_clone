import 'package:flutter/material.dart';

class NoificationMainScreen extends StatefulWidget {
  const NoificationMainScreen({super.key});

  @override
  State<NoificationMainScreen> createState() => _NoificationMainScreenState();
}

class _NoificationMainScreenState extends State<NoificationMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Notification Main Screen"),
    );
  }
}

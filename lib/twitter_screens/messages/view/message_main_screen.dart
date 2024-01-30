import 'package:flutter/material.dart';

class MessageMainScreen extends StatefulWidget {
  const MessageMainScreen({super.key});

  @override
  State<MessageMainScreen> createState() => _MessageMainScreenState();
}

class _MessageMainScreenState extends State<MessageMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Message Main Screen"),
    );
  }
}

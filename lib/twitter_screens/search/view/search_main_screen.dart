import 'package:flutter/material.dart';

class SearchMainScreen extends StatefulWidget {
  const SearchMainScreen({super.key});

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Search Main Screen"),
    );
  }
}

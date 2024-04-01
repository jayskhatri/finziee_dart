import 'package:flutter/material.dart';

class SettigsPage extends StatefulWidget {
  const SettigsPage({super.key});

  @override
  State<SettigsPage> createState() => _SettigsPageState();
}

class _SettigsPageState extends State<SettigsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const Center(child: Text('Settings mode')),
    );
  }
}
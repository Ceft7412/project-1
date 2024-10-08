import 'package:flutter/material.dart';
import 'package:project/accountpage.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AccountPage()));
          },
          child: const Text('Go to Account Page'),
        ),
      ),
    );
  }
}

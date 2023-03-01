import 'package:flutter/material.dart';

class MechanicHome extends StatelessWidget {
  const MechanicHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff24688e)),
        toolbarHeight: 75,
        leadingWidth: 75,
      ),
      body: const Text(
        'sss',
        style: TextStyle(fontSize: 56),
      ),
    );
  }
}

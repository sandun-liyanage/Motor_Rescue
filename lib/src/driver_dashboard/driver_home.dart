import 'package:flutter/material.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
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
      body: Material(
        //elevation: 20,
        //borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                  image: AssetImage('assets/images/mechanic.png')),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),

                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: const [
                Image(
                  image: AssetImage('assets/images/mechanic.png'),
                  height: 50,
                ),
                Text(
                  'Having ussues with your vehicle?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

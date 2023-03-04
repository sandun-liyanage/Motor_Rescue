// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Text(
                    'Hello... Welcome back Sandun',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              jobRequestWidget(),
              SizedBox(height: 20),
              //currentJobWidget(),
            ],
          ),
        ),
      ),
    );
  }

//---------------------------------------------------------------------------

  Widget jobRequestWidget() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.7),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 25),
          Text(
            'New Job Request - 5KM away...',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 250,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: AssetImage('assets/images/jobRequest.jpg'),
                  fit: BoxFit.cover),
            ),
            //child: Image(image: AssetImage('assets/images/vBreakdown.png')),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.chat, size: 60),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Flexible(
                            child: Text(
                          'Chat With Driver',
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.done,
                        size: 60,
                        color: Colors.green,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Flexible(
                          child: Text(
                            'Accept the Job',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.close,
                        size: 60,
                        color: Colors.red,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Flexible(
                          child: Text(
                            'Decline the Job',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------------

  Widget currentJobWidget() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.7),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            'Current Job',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 250,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: AssetImage('assets/images/jobRequest.jpg'),
                  fit: BoxFit.cover),
            ),
            //child: Image(image: AssetImage('assets/images/vBreakdown.png')),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.chat, size: 60),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Flexible(
                            child: Text(
                          'Chat With Driver',
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 60,
                        color: Colors.blue,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Flexible(
                          child: Text(
                            'Driver Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(width: 3, color: Colors.blue),
                    elevation: 15,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check,
                        size: 60,
                        color: Colors.red,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Flexible(
                          child: Text(
                            'Complete the Job',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

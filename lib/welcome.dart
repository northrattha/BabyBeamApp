import 'package:flutter/material.dart';

class DoUhaveBaby extends StatefulWidget {
  @override
  _DoUhaveBabyState createState() => _DoUhaveBabyState();
}

class _DoUhaveBabyState extends State<DoUhaveBaby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('คุณมีลูกยัง'),
      ),
    );
  }
}

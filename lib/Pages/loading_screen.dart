import 'package:flutter/material.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (progress < 1.0) {
          progress += 0.05;
        } else {
          timer.cancel();
          Navigator.pushReplacementNamed(context, '/greeting');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/images/logo.png'),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                color: Colors.black,
                minHeight: 8,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
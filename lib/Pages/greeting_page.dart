import 'package:flutter/material.dart';

class GreetingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("lib/images/logo.png", height: 300),
            SizedBox(height: 20),
            Text(
              "Tasbih Counter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enhance your spiritual practice with intuitive tracking and insightful analytics",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 20),
            _buildFeatureCard(context, Icons.touch_app, "Simple tap gestures for counting"),
            _buildFeatureCard(context, Icons.bar_chart, "Track your daily progress"),
            _buildFeatureCard(context, Icons.notifications, "Set reminders for your practice"),
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Get Started",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String text) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(text,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
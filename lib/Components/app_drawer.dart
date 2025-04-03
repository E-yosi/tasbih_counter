import 'package:flutter/material.dart';
import 'package:tasbih_counter/Pages/History.dart';
import 'package:tasbih_counter/Pages/Statistics.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.bar_chart,
                    text: "Statistics",
                    onTap: () => _navigateTo(context, StatisticsScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.history,
                    text: "History",
                    onTap: () => _navigateTo(context, HistoryScreen()),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.share,
                    text: "Share",
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.star,
                    text: "Review",
                    onTap: () {},
                  ),
                  Divider(color: Colors.white54, thickness: 1, height: 24),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Settings",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.language,
                    text: "Language",
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: Text("Notifications", style: TextStyle(color: Colors.white)),
                    secondary: Icon(Icons.notifications, color: Colors.white),
                    value: false, // Default ON
                    activeColor: Colors.blue,
                    onChanged: (bool value) {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 26),
      title: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
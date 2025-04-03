import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BottomNavBar extends StatelessWidget {
  final VoidCallback onObjectivePressed;

  const BottomNavBar({Key? key, required this.onObjectivePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.list),
              color: Colors.white,
              onPressed: onObjectivePressed,
            ),
            IconButton(
              icon: Icon(Icons.palette),
              color: Colors.white,
              onPressed: () {
                final settingsBox = Hive.box('settingsBox');
                int current = settingsBox.get('themeIndex', defaultValue: 0);
                int next = (current + 1) % 7;
                settingsBox.put('themeIndex', next);
              },
            ),
          ],
        ),
      ),
    );
  }
}
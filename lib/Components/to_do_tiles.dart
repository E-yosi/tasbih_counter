import 'package:flutter/material.dart';

class ToDoTiles extends StatelessWidget {
  final String taskName;
  final int taskNumber;
  final int taskLimit;
  final bool isSelected;

  ToDoTiles({
    required this.taskName,
    required this.taskNumber,
    required this.taskLimit,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[400] : Colors.lightBlue,
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              taskName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text("$taskNumber / $taskLimit"),
          ],
        ),
      ),
    );
  }
}
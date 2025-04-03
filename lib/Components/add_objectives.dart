import 'package:flutter/material.dart';
import 'package:tasbih_counter/Components/preset_dhikr.dart';

class AddObjectives extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController initValueController = TextEditingController(text: "0");
  final TextEditingController goalController = TextEditingController(text: "100");
  final TextEditingController descriptionController = TextEditingController();

  Widget _buildPresetButton(BuildContext context, String title, List<Map<String, dynamic>> presets) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        final firstPhrase = presets[0]["phrases"][0];
        titleController.text = firstPhrase["text"];
        goalController.text = firstPhrase["count"].toString();
        descriptionController.text = firstPhrase["description"];
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Add Objective")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quick Presets:", style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            )),
            SizedBox(height: 10),
            Row(
              children: [
                _buildPresetButton(context, "Morning", PresetDhikr.morningAdhkar),
                SizedBox(width: 10),
                _buildPresetButton(context, "Evening", PresetDhikr.eveningAdhkar),
              ],
            ),
            SizedBox(height: 20),
            Text("Title"),
            TextField(controller: titleController),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Initial Value"),
                    TextField(
                      controller: initValueController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                )),
                SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Goal"),
                    TextField(
                      controller: goalController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(height: 16),
            Text("Description (Optional)"),
            TextField(controller: descriptionController),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      Navigator.pop(context, [
                        titleController.text,
                        int.tryParse(initValueController.text) ?? 0,
                        int.tryParse(goalController.text) ?? 100,
                        descriptionController.text,
                      ]);
                    }
                  },
                  child: Text("Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasbih_counter/Components/add_objectives.dart';

class NewObjectiveScreen extends StatefulWidget {
  @override
  _NewObjectiveScreenState createState() => _NewObjectiveScreenState();
}

class _NewObjectiveScreenState extends State<NewObjectiveScreen> {
  final _objectivesBox = Hive.box('objectivesBox');
  List toDOList = [];

  @override
  void initState() {
    super.initState();
    _loadObjectives();
  }

  void _loadObjectives() {
    setState(() {
      toDOList = _objectivesBox.get('objectives', defaultValue: []);
    });
  }

  void _addObjective(List newObjective) {
    setState(() {
      toDOList.add([
        newObjective[0], // title
        newObjective[1], // count
        newObjective[2], // goal
        newObjective.length > 3 ? newObjective[3] : "", // description
      ]);
      _objectivesBox.put('objectives', toDOList);
      _objectivesBox.put('selectedObjective', newObjective);
    });
  }

  void _deleteObjective(int index) {
    setState(() {
      toDOList.removeAt(index);
      _objectivesBox.put('objectives', toDOList);
      var selected = _objectivesBox.get('selectedObjective');
      if (selected != null && toDOList.every((obj) => obj[0] != selected[0])) {
        _objectivesBox.delete('selectedObjective');
      }
    });
  }

  void _selectObjective(int index) {
    final selected = [
      toDOList[index][0], // title
      toDOList[index][1], // count
      toDOList[index][2], // goal
      toDOList[index].length > 3 ? toDOList[index][3] : "", // description
    ];
    _objectivesBox.put('selectedObjective', selected);
    Navigator.pop(context, selected);
  }

  void _navigateAndAddObjective() async {
    final newObjective = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddObjectives()),
    );
    if (newObjective != null) _addObjective(newObjective);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Objectives")),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddObjective,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDOList.length,
        itemBuilder: (context, index) {
          var selected = _objectivesBox.get('selectedObjective');
          bool isSelected = selected != null &&
              selected[0] == toDOList[index][0] &&
              selected[2] == toDOList[index][2];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isSelected ? colorScheme.primary : null,
            child: Dismissible(
              key: Key(toDOList[index][0] + index.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _deleteObjective(index),
              background: Container(
                color: Colors.red.shade900,
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              child: ListTile(
                onTap: () => _selectObjective(index),
                title: Text(
                  toDOList[index][0],
                  style: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${toDOList[index][1]} / ${toDOList[index][2]}",
                      style: TextStyle(
                        color: isSelected ? Colors.white.withOpacity(0.8) : null,
                      ),
                    ),
                    if (toDOList[index].length > 3 && toDOList[index][3].isNotEmpty)
                      Text(
                        toDOList[index][3],
                        style: TextStyle(
                          color: isSelected ? Colors.white.withOpacity(0.6) : Colors.grey[600],
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                trailing: isSelected ? Icon(Icons.check, color: Colors.white) : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
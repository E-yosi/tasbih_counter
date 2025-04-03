import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasbih_counter/Components/bottom_nav_bar.dart';
import 'package:tasbih_counter/Components/app_drawer.dart';
import 'package:tasbih_counter/Components/objectives_repository.dart';
import 'package:tasbih_counter/Components/objectives.dart';
import 'package:tasbih_counter/Components/statistics_service.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ObjectivesRepository _repository;
  late final StatisticsService _statsService;

  @override
  void initState() {
    super.initState();
    _repository = ObjectivesRepository(
      Hive.box('objectivesBox'),
      Hive.box('historyBox'),
    );
    _statsService = StatisticsService(Hive.box('statisticsBox'));
  }

  Future<void> _updateCounter(int newValue) async {
    final selected = _repository.getSelectedObjective();
    if (selected != null) {
      final int change = newValue - (selected[1] as int);
      final objectives = _repository.getObjectives();
      final index = objectives.indexWhere((obj) =>
      obj[0] == selected[0] && obj[2] == selected[2]);

      if (index != -1) {
        _repository.updateObjectiveCount(index, newValue);

        if (change != 0) {
          await _statsService.updateCounts(change);
        }

        if (mounted) setState(() {});
      }
    }
  }

  void _resetCounter() {
    final selected = _repository.getSelectedObjective();
    if (selected != null) {
      final objectives = _repository.getObjectives();
      final index = objectives.indexWhere((obj) =>
      obj[0] == selected[0] && obj[2] == selected[2]);

      if (index != -1) {
        _repository.updateObjectiveCount(index, 0, updateHistory: false);
        if (mounted) setState(() {});
      }
    }
  }

  void _navigateToObjectives() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewObjectiveScreen()),
    );

    if (selected != null && mounted) {
      setState(() {
        _repository.selectObjective(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedObjective = _repository.getSelectedObjective();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.secondary,
      appBar: AppBar(
        title: Text("Tasbih Counter"),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedObjective == null)
              Card(
                color: colorScheme.surface,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("No Goal Set",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          )),
                      Text("Tap the list icon to add a goal",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                          )),
                    ],
                  ),
                ),
              )
            else
              Card(
                color: colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Text(selectedObjective[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      SizedBox(height: 12),
                      Text("${selectedObjective[1]} / ${selectedObjective[2]}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (selectedObjective[1] as int) / (selectedObjective[2] as int),
                        backgroundColor: Colors.grey[300],
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("lib/images/main.png", height: 400),
                Positioned(
                  top: 80,
                  child: Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        selectedObjective != null ? "${selectedObjective[1]}" : "0",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 70,
                  bottom: 80,
                  child: Material(
                    color: Colors.white,
                    shape: CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        if (selectedObjective != null && (selectedObjective[1] as int) > 0) {
                          _updateCounter((selectedObjective[1] as int) - 1);
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: Icon(Icons.remove, size: 40, color: Colors.red.shade600),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.secondary,
                        width: 7.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.white,
                      shape: CircleBorder(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          if (selectedObjective != null) {
                            _updateCounter((selectedObjective[1] as int) + 1);
                          }
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          alignment: Alignment.center,
                          child: Icon(Icons.add, size: 40, color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 70,
                  bottom: 80,
                  child: Material(
                    color: Colors.white,
                    shape: CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _resetCounter,
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: Icon(Icons.refresh, size: 40, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        onObjectivePressed: _navigateToObjectives,
      ),
    );
  }
}
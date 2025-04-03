import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ObjectivesRepository {
  final Box objectivesBox;
  final Box historyBox;

  ObjectivesRepository(this.objectivesBox, this.historyBox);

  List<dynamic> getObjectives() => objectivesBox.get('objectives', defaultValue: []);

  List<dynamic>? getSelectedObjective() => objectivesBox.get('selectedObjective', defaultValue: null);

  void addObjective(List<dynamic> objective) {
    final objectives = getObjectives();
    objectives.add([
      objective[0], // title
      objective[1], // count
      objective[2], // goal
      objective.length > 3 ? objective[3] : "", // description
    ]);
    objectivesBox.put('objectives', objectives);
    objectivesBox.put('selectedObjective', objective);
    _updateHistory(objective);
  }

  void deleteObjective(int index) {
    final objectives = getObjectives();
    final deleted = objectives.removeAt(index);
    objectivesBox.put('objectives', objectives);

    final selected = getSelectedObjective();
    if (selected != null && selected[0] == deleted[0] && selected[2] == deleted[2]) {
      objectivesBox.delete('selectedObjective');
    }
  }

  void selectObjective(List<dynamic> objective) {
    objectivesBox.put('selectedObjective', objective);
  }

  void updateObjectiveCount(int index, int newCount) {
    final objectives = getObjectives();
    if (index >= 0 && index < objectives.length) {
      objectives[index][1] = newCount;
      objectivesBox.put('objectives', objectives);

      final selected = getSelectedObjective();
      if (selected != null && objectives[index][0] == selected[0] && objectives[index][2] == selected[2]) {
        objectivesBox.put('selectedObjective', objectives[index]);
      }
      _updateHistory(objectives[index]);
    }
  }

  void _updateHistory(List<dynamic> objective) {
    final history = historyBox.get('history', defaultValue: []);

    history.removeWhere((item) => item['title'] == objective[0]);

    history.insert(0, {
      'id': '${objective[0]}_${DateTime.now().millisecondsSinceEpoch}',
      'title': objective[0],
      'progress': objective[1],
      'goal': objective[2],
      'description': objective.length > 3 ? objective[3] : "",
      'date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    });

    historyBox.put('history', history);
  }

  List<dynamic> getIncompleteObjectives() {
    final all = getObjectives();
    return all.where((obj) => obj[1] < obj[2]).toList();
  }
}
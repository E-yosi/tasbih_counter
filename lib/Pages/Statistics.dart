import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasbih_counter/Components/app_drawer.dart';
import 'package:tasbih_counter/Components/statistics_service.dart';

class StatisticsScreen extends StatelessWidget {
  final StatisticsService _statsService = StatisticsService(Hive.box('statisticsBox'));

  Future<void> _resetAllStatistics(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Statistics'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This will permanently reset:'),
                SizedBox(height: 8),
                Text('• Daily count'),
                Text('• Weekly count'),
                Text('• Monthly count'),
                Text('• Total count'),
                SizedBox(height: 16),
                Text('Are you sure you want to continue?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Reset All',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await Hive.box('statisticsBox').clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _resetAllStatistics(context),
            child: Text(
              'Reset All',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      backgroundColor: colorScheme.background,
      body: ValueListenableBuilder(
        valueListenable: Hive.box('statisticsBox').listenable(),
        builder: (context, box, _) {
          return Container(
            padding: EdgeInsets.all(16.0),
            color: colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Statistics",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    )),
                SizedBox(height: 20),
                _buildStatisticCard(
                  context,
                  "Daily",
                  _statsService.dailyDhikr,
                  Icons.today,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatisticCard(
                        context,
                        "Weekly",
                        _statsService.weeklyDhikr,
                        Icons.calendar_view_week,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildStatisticCard(
                        context,
                        "Monthly",
                        _statsService.monthlyDhikr,
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  color: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.all_inclusive,
                                color: colorScheme.onSurface, size: 28),
                            SizedBox(width: 10),
                            Text("Total Dhikr",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("${_statsService.totalDhikr}",
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticCard(
      BuildContext context,
      String label,
      int count,
      IconData icon
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: colorScheme.primary,
                size: 24),
            SizedBox(height: 8),
            Text("$count",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 5),
            Text(label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                )),
          ],
        ),
      ),
    );
  }
}
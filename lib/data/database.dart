import 'package:hive_flutter/hive_flutter.dart';

class ListDatabase{
  List toDOList = [];

  final _myBox = Hive.box("myBox");



  void CreateInitialData(){
    toDOList = [
      ["Create an Objective", 0, 1],
    ];
  }

  void LoadData(){
      toDOList = _myBox.get("TODOLIST");
  }

  void UpdateDatabase(){
    _myBox.put("TODOLIST", toDOList);
  }
}
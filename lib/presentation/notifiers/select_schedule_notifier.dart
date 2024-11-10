import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:flutter/material.dart';

class SelectScheduleNotifier extends ChangeNotifier{
  ScheduleModel? selectedSchedule;
  
  void setSelectedSchedule(ScheduleModel schedule) {
    this.selectedSchedule = schedule;
    notifyListeners();
  }
}
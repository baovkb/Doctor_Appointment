import 'package:doctor_appointment/core/utils/time_converter.dart';

class Helper {
  static void sortCombine(List<List<dynamic>> arrays, int sortIndex, String prop) {
     List<List<dynamic>> combined = List.generate(
      arrays[0].length, 
      (i) => arrays.map((array) => array[i]).toList()
    );
    combined.sort((a, b) => TimeConverter.compareTime(a[1], b[1].prop));
    for (int i = 0; i < arrays.length; i++) {
      for (int j = 0; j < arrays[i].length; j++) {
        arrays[i][j] = combined[j][i];
      }
    }
  }
}
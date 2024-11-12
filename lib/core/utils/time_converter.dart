class TimeConverter {
  static String getCurrentTime() {
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second} ${now.day}/${now.month}/${now.year}';
  }

  static int convertToUnixTime(String time) {
    List<String> parts = time.split(' ');
    List<String> timeParts = parts[0].split(':');
    List<String> dateParts = parts[1].split('/');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime dateTime = DateTime(year, month, day, hour, minute);

    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static int compareTime(String time1, String time2) {
    return convertToUnixTime(time1) - convertToUnixTime(time2);
  }

  static String getUnixTime() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
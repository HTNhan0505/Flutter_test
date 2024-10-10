import 'package:flutter/material.dart';

class DateTimeUtil {
  static DateTimeUtil? _instance;

  DateTimeUtil._();

  factory DateTimeUtil() => _instance ??= DateTimeUtil._();

  bool isEndTimeBeforeStartTime(TimeOfDay start, TimeOfDay end) {
    final startInMinutes = start.hour * 60 + start.minute;
    final endInMinutes = end.hour * 60 + end.minute;
    return endInMinutes < startInMinutes;
  }

  bool isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final timeInMinutes = time.hour * 60 + time.minute;
    final startInMinutes = start.hour * 60 + start.minute;
    final endInMinutes = end.hour * 60 + end.minute;

    return timeInMinutes >= startInMinutes && timeInMinutes <= endInMinutes;
  }


}
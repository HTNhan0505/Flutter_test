import 'package:excel/excel.dart';

abstract class ExcelState {}

class ExcelInitial extends ExcelState {}

class ExcelLoading extends ExcelState {}

class ExcelLoaded extends ExcelState {
  final List<List<String>> data;

  ExcelLoaded(this.data);
}

class ExcelError extends ExcelState {
  final String message;

  ExcelError(this.message);
}
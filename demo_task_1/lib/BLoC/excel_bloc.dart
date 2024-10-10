import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'excel_event.dart';
import 'excel_state.dart';
import 'dart:io';

class ExcelBloc extends Bloc<ExcelEvent, ExcelState> {
  ExcelBloc() : super(ExcelInitial()) {
    _loadExcelFromAssets();
  }

  void _loadExcelFromAssets() async {
    emit(ExcelLoading());
    try {
      ByteData data = await rootBundle.load('lib/assets/report.xlsx');
      Uint8List bytes = data.buffer.asUint8List();
      var excel = Excel.decodeBytes(bytes);
      List<List<String>> dataList = [];
      for (var table in excel.tables.keys) {
        int rowIndex = 0;
        for (var row in excel.tables[table]!.rows) {
          if (rowIndex < 8) {
            rowIndex++;
            continue;
          }

          List<String> filteredRow = [
            row[0]?.value?.toString() ?? '', // Cột STT
            row[1]?.value?.toString() ?? '', // Cột Ngày
            row[2]?.value?.toString() ?? '', // Cột Giờ
            row[8]?.value?.toString() ?? ''  // Cột Thành tiền
          ];

          dataList.add(filteredRow);
          rowIndex++;
        }
      }
      print('Data -------------------------- ${dataList}');
      emit(ExcelLoaded(dataList));
    } catch (e) {
      emit(ExcelError("Error loading Excel file from assets: $e"));
    }
  }
}
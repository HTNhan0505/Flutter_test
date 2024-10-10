import 'package:demo_task_1/utils/currency_util.dart';
import 'package:demo_task_1/utils/datetime_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'BLoC/excel_bloc.dart';
import 'BLoC/excel_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ExcelBloc(),
        child: const ExcelUploadPage(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class ExcelUploadPage extends StatefulWidget {
  const ExcelUploadPage({super.key});

  @override
  State<ExcelUploadPage> createState() => _ExcelUploadPageState();
}

class _ExcelUploadPageState extends State<ExcelUploadPage> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  double totalAmount = 0.0;
  String errorMessage = '';

  void calculateTotal() {
    totalAmount = 0.0;

    setState(() {
      errorMessage = '';
      totalAmount = 0.0;
    });

    // Kiểm tra giờ bắt đầu và kết thúc
    if (startTime == null || endTime == null) {
      setState(() {
        errorMessage = 'Vui lòng chọn cả giờ bắt đầu và giờ kết thúc.';
      });
      return;
    }

    if (DateTimeUtil().isEndTimeBeforeStartTime(startTime!, endTime!)) {
      setState(() {
        errorMessage = 'Giờ kết thúc không được nhỏ hơn giờ bắt đầu.';
      });
      return;
    }

    final state = context.read<ExcelBloc>().state;

    if (state is ExcelLoaded) {
      bool hasValidTime = false;

      for (var row in state.data) {
        var timeStr = row[2];
        var amountStr = row[3];

        TimeOfDay rowTime =
            TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(timeStr));

        double amount = double.tryParse(amountStr) ?? 0.0;

        if (DateTimeUtil().isTimeInRange(rowTime, startTime!, endTime!)) {
          totalAmount += amount;
          hasValidTime = true;
        }
      }

      if (!hasValidTime) {
        setState(() {
          errorMessage = 'Không có dữ liệu nào trong khoảng thời gian đã chọn.';
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<TimeOfDay?> showTimePickerDialog(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 1')),
      body: BlocBuilder<ExcelBloc, ExcelState>(
        builder: (context, state) {
          if (state is ExcelLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExcelLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('STT')),
                              DataColumn(label: Text('Ngày')),
                              DataColumn(label: Text('Giờ')),
                              DataColumn(label: Text('Thành tiền (VNĐ)')),
                            ],
                            rows: List<DataRow>.generate(
                              state.data.length,
                              (rowIndex) {
                                var row = state.data[rowIndex];
                                double amount = double.tryParse(row[3]) ?? 0.0;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(state.data[rowIndex][0])),
                                    DataCell(Text(state.data[rowIndex][1])),
                                    DataCell(Text(state.data[rowIndex][2])),
                                    DataCell(Text(
                                        CurrencyUtil().formatCurrency(amount))),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePickerDialog(context);
                        if (picked != null) {
                          setState(() {
                            startTime = picked;
                          });
                        }
                      },
                      child: Text(startTime == null
                          ? 'Chọn Giờ Bắt Đầu'
                          : '${startTime!.hour}:${startTime!.minute}'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePickerDialog(context);
                        if (picked != null) {
                          setState(() {
                            endTime = picked;
                          });
                        }
                      },
                      child: Text(endTime == null
                          ? 'Chọn Giờ Kết Thúc'
                          : '${endTime!.hour}:${endTime!.minute}'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: calculateTotal,
                      child: const Text('Tính Tiền'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                // Hiển thị tổng tiền
                Text(
                    'Tổng Tiền: ${CurrencyUtil().formatCurrency(totalAmount)}'),
              ],
            );
          } else if (state is ExcelError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

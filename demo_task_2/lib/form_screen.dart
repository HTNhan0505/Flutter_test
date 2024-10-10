import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/form_bloc.dart';
import 'bloc/form_event.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  int? selectedValue;

  final List<TextEditingController> numberControllers =
      List.generate(3, (_) => TextEditingController());

  String? errorMessage;
  String? successMessage;

  DateTime? selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          dateTimeController.text =
              DateFormat('dd/MM/yyyy HH:mm:ss').format(selectedDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      SystemNavigator.pop(); // Quay lại màn hình trước
                    },
                  ),
                  const Text(
                    "Đóng",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(width: 15),
                  Text(
                    "Nhập giao dịch",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: ElevatedButton(
                onPressed: () {
                  if(dateTimeController.text.isNotEmpty) {
                    selectedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(dateTimeController.text);
                  }
                  final quantity = double.tryParse(quantityController.text);
                  final total = double.tryParse(totalController.text);
                  final price = double.tryParse(priceController.text);

                  context
                      .read<FormBloc>()
                      .add(ValidateForm(selectedDateTime,  selectedValue,quantity ?? 0.0,total ?? 0.0,price ?? 0.0));

                  context.read<FormBloc>().stream.listen((state) {
                    setState(() {
                      errorMessage = state.errorMessage;
                      successMessage = state.successMessage;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  // Màu chữ
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bo góc
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Padding cho nút
                ),
                child: const Text("Cập nhật"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: dateTimeController,
                  decoration: InputDecoration(
                    labelText: "Thời gian",
                    suffixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDateTime(context),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: "Số lượng",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),


                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.only(top: 5,left: 10,right: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black54)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Trụ", style: TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ), // adjust your title as you required
                      ),
                      DropdownButton<int>(
                        value: selectedValue,
                        underline: SizedBox(),
                        isExpanded: true,
                        items: [1, 2, 3, 4, 5].map((value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: totalController,
                  decoration: InputDecoration(
                    labelText: "Doanh thu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Đơn giá",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 25),
                // Hiển thị thông báo lỗi
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                // Hiển thị thông báo thành công
                if (successMessage != null)
                  Text(
                    successMessage!,
                    style: const TextStyle(color: Colors.green),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

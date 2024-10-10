// form_event.dart
abstract class FormEvent {}

class ValidateForm extends FormEvent {
  final DateTime? dateTime;
  final double quantity;
  final double total;
  final double price;
  final int? selectedValue;

  ValidateForm(this.dateTime, this.selectedValue, this.quantity, this.total, this.price);
}
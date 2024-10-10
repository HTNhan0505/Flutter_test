import 'package:flutter_bloc/flutter_bloc.dart';

import 'form_event.dart';
import 'form_state.dart';

class FormBloc extends Bloc<FormEvent, MyFormState> {
  FormBloc() : super(MyFormState()) {
    on<ValidateForm>(_onValidateForm);
  }

  Future<void> _onValidateForm(
      ValidateForm event, Emitter<MyFormState> emit) async {
    String? errorMessage;
    String? successMessage;

    print("-------- Date ${event.dateTime}");

    // Validate inputs
    if (event.dateTime == null) {
      errorMessage = "Thời gian không được để trống.";
    } else if (event.quantity <= 0) {
      errorMessage = "Số lượng phải lớn hơn 0 và không được để trống.";
    } else if (event.selectedValue == null) {
      errorMessage = "Bạn cần mã trụ";
    }else if (event.total <= 0) {
      errorMessage = "Doanh thu phải lớn hơn 0 và không được để trống.";
    } else if (event.price <= 0) {
      errorMessage = "Đơn giá phải lớn hơn 0 và không được để trống.";
    } else {
      successMessage = "Cập nhật thành công!";
    }

    emit(MyFormState(
        errorMessage: errorMessage, successMessage: successMessage));
  }
}

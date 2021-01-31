import 'package:fe/employee/employees_repository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class OrderAssignBloc extends FormBloc<String, String> {
  OrderAssignBloc({
    @required this.employeesRepository,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        employees,
      ],
    );
  }

  final EmployeesRepository employeesRepository;

  SelectFieldBloc employees = SelectFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  String orderID;
  String userID;

  @override
  Future<void> onSubmitting() async {
    try {
      await employeesRepository
          .assignOrderToEmployee(
            employeeID: employeesRepository.getEmployeeID(
                email: employees.value.toString()),
            orderID: orderID,
            userID: userID,
          )
          .then((value) => emitSuccess(
                canSubmitAgain: true,
                successResponse: value,
              ));
    } catch (e) {
      emitFailure(failureResponse: e.toString());
      return;
    }
  }
}

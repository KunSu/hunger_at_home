part of 'employees_bloc.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object> get props => [];
}

class EmployeesInitial extends EmployeesState {}

class EmployeesSuccess extends EmployeesState {
  const EmployeesSuccess([this.users = const []]);

  final List<User> users;

  @override
  List<Object> get props => [users];
}

class EmployeesFailure extends EmployeesState {
  const EmployeesFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

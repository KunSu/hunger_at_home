part of 'employees_bloc.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class EmployeesLoaded extends EmployeesEvent {}

class EmployeesUpdated extends EmployeesEvent {
  const EmployeesUpdated({this.userID, this.email, this.status});

  final String userID;
  final String email;
  final String status;

  @override
  List<Object> get props => [userID, email, status];
}

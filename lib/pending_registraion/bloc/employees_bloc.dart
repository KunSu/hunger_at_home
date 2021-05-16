import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe/employee/employees_repository.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  EmployeesBloc({this.employeesRepository}) : super(EmployeesInitial());

  final EmployeesRepository employeesRepository;

  @override
  Stream<EmployeesState> mapEventToState(
    EmployeesEvent event,
  ) async* {
    if (event is EmployeesLoaded) {
      yield* _mapPendingsLoadedToState();
    } else if (event is EmployeesUpdated) {
      yield* _mapEmployeesUpdatedToState(event);
    }
  }

  Stream<EmployeesState> _mapPendingsLoadedToState() async* {
    List<User> users;
    try {
      await employeesRepository.getAllPendings().then((value) => users = value);
      yield EmployeesSuccess(
        users,
      );
    } catch (e) {
      yield EmployeesFailure(e.toString());
    }
  }

  Stream<EmployeesState> _mapEmployeesUpdatedToState(
      EmployeesUpdated event) async* {
    User newUser;
    try {
      await employeesRepository
          .approveNewUser(
            userID: event.userID,
            email: event.email,
            status: event.status,
          )
          .then((value) => newUser = value);
      final updatedUsers = (state as EmployeesSuccess).users.map((user) {
        return user.email == event.email ? newUser : user;
      }).toList();
      yield EmployeesSuccess(updatedUsers);
    } catch (e) {
      yield EmployeesFailure(e.toString());
    }
  }
}

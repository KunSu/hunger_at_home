import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe/login/models/models.dart';
import 'package:fe/register/models/models.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const RegisterState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is RegisterPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is RegisterFirstnameChanged) {
      yield _mapFirstnameChangedToState(event, state);
    } else if (event is RegisterLastnameChanged) {
      yield _mapLastnameChangedToState(event, state);
    } else if (event is RegisterPhoneNumberChanged) {
      yield _mapPhoneNumberChangedToState(event, state);
    } else if (event is RegisterUserIdentityChanged) {
      yield _mapUserIdentityChangedToState(event, state);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event, state);
    }
  }

  // TODO: double check with copyWith and Formz.validate

  RegisterState _mapUsernameChangedToState(
    RegisterUsernameChanged event,
    RegisterState state,
  ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([
        username,
        state.password,
        state.firstname,
        state.lastname,
        state.phonenumber,
        state.useridentity,
      ]),
    );
  }

  RegisterState _mapPasswordChangedToState(
    RegisterPasswordChanged event,
    RegisterState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([
        state.username,
        password,
        state.firstname,
        state.lastname,
        state.phonenumber,
        state.useridentity,
      ]),
    );
  }

  RegisterState _mapFirstnameChangedToState(
    RegisterFirstnameChanged event,
    RegisterState state,
  ) {
    final firstname = Firstname.dirty(event.firstname);
    return state.copyWith(
      firstname: firstname,
      status: Formz.validate([
        state.username,
        state.password,
        firstname,
        state.lastname,
        state.phonenumber,
        state.useridentity,
      ]),
    );
  }

  RegisterState _mapLastnameChangedToState(
    RegisterLastnameChanged event,
    RegisterState state,
  ) {
    final lastname = Lastname.dirty(event.lastname);
    return state.copyWith(
      lastname: lastname,
      status: Formz.validate([
        state.username,
        state.password,
        state.firstname,
        lastname,
        state.phonenumber,
        state.useridentity,
      ]),
    );
  }

  RegisterState _mapPhoneNumberChangedToState(
    RegisterPhoneNumberChanged event,
    RegisterState state,
  ) {
    final phonenumber = PhoneNumber.dirty(event.phonenumber);
    return state.copyWith(
      phonenumber: phonenumber,
      status: Formz.validate([
        state.username,
        state.password,
        state.firstname,
        state.lastname,
        phonenumber,
        state.useridentity,
      ]),
    );
  }

  RegisterState _mapUserIdentityChangedToState(
    RegisterUserIdentityChanged event,
    RegisterState state,
  ) {
    final useridentity = UserIdentity.dirty(event.useridentity);
    return state.copyWith(
      useridentity: useridentity,
      status: Formz.validate([
        state.username,
        state.password,
        state.firstname,
        state.lastname,
        state.phonenumber,
        useridentity,
      ]),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    RegisterSubmitted event,
    RegisterState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.register(
          username: state.username.value,
          password: state.password.value,
          firstname: state.firstname.value,
          lastname: state.lastname.value,
          phonenumber: state.phonenumber.value,
          useridentity: state.useridentity.value,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}

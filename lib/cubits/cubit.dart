import 'package:chat/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;

  RegisterState({this.isLoading = false, this.errorMessage});

  RegisterState copyWith({bool? isLoading, String? errorMessage}) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());
  late UserData user;
  Future<void> registerUser({
    required Future<UserCredential> Function() register,
    required Future<void> Function() addUserToDatabase,
    required Function(String) onSuccess,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await register();
      await addUserToDatabase();
      onSuccess('Registration successful!');
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
    emit(state.copyWith(isLoading: false));
  }
}

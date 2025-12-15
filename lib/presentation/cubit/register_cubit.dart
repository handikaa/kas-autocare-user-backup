import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/data/params/register_payload.dart';
import 'package:kas_autocare_user/domain/usecase/register_user.dart';

import '../../domain/usecase/regist_check_email.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegistCheckEmail useCasecheckemail;
  final RegisterUser useCaseRegisterUser;

  RegisterCubit(this.useCasecheckemail, this.useCaseRegisterUser)
    : super(RegisterCheckEmailInitial());

  Future<void> checkEmail({required String email}) async {
    emit(RegisterCheckEmailLoading());
    final result = await useCasecheckemail.execute(email: email);

    result.fold(
      (l) => emit(RegisterCheckEmailError(l)),
      (r) => emit(RegisterCheckEmailLoaded(r)),
    );
  }

  Future<void> registerUser(RegisterPayload payload) async {
    emit(RegisterlLoading());
    final result = await useCaseRegisterUser.execute(payload);

    result.fold(
      (l) => emit(RegisterlError(l)),
      (r) => emit(RegisterlLoaded(r)),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/user_entity.dart';
import 'package:kas_autocare_user/domain/usecase/get_detail_user.dart';

part 'get_detail_user_state.dart';

class GetDetailUserCubit extends Cubit<GetDetailUserState> {
  final GetDetailUser getDetailUser;

  GetDetailUserCubit(this.getDetailUser) : super(GetDetailUserInitial());

  Future<void> fetchDetailUser() async {
    emit(GetDetailUserLoading());

    final result = await getDetailUser.execute();

    result.fold(
      (l) => emit(GetDetailUserError(l)),
      (r) => emit(GetDetailUserSuccess(r)),
    );
  }
}

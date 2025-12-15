part of 'get_detail_user_cubit.dart';

abstract class GetDetailUserState extends Equatable {
  const GetDetailUserState();

  @override
  List<Object?> get props => [];
}

class GetDetailUserInitial extends GetDetailUserState {}

class GetDetailUserLoading extends GetDetailUserState {}

class GetDetailUserSuccess extends GetDetailUserState {
  final UserEntity data;

  const GetDetailUserSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class GetDetailUserError extends GetDetailUserState {
  final String message;

  const GetDetailUserError(this.message);

  @override
  List<Object?> get props => [message];
}

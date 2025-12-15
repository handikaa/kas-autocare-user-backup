import 'package:equatable/equatable.dart';

abstract class CreateVehicleState extends Equatable {
  const CreateVehicleState();

  @override
  List<Object?> get props => [];
}

class CreateVehicleInitial extends CreateVehicleState {}

class CreateVehicleLoading extends CreateVehicleState {}

class CreateVehicleSuccess extends CreateVehicleState {
  final String message;

  const CreateVehicleSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateVehicleError extends CreateVehicleState {
  final String message;

  const CreateVehicleError(this.message);

  @override
  List<Object?> get props => [message];
}

part of 'vehicle_cust_cubit.dart';

abstract class VehicleCustState extends Equatable {
  const VehicleCustState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleCustState {}

class VehicleLoading extends VehicleCustState {}

class VehicleLoaded extends VehicleCustState {
  final List<VehicleEntity> vehicles;

  const VehicleLoaded(this.vehicles);

  @override
  List<Object?> get props => [vehicles];
}

class VehicleError extends VehicleCustState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}

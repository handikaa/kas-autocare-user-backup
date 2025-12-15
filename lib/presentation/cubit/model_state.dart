part of 'model_cubit.dart';

abstract class ModelState extends Equatable {
  const ModelState();

  @override
  List<Object?> get props => [];
}

class ModelInitial extends ModelState {}

class ModelLoading extends ModelState {}

class ModelLoaded extends ModelState {
  final List<MVehicleEntity> models;

  const ModelLoaded(this.models);

  @override
  List<Object?> get props => [models];
}

class ModelError extends ModelState {
  final String message;

  const ModelError(this.message);

  @override
  List<Object?> get props => [message];
}

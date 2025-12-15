part of 'city_cubit.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final List<CityEntity> cities;

  const CityLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CityError extends CityState {
  final String message;

  const CityError(this.message);

  @override
  List<Object?> get props => [message];
}

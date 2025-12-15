part of 'list_district_cubit.dart';

abstract class ListDistrictState extends Equatable {
  const ListDistrictState();

  @override
  List<Object?> get props => [];
}

class ListDistrictInitial extends ListDistrictState {}

class ListDistrictLoading extends ListDistrictState {}

class ListDistrictLoaded extends ListDistrictState {
  final List<DistrictEntity> data;

  const ListDistrictLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ListDistrictError extends ListDistrictState {
  final String message;

  const ListDistrictError(this.message);

  @override
  List<Object?> get props => [message];
}

part of 'merchant_nearby_cubit.dart';

abstract class MerchantNearbyState extends Equatable {
  const MerchantNearbyState();

  @override
  List<Object?> get props => [];
}

class MerchantNearbyInitial extends MerchantNearbyState {}

class MerchantNearbyLoading extends MerchantNearbyState {}

class MerchantNearbyLoaded extends MerchantNearbyState {
  final List<MerchantEntity> merchants;

  const MerchantNearbyLoaded(this.merchants);

  @override
  List<Object?> get props => [merchants];
}

class MerchantNearbyError extends MerchantNearbyState {
  final String message;

  const MerchantNearbyError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

class AuthentificationEntity extends Equatable {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String roles;
  final int customerId;

  const AuthentificationEntity({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.roles,
    required this.customerId,
  });

  @override
  List<Object?> get props => [
    accessToken,
    tokenType,
    userId,
    roles,
    customerId,
  ];
}

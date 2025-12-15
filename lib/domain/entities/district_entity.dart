import 'package:equatable/equatable.dart';

class DistrictEntity extends Equatable {
  final int id;
  final int districtId;
  final String districtName;
  final String regencyName;
  final String provinceName;

  const DistrictEntity({
    required this.id,
    required this.districtId,
    required this.districtName,
    required this.regencyName,
    required this.provinceName,
  });

  @override
  List<Object?> get props => [
    id,
    districtId,
    districtName,
    regencyName,
    provinceName,
  ];
}

import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int id;
  final int provinceId;
  final String name;
  final ProvinceEntity province;

  const CityEntity({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.province,
  });

  @override
  List<Object?> get props => [id, provinceId, name, province];
}

class ProvinceEntity extends Equatable {
  final int id;
  final String name;

  const ProvinceEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

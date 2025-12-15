import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/package_entity.dart';
import '../../domain/usecase/fetch_list_package.dart';

part 'package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  final FetchListPackage fetchListPackage;

  PackageCubit(this.fetchListPackage) : super(PackageInitial());

  Future<void> getPackages({
    required int branchId,
    required int businessId,
    required String brand,
    required String model,
    required String vType,
  }) async {
    emit(PackageLoading());

    final result = await fetchListPackage.execute(
      brnchId: branchId,
      bsnisId: businessId,
      brand: brand,
      model: model,
      vType: vType,
    );

    result.fold(
      (error) => emit(PackageError(error)),
      (packages) => emit(PackageLoaded(packages)),
    );
  }
}

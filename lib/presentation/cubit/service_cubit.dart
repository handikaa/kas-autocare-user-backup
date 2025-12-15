import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/service_entity.dart';
import '../../domain/usecase/fetch_list_service.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final FetchListService fetchListService;

  ServiceCubit(this.fetchListService) : super(ServiceInitial());

  Future<void> getListService({
    required int branchId,
    required int businessId,
  }) async {
    emit(ServiceLoading());

    final result = await fetchListService.execute(
      brnchId: branchId,
      bsnisId: businessId,
    );

    result.fold(
      (failure) => emit(ServiceError(failure)),
      (services) => emit(ServiceLoaded(services)),
    );
  }
}

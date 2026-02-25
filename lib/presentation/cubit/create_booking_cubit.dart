import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/params/booking_payload.dart';
import '../../domain/entities/transaction/transaction_entity.dart';
import '../../domain/usecase/create_booking_customer.dart';

part 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  final CreateBookingCustomer _createBookingCustomer;

  CreateBookingCubit(this._createBookingCustomer)
    : super(CreateBookingInitial());

  Future<void> createVehicle(BookingPayload payload) async {
    emit(CreateBookingLoading());

    final result = await _createBookingCustomer.execute(payload);

    result.fold(
      (error) => emit(CreateBookingError(error)),
      (message) => emit(CreateBookingSuccess(message)),
    );
  }
}

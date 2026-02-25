import 'package:dartz/dartz.dart';

import '../../data/params/booking_payload.dart';
import '../entities/transaction/transaction_entity.dart';
import '../repositories/repositories_domain.dart';

class CreateBookingCustomer {
  final RepositoriesDomain repositoriesDomain;

  CreateBookingCustomer(this.repositoriesDomain);

  Future<Either<String, TransactionEntity>> execute(
    BookingPayload payload,
  ) async {
    return await repositoriesDomain.createBooking(payload);
  }
}

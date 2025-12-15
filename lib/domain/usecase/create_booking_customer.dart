import 'package:dartz/dartz.dart';

import '../../data/params/booking_payload.dart';
import '../repositories/repositories_domain.dart';

class CreateBookingCustomer {
  final RepositoriesDomain repositoriesDomain;

  CreateBookingCustomer(this.repositoriesDomain);

  Future<Either<String, int>> execute(BookingPayload payload) async {
    return await repositoriesDomain.createBooking(payload);
  }
}

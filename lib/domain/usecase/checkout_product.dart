import 'package:dartz/dartz.dart';

import '../../data/params/checkout_payload.dart';
import '../repositories/repositories_domain.dart';

class CheckoutProduct {
  final RepositoriesDomain repositoriesDomain;

  CheckoutProduct(this.repositoriesDomain);

  Future<Either<String, int>> checkoutProductt(CheckoutPayload payload) {
    return repositoriesDomain.checkoutProduct(payload);
  }
}

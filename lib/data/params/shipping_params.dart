import 'dart:convert';

String shippingParamsToJson(ShippingParams data) => json.encode(data.toJson());

class ShippingParams {
  List<int> cartIds;
  int destinationId;
  int qty;
  int pickupPointId;

  ShippingParams({
    required this.cartIds,
    required this.destinationId,
    required this.qty,
    required this.pickupPointId,
  });

  ShippingParams copyWith({
    List<int>? cartIds,
    int? destinationId,
    int? qty,
    int? pickupPointId,
  }) => ShippingParams(
    cartIds: cartIds ?? this.cartIds,
    destinationId: destinationId ?? this.destinationId,
    qty: qty ?? this.qty,
    pickupPointId: pickupPointId ?? this.pickupPointId,
  );

  Map<String, dynamic> toJson() => {
    "cart_ids": List<dynamic>.from(cartIds.map((x) => x)),
    "destination_id": destinationId,
    "qty": qty,
    "pickup_point_id": pickupPointId,
  };
}

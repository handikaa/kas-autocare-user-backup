class Expedition {
  final String id;
  final String name;
  final String logoUrl;
  final List<ShippingService> services;

  Expedition({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.services,
  });
}

class ShippingService {
  final String name;
  final int price;

  ShippingService({required this.name, required this.price});
}

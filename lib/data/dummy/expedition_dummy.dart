import '../model/expedition_model.dart';

final dummyExpeditions = [
  Expedition(
    id: 'idexp',
    name: 'ID Express',
    logoUrl: 'https://picsum.photos/500/300',
    services: [
      ShippingService(name: 'Instant', price: 35000),
      ShippingService(name: 'Sameday', price: 30000),
      ShippingService(name: 'Ekspress', price: 20000),
      ShippingService(name: 'Reguler', price: 15000),
      ShippingService(name: 'Cargo', price: 50000),
    ],
  ),
  Expedition(
    id: 'sicepat',
    name: 'SiCepat Express',
    logoUrl: 'https://picsum.photos/500/300',
    services: [
      ShippingService(name: 'Reguler', price: 15000),
      ShippingService(name: 'Best', price: 25000),
      ShippingService(name: 'Cargo', price: 40000),
    ],
  ),
  Expedition(
    id: 'jnt',
    name: 'J&T Express',
    logoUrl: 'https://picsum.photos/500/300',
    services: [
      ShippingService(name: 'Reguler', price: 15000),
      ShippingService(name: 'Express', price: 20000),
    ],
  ),
];

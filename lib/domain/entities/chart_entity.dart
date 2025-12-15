import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/product_entity.dart';
import 'package:kas_autocare_user/domain/entities/user_entity.dart';

class ChartEntity extends Equatable {
  final int id;
  final int branchId;
  final int bussinesId;
  final int businessUnitId;
  final int branchProductNewsId;
  final int userId;
  final int customerId;
  final String productName;
  final String variantName;
  final String variantSizeName;
  final List<String> image;
  final int qty;
  final int price;
  final int totalPrice;
  final String type;
  final int variantProductNewsId;
  final int variantProductSizeNewsId;
  final BranchEntity branch;
  final BranchProductEntity branchProduct;
  final VariantEntity? variant;
  final SizeEntity? variantSize;
  final UserEntity? user;
  final CustomerEntity customer;

  const ChartEntity({
    required this.id,
    required this.branchId,
    required this.bussinesId,
    required this.businessUnitId,
    required this.branchProductNewsId,
    required this.userId,
    required this.customerId,
    required this.productName,
    required this.variantName,
    required this.variantSizeName,
    required this.image,
    required this.qty,
    required this.price,
    required this.totalPrice,
    required this.type,
    required this.variantProductNewsId,
    required this.variantProductSizeNewsId,
    required this.branch,
    required this.branchProduct,
    this.variant,
    this.variantSize,
    this.user,
    required this.customer,
  });

  @override
  List<Object?> get props => [
    id,
    branchId,
    bussinesId,
    businessUnitId,
    branchProductNewsId,
    userId,
    customerId,
    productName,
    variantName,
    variantSizeName,
    image,
    qty,
    price,
    totalPrice,
    type,
    variantProductNewsId,
    variantProductSizeNewsId,
    branch,
    branchProduct,
    variant,
    variantSize,
    user,
    customer,
  ];
}

class BranchProductEntity extends Equatable {
  final int id;
  final String name;
  final int price;
  final bool isCod;
  final int stock;
  final int minOrder;
  final int maxOrder;
  final List<String> image;

  const BranchProductEntity({
    required this.stock,
    required this.isCod,
    required this.minOrder,
    required this.maxOrder,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, price, image];
}

class CustomerEntity extends Equatable {
  final int id;
  final String username;
  final String phone;

  const CustomerEntity({
    required this.id,
    required this.username,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, username, phone];
}

// class UserEntity extends Equatable {
//   final int id;
//   final String name;
//   final String email;

//   const UserEntity({required this.id, required this.name, required this.email});

//   @override
//   List<Object?> get props => [id, name, email];
// }

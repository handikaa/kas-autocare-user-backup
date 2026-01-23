import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/data/params/get_hour_params.dart';
import 'package:kas_autocare_user/data/params/payload_address_input.dart';
import 'package:kas_autocare_user/data/params/register_payload.dart';
import 'package:kas_autocare_user/domain/entities/address_entity.dart';
import 'package:kas_autocare_user/domain/entities/banner_carousel_entity/banner_carousel_entity.dart';
import 'package:kas_autocare_user/domain/entities/district_entity.dart';
import 'package:kas_autocare_user/domain/entities/history_transaction_entity.dart';
import 'package:kas_autocare_user/domain/entities/time_entity.dart';
import 'package:kas_autocare_user/domain/entities/user_entity.dart';

import '../../data/model/params_location.dart';
import '../../data/model/vehicle_payload_model.dart';
import '../../data/params/add_tochart_params.dart';
import '../../data/params/booking_payload.dart';
import '../../data/params/checkout_payload.dart';
import '../../data/params/history_params.dart';
import '../../data/params/login_params.dart';
import '../../data/params/product_query_params.dart';
import '../../data/params/shipping_params.dart';
import '../../data/params/update_chart_params.dart';
import '../entities/authentification_entity.dart';
import '../entities/brand_entity.dart';
import '../entities/chart_entity.dart';
import '../entities/city_entity.dart';
import '../entities/menu_entity.dart';
import '../entities/merchant_entity.dart';
import '../entities/mvehicle_entity.dart';
import '../entities/package_entity.dart';
import '../entities/product_entity.dart';
import '../entities/qr_product_entity.dart';
import '../entities/service_entity.dart';
import '../entities/shipping_entity.dart';
import '../entities/vehicle_entity.dart';

abstract class RepositoriesDomain {
  Future<Either<String, List<MenuEntity>>> getListMenu();
  Future<Either<String, UserEntity>> getDetailUser();
  Future<Either<String, String>> createVehicleRepoImpl(
    VehiclePayloadModel payload,
  );
  Future<Either<String, List<BrandEntity>>> getListBrand(String vType);
  Future<Either<String, List<MVehicleEntity>>> getListModel({
    required String brand,
    required String vType,
  });

  Future<Either<String, List<VehicleEntity>>> getListVehicle();
  Future<Either<String, List<MerchantEntity>>> getListMerchantnearby(
    ParamsLocation params,
  );
  Future<Either<String, List<PackageEntity>>> getListPackage({
    required int brnchId,
    required int bsnisId,
    required String brand,
    required String model,
    required String vType,
  });
  Future<Either<String, List<ServiceEntity>>> getListService({
    required int brnchId,
    required int bsnisId,
  });
  Future<Either<String, List<CityEntity>>> getlistCity();
  Future<Either<String, int>> createBooking(BookingPayload payload);

  Future<Either<String, List<ProductEntity>>> getListProduct(
    ProductQueryParams params,
  );
  Future<Either<String, ProductEntity>> getDetailProduct(int id);
  Future<Either<String, String>> addChartProduct(AddChartParams params);
  Future<Either<String, int>> checkoutProduct(CheckoutPayload payload);
  Future<Either<String, QrProductEntity>> generateQRProduct({
    required int id,
    required int idMerchant,
  });
  Future<Either<String, QrProductEntity>> generateQRService({
    required int id,
    required int idMerchant,
  });
  Future<Either<String, List<ChartEntity>>> getListChart();
  Future<Either<String, CheckShippingEntity>> getListShipping(
    ShippingParams params,
  );
  Future<Either<String, String>> deleteChart(int id);
  Future<Either<String, String>> updateChart({
    required UpdateChartParams params,
    required int id,
  });

  Future<Either<String, String>> addAddress(PayloadAddressInput payload);
  Future<Either<String, AuthentificationEntity>> loginUser(LoginParams payload);
  Future<Either<String, String>> logoutUser();
  Future<Either<String, String>> updateAddress({
    required int id,
    required PayloadAddressInput payload,
  });
  Future<Either<String, List<DistrictEntity>>> getListDistrict(String? search);
  Future<Either<String, List<AddressEntity>>> getListAddress();
  Future<Either<String, List<HistoryTransactionEntity>>> getListHistory(
    HistoryParams? params, {
    required int page,
  });
  Future<Either<String, List<TimeEntity>>> getListTime({
    required GetHourParams params,
  });
  Future<Either<String, HistoryTransactionEntity>> getDetailHistory(int id);
  Future<Either<String, String>> deleteAddress(int id);
  Future<Either<String, AddressEntity>> detailAddress(int id);
  Future<Either<String, List<BannerCarouselEntity>>> getListCarouselBanner();
  Future<Either<String, bool>> registerCheckEmail({required String email});
  Future<Either<String, String>> registerSendOtp({required String email});
  Future<Either<String, String>> registerVerifyOtp({
    required String email,
    required String code,
  });
  Future<Either<String, String>> registerUser(RegisterPayload payload);
  Future<Either<String, String>> forgotSendOtp({required String email});
  Future<Either<String, String>> forgotVerifyOtp({
    required String email,
    required String otp,
  });
  Future<Either<String, String>> resetPass({
    required String email,
    required String pass,
    required String confirmPass,
  });
}

import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/banner_carousel_entity/banner_carousel_entity.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/entities/authentification_entity.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/chart_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/district_entity.dart';
import '../../domain/entities/history_transaction_entity.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/merchant_entity.dart';
import '../../domain/entities/mvehicle_entity.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/qr_product_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/shipping_entity.dart';
import '../../domain/entities/time_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/repositories_domain.dart';
import '../datasource/remote/remote.dart';
import '../model/params_location.dart';
import '../model/vehicle_payload_model.dart';
import '../params/add_tochart_params.dart';
import '../params/booking_payload.dart';
import '../params/checkout_payload.dart';
import '../params/get_hour_params.dart';
import '../params/history_params.dart';
import '../params/login_params.dart';
import '../params/payload_address_input.dart';
import '../params/product_query_params.dart';
import '../params/register_payload.dart';
import '../params/shipping_params.dart';
import '../params/update_chart_params.dart';

class RepositoriesImpl implements RepositoriesDomain {
  final Remote remote;

  RepositoriesImpl(this.remote);

  @override
  Future<Either<String, List<MenuEntity>>> getListMenu() async {
    try {
      final result = await remote.getListMenu();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> createVehicleRepoImpl(
    VehiclePayloadModel payload,
  ) async {
    try {
      final result = await remote.createVehicleCustomer(payload);

      if (result) {
        return const Right('Berhasil menambah kendaraan baru');
      } else {
        return const Left('Gagal menambahkan kendaraan. Coba lagi nanti.');
      }
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, List<BrandEntity>>> getListBrand(String vType) async {
    try {
      final result = await remote.getListBrand(vType);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<VehicleEntity>>> getListVehicle() async {
    try {
      final result = await remote.getListVehicleCust();

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MVehicleEntity>>> getListModel({
    required String brand,
    required String vType,
  }) async {
    try {
      final result = await remote.getListModel(brand: brand, vType: vType);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MerchantEntity>>> getListMerchantnearby(
    ParamsLocation params,
  ) async {
    try {
      final result = await remote.getListMerchantbyLocation(params);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<PackageEntity>>> getListPackage({
    required int brnchId,
    required int bsnisId,
    required String brand,
    required String model,
    required String vType,
  }) async {
    try {
      final result = await remote.getListPackage(
        brnchId: brnchId,
        bsnisId: bsnisId,
        model: model,
        brand: brand,
        vType: vType,
      );

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ServiceEntity>>> getListService({
    required int brnchId,
    required int bsnisId,
  }) async {
    try {
      final result = await remote.getListService(
        brnchId: brnchId,
        bsnisId: bsnisId,
      );

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<CityEntity>>> getlistCity() async {
    try {
      final result = await remote.getListCity();

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int>> createBooking(BookingPayload payload) async {
    try {
      final result = await remote.createBooking(payload);

      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ProductEntity>>> getListProduct(
    ProductQueryParams params,
  ) async {
    try {
      final result = await remote.getListProduct(params);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ProductEntity>> getDetailProduct(int id) async {
    try {
      final result = await remote.getdetailProduct(id);

      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> addChartProduct(AddChartParams params) async {
    try {
      final result = await remote.addToChart(params);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteChart(int id) async {
    try {
      final result = await remote.deleteChart(id);

      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<ChartEntity>>> getListChart() async {
    try {
      final result = await remote.getListChart();

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateChart({
    required UpdateChartParams params,
    required int id,
  }) async {
    try {
      final result = await remote.updateChart(params: params, chartId: id);

      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CheckShippingEntity>> getListShipping(
    ShippingParams params,
  ) async {
    try {
      final result = await remote.checkShipping(params);

      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, int>> checkoutProduct(CheckoutPayload payload) async {
    try {
      final result = await remote.checkout(payload);

      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, QrProductEntity>> generateQRProduct({
    required int id,
    required int idMerchant,
  }) async {
    try {
      final result = await remote.generateQRProduct(
        id: id,
        idMerchant: idMerchant,
      );

      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, QrProductEntity>> generateQRService({
    required int id,
    required int idMerchant,
  }) async {
    try {
      final result = await remote.generateQRService(
        id: id,
        idMerchant: idMerchant,
      );
      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> addAddress(PayloadAddressInput payload) async {
    try {
      final result = await remote.addAddress(payload);
      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<DistrictEntity>>> getListDistrict(
    String? search,
  ) async {
    try {
      final result = await remote.getListDistrict(search);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<AddressEntity>>> getListAddress() async {
    try {
      final result = await remote.getListAddress();

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteAddress(int id) async {
    try {
      final result = await remote.deleteAddress(id);

      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AddressEntity>> detailAddress(int id) async {
    try {
      final result = await remote.detailAddress(id);

      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateAddress({
    required int id,
    required PayloadAddressInput payload,
  }) async {
    try {
      final result = await remote.updateAddress(id: id, payload: payload);

      final entities = result;

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<HistoryTransactionEntity>>> getListHistory(
    HistoryParams? params, {
    required int page,
  }) async {
    try {
      final result = await remote.getListHistory(params, page: page);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, HistoryTransactionEntity>> getDetailHistory(
    int id,
  ) async {
    try {
      final result = await remote.getdetailHistory(id: id);

      final entities = result.toEntity();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TimeEntity>>> getListTime({
    required GetHourParams params,
  }) async {
    try {
      final result = await remote.getListTime(params: params);

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AuthentificationEntity>> loginUser(
    LoginParams payload,
  ) async {
    try {
      final result = await remote.loginUser(payload: payload);

      final res = result.toEntity();

      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> logoutUser() async {
    try {
      final result = await remote.logoutUser();

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> registerCheckEmail({
    required String email,
  }) async {
    try {
      final result = await remote.registeCheckEmail(email: email);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> registerSendOtp({
    required String email,
  }) async {
    try {
      final result = await remote.sendOTPCode(email: email);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> registerVerifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final result = await remote.verifyOTPCode(email: email, code: code);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> registerUser(RegisterPayload payload) async {
    try {
      final result = await remote.registerUser(payload);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> forgotSendOtp({required String email}) async {
    try {
      final result = await remote.sendOTPForgot(email: email);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> forgotVerifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await remote.verifyOTPForgot(email: email, otp: otp);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> resetPass({
    required String email,
    required String pass,
    required String confirmPass,
  }) async {
    try {
      final result = await remote.resetPass(
        email: email,
        pass: pass,
        confirmPass: confirmPass,
      );

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> getDetailUser() async {
    try {
      final result = await remote.getDetailUser();

      final res = result.toEntity();

      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<BannerCarouselEntity>>>
  getListCarouselBanner() async {
    try {
      final result = await remote.getListCarouselBanner();

      final entities = result.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

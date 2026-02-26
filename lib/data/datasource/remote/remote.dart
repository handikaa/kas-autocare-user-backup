import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kas_autocare_user/data/model/history/history_model.dart';
import 'package:kas_autocare_user/data/model/notification_model.dart';
import 'package:kas_autocare_user/data/model/user_model.dart';
import 'package:kas_autocare_user/data/params/history_params.dart';
import 'package:kas_autocare_user/data/params/register_payload.dart';

import '../../../core/utils/api_constant.dart';
import '../../model/address_model.dart';
import '../../model/authentification_model.dart';
import '../../model/baner_carousel/banner_carousel_model.dart';
import '../../model/brand_model.dart';
import '../../model/chart_model.dart';
import '../../model/city_model.dart';
import '../../model/district_model.dart';
import '../../model/history/history_transaction_model.dart';
import '../../model/menu_model.dart';
import '../../model/merchant_model.dart';
import '../../model/mvehicle_model.dart';
import '../../model/package_model.dart';
import '../../model/params_location.dart';
import '../../model/product_model.dart';
import '../../model/qr_product_model.dart';
import '../../model/service_model.dart';
import '../../model/shipping_model.dart';
import '../../model/time_model.dart';
import '../../model/transaction/transaction_model.dart';
import '../../model/vehicle_model.dart';
import '../../model/vehicle_payload_model.dart';
import '../../params/add_tochart_params.dart';
import '../../params/booking_payload.dart';
import '../../params/checkout_payload.dart';
import '../../params/get_hour_params.dart';
import '../../params/login_params.dart';
import '../../params/payload_address_input.dart';
import '../../params/product_query_params.dart';
import '../../params/shipping_params.dart';
import '../../params/update_chart_params.dart';
import '../local/auth_local_data_source.dart';
import 'base_remote_handler.dart';

abstract class Remote {
  Future<List<MenuModel>> getListMenu();
  Future<UserModel> getDetailUser();
  Future<bool> createVehicleCustomer(VehiclePayloadModel payload);

  Future<List<BrandModel>> getListBrand(String vType);
  Future<List<MerchantModel>> getListMerchantbyLocation(ParamsLocation params);
  Future<List<VehicleModel>> getListVehicleCust();
  Future<List<MVehicleModel>> getListModel({
    required String brand,
    required String vType,
  });
  Future<List<PackageModel>> getListPackage({
    required int brnchId,
    required int bsnisId,
    required String model,
    required String brand,
    required String vType,
  });
  Future<List<ServiceModel>> getListService({
    required int brnchId,
    required int bsnisId,
  });
  Future<List<CityModel>> getListCity();
  Future<TransactionModel> createBooking(BookingPayload payload);

  Future<List<ProductModel>> getListProduct(ProductQueryParams params);
  Future<ProductModel> getdetailProduct(int productId);
  Future<AuthentificationModel> loginUser({required LoginParams payload});
  Future<String> saveFcmToServer();

  Future<String> logoutUser();
  Future<String> addToChart(AddChartParams params);
  Future<List<ChartModel>> getListChart();
  Future<String> updateChart({
    required UpdateChartParams params,
    required int chartId,
  });
  Future<String> deleteChart(int id);
  Future<int> checkout(CheckoutPayload payload);
  Future<QrProductModel> generateQRProduct({
    required int id,
    required int idMerchant,
  });
  Future<QrProductModel> generateQRService({
    required int id,
    required int idMerchant,
  });
  Future<CheckShippingModel> checkShipping(ShippingParams params);

  Future<List<DistrictModel>> getListDistrict(String? search);

  Future<List<AddressModel>> getListAddress();
  Future<String> deleteAddress(int id);
  Future<String> addAddress(PayloadAddressInput payload);
  Future<String> updateAddress({
    required int id,
    required PayloadAddressInput payload,
  });
  Future<AddressModel> detailAddress(int id);
  Future<List<HistoryTransactionModel>> getListHistory(
    HistoryParams? params, {
    required int page,
  });
  Future<List<TimeModel>> getListTime({required GetHourParams params});
  Future<List<BannerCarouselModel>> getListCarouselBanner();
  Future<HistoryModel> getdetailHistory({required int id});
  Future<bool> registeCheckEmail({required String email});
  Future<String> sendOTPCode({required String email});
  Future<String> verifyOTPCode({required String email, required String code});
  Future<String> registerUser(RegisterPayload payload);

  Future<String> sendOTPForgot({required String email});
  Future<String> verifyOTPForgot({required String email, required String otp});
  Future<String> resetPass({
    required String email,
    required String pass,
    required String confirmPass,
  });

  Future<List<NotificationModel>> getListNotif();
  Future<String> readNotif(List<int> notifId);
  Future<String> sendNotif({
    required String title,
    required String body,
    required String message,
    required int userId,
  });
}

class RemoteDataImpl implements Remote {
  final Dio dio;
  final BaseRemoteHandler _handler;

  RemoteDataImpl(this.dio) : _handler = BaseRemoteHandler(dio);

  String? lclTkn;
  String? fcmTkn;
  int? uid;
  int? csId;

  Future<void> getLocal() async {
    final authLocal = AuthLocalDataSource();

    String? tkn = await authLocal.getToken();
    String? tknFcm = await authLocal.getTokenFCM();
    int? lcluid = await authLocal.getUserId();
    int? lclCsid = await authLocal.getCustomerId();
    lclTkn = tkn;
    fcmTkn = tknFcm;
    uid = lcluid;
    csId = lclCsid;
  }

  @override
  Future<List<MenuModel>> getListMenu() async {
    final response = await dio.get(ApiConstant.features);
    final data = response.data as List;
    return data.map((e) => MenuModel.fromJson(e)).toList();
  }

  @override
  Future<bool> createVehicleCustomer(VehiclePayloadModel payload) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.createVehicleCust,
      method: 'POST',
      data: payload.toJson(),
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return true;
    }

    throw Exception("Format response tidak sesuai");
  }

  @override
  Future<List<BrandModel>> getListBrand(String vType) async {
    await getLocal();

    final result = await _handler.request(
      queryParameters: {'vehicle_type': vType},
      endpoint: ApiConstant.listBrand,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<VehicleModel>> getListVehicleCust() async {
    await getLocal();

    log("[TOKEN] : $lclTkn");
    final result = await _handler.request(
      queryParameters: {'user_id': uid},
      endpoint: ApiConstant.getVehicleCust,
      method: 'GET',

      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<MVehicleModel>> getListModel({
    required String brand,
    required String vType,
  }) async {
    await getLocal();
    final result = await _handler.request(
      queryParameters: {'brand_name': brand, 'vehicle_type': vType},
      endpoint: ApiConstant.listModel,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => MVehicleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<MerchantModel>> getListMerchantbyLocation(
    ParamsLocation params,
  ) async {
    await getLocal();

    Map<String, dynamic>? qparams = {
      if (params.city != null) "city": params.city!,
      // if (params.city != null) "city": "Jakarta Barat",
      if (params.lat != null) "latitude": params.lat,
      if (params.long != null) "longitude": params.long,
      // 'radius': 1000,
    };

    final result = await _handler.request(
      queryParameters: qparams,
      endpoint: ApiConstant.getbranchByLocation,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => MerchantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<PackageModel>> getListPackage({
    required int brnchId,
    required int bsnisId,
    required String model,
    required String brand,
    required String vType,
  }) async {
    Map<String, dynamic>? qparams = {
      "bussines_id": bsnisId,
      "branch_id": brnchId,
      "brand": brand,
      "model": model,
      "vehicle_type": vType,
    };

    await getLocal();

    final result = await _handler.request(
      queryParameters: qparams,
      endpoint: ApiConstant.listPackage,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<ServiceModel>> getListService({
    required int brnchId,
    required int bsnisId,
  }) async {
    await getLocal();

    Map<String, dynamic>? qparams = {
      "bussiness_id": bsnisId,
      "branch_id": brnchId,
    };

    final result = await _handler.request(
      queryParameters: qparams,
      endpoint: ApiConstant.listService,
      headers: {"Authorization": "Bearer $lclTkn"},
      method: 'GET',
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<CityModel>> getListCity() async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.listCity,
      method: 'GET',
      withAuth: true,
      headers: {"X-API-TOKEN": "kasprima2025", "Authorization": lclTkn},
    );

    if (result is List) {
      return result
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<TransactionModel> createBooking(BookingPayload payload) async {
    // await getLocal();

    // final updatedPayload = payload.copyWith(id: userId);

    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.createBooking,
      method: 'POST',
      data: payload.copyWith(userId: uid, customersId: csId).toJson(),
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      final data = result;

      return TransactionModel.fromJson(data);
    }

    throw Exception('Gagal membuat booking (Format tidak sesuai)');
  }

  @override
  Future<List<ProductModel>> getListProduct(ProductQueryParams params) async {
    await getLocal();
    final qparams = params.toMap();

    final result = await _handler.request(
      queryParameters: qparams,
      endpoint: ApiConstant.listProduct,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<ProductModel> getdetailProduct(int productId) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: '${ApiConstant.detailProduct}/$productId',
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return ProductModel.fromJson(result);
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<String> addToChart(AddChartParams params) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.addChart,
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      data: params.copyWith(userId: uid).toJson(),
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      final message = result['message'] ?? 'Berhasil menambah keranjang';

      return message;
    }

    throw Exception('Gagal menambah keranjang (Format tidak sesuai)');
  }

  @override
  Future<List<ChartModel>> getListChart() async {
    await getLocal();

    final result = await _handler.request(
      endpoint: "${ApiConstant.listChart}?user_id=$uid",
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      return result
          .map((e) => ChartModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal mengambil keranjang');
  }

  @override
  Future<String> deleteChart(int id) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: "${ApiConstant.deleteChart}/$id",
      method: 'DELETE',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    final response = result;

    if (response is Map<String, dynamic>) {
      final message = result['message'] ?? 'Berhasil menghapus dari keranjang';

      return message;
    }

    throw Exception('Gagal menghapus chart');
  }

  @override
  Future<String> updateChart({
    required UpdateChartParams params,
    required int chartId,
  }) async {
    await getLocal();

    await _handler.request(
      endpoint: "${ApiConstant.deleteChart}/$chartId",
      data: params.toJson(),
      method: 'PUT',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    return 'Berhasil mengedit keranjang';

    // throw Exception('Gagal mengupdate chart');
  }

  @override
  Future<CheckShippingModel> checkShipping(ShippingParams params) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.checkShipping,
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      data: params.toJson(),
      withAuth: true,
    );

    if (result is Map<String, dynamic> && result['shipping'] is List) {
      return CheckShippingModel.fromJson(result);
    }

    throw Exception('Gagal mengambil list shipping');
  }

  @override
  Future<int> checkout(CheckoutPayload payload) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.checkoutProduct,
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      data: payload.copyWith(userId: uid).toJson(),
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      final data = result['transaction']['id'];

      return data;
    }

    throw Exception('Gagal membuat checkout');
  }

  @override
  Future<QrProductModel> generateQRProduct({
    required int id,
    required int idMerchant,
  }) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.generateQRProduct,
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      data: {"transaction_news_id": id},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return QrProductModel.fromJson(result);
    }

    throw Exception('Gagal generate QR');
  }

  @override
  Future<QrProductModel> generateQRService({
    required int id,
    required int idMerchant,
  }) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.generateQRService,
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      data: {
        "transaction_news_id": id,
        // "id_merchant": idMerchant.toString()
      },
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return QrProductModel.fromJson(result);
    }

    throw Exception('Gagal generate QR Layanan');
  }

  @override
  Future<String> addAddress(PayloadAddressInput payload) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.addAddress,
      method: 'POST',
      data: payload.copyWith(userId: uid).toJson(),
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result['address'] is Map<String, dynamic>) {
      return "Berhasil membuat alamat baru";
    }

    throw Exception("Format data address tidak sesuai");
  }

  @override
  Future<List<DistrictModel>> getListDistrict(String? search) async {
    await getLocal();

    Map<String, dynamic>? qparams = {if (search != null) "search": search};

    final result = await _handler.request(
      endpoint: ApiConstant.getListDistrict,
      method: 'GET',
      queryParameters: qparams,
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is List) {
      final list = result;

      return list
          .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal Kesalahan Format');
  }

  @override
  Future<List<AddressModel>> getListAddress() async {
    await getLocal();

    Map<String, dynamic>? qparams = {"user_id": uid};

    final result = await _handler.request(
      endpoint: ApiConstant.listAddress,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      queryParameters: qparams,
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      final list = result['data'] as List;

      return list
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal mengambil list shipping');
  }

  @override
  Future<String> deleteAddress(int id) async {
    await getLocal();

    Map<String, dynamic>? qparams = {"user_id": uid};

    final result = await _handler.request(
      endpoint: "${ApiConstant.deleteAddress}/$id",
      method: 'DELETE',
      headers: {"Authorization": "Bearer $lclTkn"},
      queryParameters: qparams,
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return 'Berhasil menghapus alamat';
    }

    throw Exception('Gagal menghapus alamat');
  }

  @override
  Future<AddressModel> detailAddress(int id) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: '${ApiConstant.detailAddress}/$id',
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return AddressModel.fromJson(result);
    }

    throw Exception("Format data tidak sesuai");
  }

  @override
  Future<String> updateAddress({
    required int id,
    required PayloadAddressInput payload,
  }) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: '${ApiConstant.updateAddress}/$id',
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
      data: payload.copyWith(userId: uid).toJson(),
    );

    if (result is Map<String, dynamic>) {
      return "Berhasil mengubah alamat";
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<HistoryTransactionModel>> getListHistory(
    HistoryParams? params, {
    required int page,
  }) async {
    await getLocal();

    Map<String, dynamic>? qparams = {
      "user_id": uid,
      'page': page,
      'per_page': 15,
    };

    if (params != null) {
      qparams.addAll(params.toQuery());
    }

    final result = await _handler.request(
      endpoint: ApiConstant.listTransactionHistory,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      queryParameters: qparams,
      withAuth: true,
    );

    if (result is List) {
      return result
          .map(
            (e) => HistoryTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    throw Exception('Gagal mengambil history');
  }

  @override
  Future<HistoryModel> getdetailHistory({required int id}) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: '${ApiConstant.detailTransaction}/$id',
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      final res = result;
      return HistoryModel.fromJson(res);
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<List<TimeModel>> getListTime({required GetHourParams params}) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.getListTime,
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      queryParameters: params.toJson(),
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      final list = result['all_slots_flat'] as List;

      return list
          .map((e) => TimeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal mengambil jam');
  }

  @override
  Future<AuthentificationModel> loginUser({
    required LoginParams payload,
  }) async {
    final result = await _handler.request(
      endpoint: ApiConstant.login,
      method: 'POST',
      data: payload.toJson(),
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      if (result['roles'] == "customer") {
        return AuthentificationModel.fromJson(result);
      } else {
        throw Exception("Akun tidak ditemukan");
      }
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<String> logoutUser() async {
    await getLocal();
    final result = await _handler.request(
      endpoint: ApiConstant.logout,
      method: 'POST',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Berhasil Logout";
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<bool> registeCheckEmail({required String email}) async {
    await getLocal();
    final result = await _handler.request(
      endpoint: ApiConstant.checkemail,
      method: 'POST',
      data: {"email": email},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return result['available'] ?? "false";
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<String> sendOTPCode({required String email}) async {
    await getLocal();
    final result = await _handler.request(
      endpoint: ApiConstant.sendOtp,
      method: 'POST',
      data: {"email": email},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Silahkan Cek Email/Spam";
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<String> verifyOTPCode({
    required String email,
    required String code,
  }) async {
    await getLocal();
    final result = await _handler.request(
      endpoint: ApiConstant.verifyOtp,
      method: 'POST',
      data: {"email": email, "otp": code},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Berhasil";
    }

    throw Exception("Format data brand tidak sesuai");
  }

  @override
  Future<String> registerUser(RegisterPayload payload) async {
    await getLocal();
    final result = await _handler.request(
      endpoint: ApiConstant.register,
      method: 'POST',

      data: payload.toJson(),
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Berhasil Register";
    }

    throw Exception("Format data tidak sesuai");
  }

  @override
  Future<String> sendOTPForgot({required String email}) async {
    final result = await _handler.request(
      endpoint: ApiConstant.sendOtpforgotPass,
      method: 'POST',

      data: {"email": email},
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Email ditemukan";
    }

    throw Exception("Format data tidak sesuai");
  }

  @override
  Future<String> verifyOTPForgot({
    required String email,
    required String otp,
  }) async {
    final result = await _handler.request(
      endpoint: ApiConstant.verifyOtpforgotPass,
      method: 'POST',

      data: {"email": email, "otp": otp},
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Berhasil Kirim OTP";
    }

    throw Exception("Format data tidak sesuai");
  }

  @override
  Future<String> resetPass({
    required String email,
    required String pass,
    required String confirmPass,
  }) async {
    final result = await _handler.request(
      endpoint: ApiConstant.resetPass,
      method: 'POST',

      data: {
        "email": email,
        "password": pass,
        "password_confirmation": confirmPass,
      },
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Berhasil Kirim OTP";
    }

    throw Exception("Format data tidak sesuai");
  }

  @override
  Future<UserModel> getDetailUser() async {
    await getLocal();
    final result = await _handler.request(
      endpoint: "${ApiConstant.detailUser}/$uid",
      method: 'GET',
      headers: {"Authorization": "Bearer $lclTkn"},
      withAuth: true,
    );

    if (result is Map<String, dynamic>) {
      Map<String, dynamic> res = result['customer'];
      return UserModel.fromJson(res);
    }

    throw Exception("Format data tidak sesuai");
  }

  @override
  Future<List<BannerCarouselModel>> getListCarouselBanner() async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.getListCarouselBanner,
      method: 'GET',
      headers: {
        // "Authorization": "Bearer $lclTkn",
        "Accept": "application/json",
        "X-API-TOKEN": "kasprima2025",
      },
    );

    if (result is Map<String, dynamic>) {
      final list = result['data'] as List;

      return list
          .map((e) => BannerCarouselModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal Mengambil Banner');
  }

  @override
  Future<String> saveFcmToServer() async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.saveFcm,
      method: 'POST',
      data: {"user_id": uid, "fcm": fcmTkn},
      headers: {
        // "Authorization": "Bearer $lclTkn",
        "Accept": "application/json",
        "X-API-TOKEN": "kasprima2025",
      },
    );

    if (result is Map<String, dynamic>) {
      return result['message'] ?? "Berhasil menyimpan token";
    }
    throw Exception('Gagal notifikasi, hubungi developer untuk masalah detail');
  }

  @override
  Future<List<NotificationModel>> getListNotif() async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.notif,
      method: 'GET',
      queryParameters: {"user_id": uid},
      headers: {
        // "Authorization": "Bearer $lclTkn",
        "Accept": "application/json",
        "X-API-TOKEN": "kasprima2025",
      },
    );

    if (result is List) {
      return result
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal notifikasi, hubungi developer untuk masalah detail');
  }

  @override
  Future<String> readNotif(List<int> notifId) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.readNotif,
      method: 'POST',
      data: {"notification_id": notifId, "user_id": uid},
      headers: {
        // "Authorization": "Bearer $lclTkn",
        "Accept": "application/json",
        "X-API-TOKEN": "kasprima2025",
      },
    );

    if (result is Map<String, dynamic>) {
      return result['message'];
    }
    throw Exception(
      'Terjadi Kesalahan, hubungi developer untuk masalah detail',
    );
  }

  @override
  Future<String> sendNotif({
    required String title,
    required String body,
    required String message,
    required int userId,
  }) async {
    await getLocal();

    final result = await _handler.request(
      endpoint: ApiConstant.sendNotif,
      method: 'POST',
      data: {
        "title": title,
        "body": body,
        "message": message,
        "user_id": userId,
      },
      headers: {
        // "Authorization": "Bearer $lclTkn",
        "Accept": "application/json",
        "X-API-TOKEN": "kasprima2025",
      },
    );

    if (result is Map<String, dynamic>) {
      return result['message'];
    }
    throw Exception(
      'Terjadi Kesalahan, hubungi developer untuk masalah detail',
    );
  }
}

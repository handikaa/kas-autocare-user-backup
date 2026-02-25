import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kas_autocare_user/domain/usecase/add_address.dart';
import 'package:kas_autocare_user/domain/usecase/add_to_chart.dart';
import 'package:kas_autocare_user/domain/usecase/authentification/save_fcm_usecase.dart';
import 'package:kas_autocare_user/domain/usecase/checkout_product.dart';
import 'package:kas_autocare_user/domain/usecase/create_booking_customer.dart';
import 'package:kas_autocare_user/domain/usecase/forgot_send_otp.dart';
import 'package:kas_autocare_user/domain/usecase/forgot_verify_otp.dart';
import 'package:kas_autocare_user/domain/usecase/get_detail_user.dart';
import 'package:kas_autocare_user/domain/usecase/logout_user.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_detail_address.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_detail_history.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_detail_product.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_address.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_city.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_history.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_package.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_product.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_service.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_shipping.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_time.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_vmodel.dart';
import 'package:kas_autocare_user/domain/usecase/generate_qr_product.dart';
import 'package:kas_autocare_user/domain/usecase/generate_qr_service.dart';
import 'package:kas_autocare_user/domain/usecase/get_list_district.dart';
import 'package:kas_autocare_user/domain/usecase/login_user.dart';
import 'package:kas_autocare_user/domain/usecase/notification/send_notification_usecase.dart';
import 'package:kas_autocare_user/domain/usecase/regist_check_email.dart';
import 'package:kas_autocare_user/domain/usecase/register_user.dart';
import 'package:kas_autocare_user/domain/usecase/reset_pass.dart';
import 'package:kas_autocare_user/domain/usecase/send_otp.dart';
import 'package:kas_autocare_user/domain/usecase/update_address.dart';
import 'package:kas_autocare_user/domain/usecase/verify_otp.dart';
import 'package:kas_autocare_user/presentation/cubit/add_address_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/add_tochart_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/cart_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/checkout_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/city_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/create_booking_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/detail_history_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/detail_product_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/forgot_pass_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/get_detail_user_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/list_address_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/list_district_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/list_history_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/list_time_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/logout_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/merchant_nearby_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/model_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/notification/save_fcm_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/notification/send_notification_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/package_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/product_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/register_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/shipping_subit.dart';
import 'package:kas_autocare_user/presentation/cubit/vehicle_cust_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/verify_otp_cubit.dart';

import '../../../data/datasource/remote/remote.dart';
import '../../../data/repositories/remote_data_impl.dart';
import '../../../data/repositories/ws_auth_repository.dart';
import '../../../domain/repositories/repositories_domain.dart';
import '../../../domain/usecase/banner_carousel/get_list_banner_carousel_usecase.dart';
import '../../../domain/usecase/create_vehicle_customer.dart';
import '../../../domain/usecase/delete_address.dart';
import '../../../domain/usecase/delete_chart.dart';
import '../../../domain/usecase/fetch_list_brand.dart';
import '../../../domain/usecase/fetch_list_menu.dart';
import '../../../domain/usecase/fetch_list_merchant_nearby.dart';
import '../../../domain/usecase/fetch_list_vehicle_cust.dart';
import '../../../domain/usecase/get_list_chart.dart';
import '../../../domain/usecase/notification/get_list_notification_usecase.dart';
import '../../../domain/usecase/notification/read_list_notification_usecase.dart';
import '../../../domain/usecase/update_chart.dart';
import '../../../presentation/cubit/banner_carousel_cubit/get_list_banner_cubit.dart';
import '../../../presentation/cubit/brand_cubit.dart';
import '../../../presentation/cubit/generate_qr_cubit.dart';
import '../../../presentation/cubit/login_cubit.dart';
import '../../../presentation/cubit/notification/get_list_notification_cubit.dart';
import '../../../presentation/cubit/notification/read_list_notification_cubit.dart';
import '../../../presentation/cubit/payment_ws/payment_ws_cubit.dart';
import '../../../presentation/cubit/service_cubit.dart';
import '../../network/dio_client.dart';
import '../utils/payment_service_websocket.dart';

final sl = GetIt.instance;

Future<void> init(String baseUrl) async {
  // DioClient (singleton)
  sl.registerLazySingleton(() => DioClient(baseUrl));

  // Dio instance (singleton)
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // WS auth repo
  sl.registerLazySingleton<WsAuthRepository>(
    () => WsAuthRepositoryImpl(dio: sl<Dio>()),
  );

  // WS service
  sl.registerLazySingleton<PaymentWsService>(
    () => PaymentWsService(authRepo: sl<WsAuthRepository>(), enableLogs: true),
  );

  // Data source
  sl.registerLazySingleton<Remote>(() => RemoteDataImpl(sl()));

  // Repository
  sl.registerLazySingleton<RepositoriesDomain>(() => RepositoriesImpl(sl()));

  // Usecase
  sl.registerLazySingleton(() => FetchListMenu(sl()));
  sl.registerLazySingleton(() => FetchListBrand(sl()));
  sl.registerLazySingleton(() => FetchListVehicleCust(sl()));
  sl.registerLazySingleton(() => FetchListVmodel(sl()));
  sl.registerLazySingleton(() => CreateVehicleCustomer(sl()));
  sl.registerLazySingleton(() => FetchListMerchantNearby(sl()));
  sl.registerLazySingleton(() => FetchListPackage(sl()));
  sl.registerLazySingleton(() => FetchListCity(sl()));
  sl.registerLazySingleton(() => FetchListService(sl()));
  sl.registerLazySingleton(() => FetchListProduct(sl()));
  sl.registerLazySingleton(() => FetchDetailProduct(sl()));
  sl.registerLazySingleton(() => CreateBookingCustomer(sl()));
  sl.registerLazySingleton(() => AddToChart(sl()));
  sl.registerLazySingleton(() => GetListChart(sl()));
  sl.registerLazySingleton(() => DeleteChart(sl()));
  sl.registerLazySingleton(() => UpdateChart(sl()));
  sl.registerLazySingleton(() => FetchListShipping(sl()));
  sl.registerLazySingleton(() => CheckoutProduct(sl()));
  sl.registerLazySingleton(() => GenerateQrProduct(sl()));
  sl.registerLazySingleton(() => GenerateQrService(sl()));
  sl.registerLazySingleton(() => AddAddress(sl()));
  sl.registerLazySingleton(() => GetListDistrict(sl()));
  sl.registerLazySingleton(() => FetchListAddress(sl()));
  sl.registerLazySingleton(() => FetchDetailAddress(sl()));
  sl.registerLazySingleton(() => FetchListHistory(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => UpdateAddress(sl()));
  sl.registerLazySingleton(() => FetchListTime(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => FetchDetailHistory(sl()));
  sl.registerLazySingleton(() => RegistCheckEmail(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => ForgotSendOtp(sl()));
  sl.registerLazySingleton(() => ForgotVerifyOtp(sl()));
  sl.registerLazySingleton(() => ResetPass(sl()));
  sl.registerLazySingleton(() => GetDetailUser(sl()));
  sl.registerLazySingleton(() => GetListBannerCarouselUsecase(sl()));
  sl.registerLazySingleton(() => Savefcmusecase(sl()));
  sl.registerLazySingleton(() => GetListNotificationUsecase(sl()));
  sl.registerLazySingleton(() => ReadListNotificationUsecase(sl()));
  sl.registerLazySingleton(() => SendNotificationUsecase(sl()));

  // Cubit
  sl.registerFactory(() => GetDetailUserCubit(sl<GetDetailUser>()));
  sl.registerFactory(() => SaveFcmCubit(sl<Savefcmusecase>()));
  sl.registerFactory(() => BrandCubit(sl<FetchListBrand>()));
  sl.registerFactory(() => ModelCubit(sl<FetchListVmodel>()));
  sl.registerFactory(() => VehicleCustCubit(sl<FetchListVehicleCust>()));
  sl.registerFactory(() => MerchantNearbyCubit(sl<FetchListMerchantNearby>()));
  sl.registerFactory(() => PackageCubit(sl<FetchListPackage>()));
  sl.registerFactory(() => CityCubit(sl<FetchListCity>()));
  sl.registerFactory(() => ServiceCubit(sl<FetchListService>()));
  sl.registerFactory(() => LoginCubit(sl<LoginUser>()));
  sl.registerFactory(() => LogoutCubit(sl<LogoutUser>()));
  sl.registerFactory(() => DetailHistoryCubit(sl<FetchDetailHistory>()));
  sl.registerFactory(
    () => ProductCubit(sl<FetchListProduct>(), sl<GetListChart>()),
  );
  sl.registerFactory(() => DetailProductCubit(sl<FetchDetailProduct>()));
  sl.registerFactory(() => CreateBookingCubit(sl<CreateBookingCustomer>()));
  sl.registerFactory(() => AddToCartCubit(sl<AddToChart>()));
  sl.registerFactory(() => ShippingCubit(sl<FetchListShipping>()));
  sl.registerFactory(() => CheckoutCubit(sl<CheckoutProduct>()));
  sl.registerFactory(() => ListHistoryCubit(sl<FetchListHistory>()));
  sl.registerFactory(() => ListTimeCubit(sl<FetchListTime>()));
  sl.registerFactory(
    () => SendNotificationCubit(sl<SendNotificationUsecase>()),
  );
  sl.registerFactory(
    () => GetListBannerCubit(sl<GetListBannerCarouselUsecase>()),
  );
  sl.registerFactory(
    () => RegisterCubit(sl<RegistCheckEmail>(), sl<RegisterUser>()),
  );
  sl.registerFactory(() => VerifyOtpCubit(sl<VerifyOtp>(), sl<SendOtp>()));
  sl.registerFactory(
    () => ForgotPassCubit(
      sl<ForgotSendOtp>(),
      sl<ForgotVerifyOtp>(),
      sl<ResetPass>(),
    ),
  );
  sl.registerFactory(
    () => AddAddressCubit(
      sl<AddAddress>(),
      sl<FetchDetailAddress>(),
      sl<UpdateAddress>(),
    ),
  );
  sl.registerFactory(() => ListDistrictCubit(sl<GetListDistrict>()));
  sl.registerFactory(
    () => GetListNotificationCubit(sl<GetListNotificationUsecase>()),
  );
  sl.registerFactory(
    () => ReadListNotificationCubit(sl<ReadListNotificationUsecase>()),
  );
  sl.registerFactory(
    () => ListAddressCubit(sl<FetchListAddress>(), sl<DeleteAddress>()),
  );
  sl.registerFactory(
    () => GenerateQrCubit(sl<GenerateQrProduct>(), sl<GenerateQrService>()),
  );
  sl.registerFactory(() => PaymentWsCubit(sl<PaymentWsService>()));
  sl.registerFactory(
    () => CartCubit(
      getListChart: sl<GetListChart>(),
      deleteChart: sl<DeleteChart>(),
      updateChart: sl<UpdateChart>(),
    ),
  );
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kas_autocare_user/presentation/cubit/notification/send_notification_cubit.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/config/inject/depedency_injection.dart';
import 'core/config/theme/app_theme.dart';
import 'core/config/utils/payment_service_websocket.dart';
import 'core/utils/api_constant.dart';
import 'data/datasource/local/auth_local_data_source.dart';
import 'data/dummy/dummy_payment_method.dart';
import 'data/model/add_address_data.dart';
import 'data/model/payment_data.dart';
import 'data/params/shipping_params.dart';
import 'domain/entities/chart_entity.dart';
import 'domain/usecase/add_address.dart';
import 'domain/usecase/create_booking_customer.dart';
import 'domain/usecase/create_vehicle_customer.dart';
import 'domain/usecase/fetch_detail_address.dart';
import 'domain/usecase/fetch_detail_product.dart';
import 'domain/usecase/fetch_list_brand.dart';
import 'domain/usecase/fetch_list_city.dart';
import 'domain/usecase/fetch_list_merchant_nearby.dart';
import 'domain/usecase/fetch_list_package.dart';
import 'domain/usecase/fetch_list_service.dart';
import 'domain/usecase/fetch_list_time.dart';
import 'domain/usecase/fetch_list_vehicle_cust.dart';
import 'domain/usecase/fetch_list_vmodel.dart';
import 'domain/usecase/get_list_district.dart';
import 'domain/usecase/update_address.dart';
import 'firebase_options.dart';
import 'presentation/cubit/add_address_cubit.dart';
import 'presentation/cubit/brand_cubit.dart';
import 'presentation/cubit/cart_cubit.dart';
import 'presentation/cubit/checkout_cubit.dart';
import 'presentation/cubit/city_cubit.dart';
import 'presentation/cubit/create_booking_cubit.dart';
import 'presentation/cubit/create_new_v_cubit.dart';
import 'presentation/cubit/detail_history_cubit.dart';
import 'presentation/cubit/detail_product_cubit.dart';
import 'presentation/cubit/forgot_pass_cubit.dart';
import 'presentation/cubit/generate_qr_cubit.dart';
import 'presentation/cubit/get_detail_user_cubit.dart';
import 'presentation/cubit/list_address_cubit.dart';
import 'presentation/cubit/list_district_cubit.dart';
import 'presentation/cubit/list_history_cubit.dart';
import 'presentation/cubit/list_time_cubit.dart';
import 'presentation/cubit/login_cubit.dart';
import 'presentation/cubit/logout_cubit.dart';
import 'presentation/cubit/merchant_nearby_cubit.dart';
import 'presentation/cubit/model_cubit.dart';
import 'presentation/cubit/package_cubit.dart';
import 'presentation/cubit/payment_ws/payment_ws_cubit.dart';
import 'presentation/cubit/product_cubit.dart';
import 'presentation/cubit/register_cubit.dart';
import 'presentation/cubit/service_cubit.dart';
import 'presentation/cubit/shipping_subit.dart';
import 'presentation/cubit/splash_cubit.dart';
import 'presentation/cubit/vehicle_cust_cubit.dart';
import 'presentation/cubit/verify_otp_cubit.dart';
import 'presentation/pages/address/add_address_page.dart';
import 'presentation/pages/address/address_list_page.dart';
import 'presentation/pages/assurance/assurance_page.dart';
import 'presentation/pages/assurance/check_assurance_page.dart';
import 'presentation/pages/assurance/input_assurance_page.dart';
import 'presentation/pages/chart/chart_page.dart';
import 'presentation/pages/checkout/checkout_page.dart';
import 'presentation/pages/dashboard/dashboard.dart';
import 'presentation/pages/detail_transaction/detail_transaction.dart';
import 'presentation/pages/history/history_page.dart';
import 'presentation/pages/home_page/home_page.dart';
import 'presentation/pages/intro_page/intro_page.dart';
import 'presentation/pages/login/login_page.dart';
import 'presentation/pages/notification/notification_page.dart';
import 'presentation/pages/opm/opm_page.dart';
import 'presentation/pages/payment_information/payment_information.dart';
import 'presentation/pages/payment_method.dart/select_payment_method.dart';
import 'presentation/pages/ppob/check_taglist.dart';
import 'presentation/pages/ppob/detail_ppob_page.dart';
import 'presentation/pages/ppob/input_ppob_listrik.dart';
import 'presentation/pages/ppob/input_ppob_pdam.dart';
import 'presentation/pages/ppob/ppob.dart';
import 'presentation/pages/product/detail_transaction_product.dart';
import 'presentation/pages/product/product_detail.dart';
import 'presentation/pages/product/product_page.dart';
import 'presentation/pages/product/product_reviews.dart';
import 'presentation/pages/product/tracking_product.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/register/input_email_page.dart';
import 'presentation/pages/register/input_otp_page.dart';
import 'presentation/pages/register/register_page.dart';
import 'presentation/pages/register/reset_password_page.dart';
import 'presentation/pages/select_expedition/select_expedition_page.dart';
import 'presentation/pages/service/find_location.dart';
import 'presentation/pages/service/service_page.dart';
import 'presentation/pages/splash/splashscreen.dart';
import 'presentation/pages/voucher/voucher_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw StateError(
      "Gagal load .env. Pastikan file .env ada dan sudah didaftarkan di pubspec.yaml.\n"
      "Detail: $e",
    );
  }

  await GeolocatorPlatform.instance.isLocationServiceEnabled();
  await init(ApiConstant.baseUrl);

  await SentryFlutter.init(
    (options) {
      options.dsn = ApiConstant.sentry;
      options.tracesSampleRate = 1.0;
      options.debug = true;
    },

    appRunner: () {
      runApp(
        BlocProvider(
          create: (_) => SplashCubit(AuthLocalDataSource()),
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final appRouter = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(path: '/', builder: (context, state) => const Splashscreen()),
      GoRoute(path: '/intro', builder: (context, state) => IntroPage()),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            BlocProvider(create: (_) => sl<LoginCubit>(), child: LoginPage()),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ListHistoryCubit>(),
          child: const HistoryPage(),
        ),
      ),
      GoRoute(
        path: '/voucher',
        builder: (context, state) => const VoucherPage(),
      ),
      GoRoute(
        path: '/register-input-email',
        builder: (context, state) {
          final data = state.extra as String;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RegisterCubit>()),
              BlocProvider(create: (context) => sl<ForgotPassCubit>()),
            ],

            child: InputEmailPage(type: data),
          );
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final email = extra?["email"] ?? "";
          final otpCode = extra?["otp"] ?? "";

          return BlocProvider(
            create: (_) => sl<RegisterCubit>(),
            child: RegisterPage(email: email, otpCode: otpCode),
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as String;

          return BlocProvider(
            create: (_) => sl<ForgotPassCubit>(),
            child: ResetPasswordPage(email: extra),
          );
        },
      ),

      GoRoute(
        path: '/register-input-otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final email = extra?["email"] ?? "";
          final type = extra?["type"] ?? "";

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<VerifyOtpCubit>()),
              BlocProvider(create: (_) => sl<ForgotPassCubit>()),
            ],

            child: InputOtpPage(email: email, type: type),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<LogoutCubit>()),
            BlocProvider(
              create: (_) => sl<GetDetailUserCubit>()..fetchDetailUser(),
            ),
          ],

          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: '/service',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => BrandCubit(sl<FetchListBrand>())),
            BlocProvider(
              create: (_) => VehicleCustCubit(sl<FetchListVehicleCust>()),
            ),
            BlocProvider(create: (_) => ModelCubit(sl<FetchListVmodel>())),
            BlocProvider(
              create: (_) => CreateVehicleCubit(sl<CreateVehicleCustomer>()),
            ),
            BlocProvider(
              create: (_) => MerchantNearbyCubit(sl<FetchListMerchantNearby>()),
            ),
            BlocProvider(create: (_) => PackageCubit(sl<FetchListPackage>())),
            BlocProvider(create: (_) => ServiceCubit(sl<FetchListService>())),
            BlocProvider(
              create: (_) => CreateBookingCubit(sl<CreateBookingCustomer>()),
            ),
            BlocProvider(create: (_) => ListTimeCubit(sl<FetchListTime>())),
          ],
          child: const ServicePage(),
        ),
      ),

      GoRoute(
        path: '/find-location',
        builder: (context, state) {
          final data = state.extra as String;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => CityCubit(sl<FetchListCity>())),
              BlocProvider(
                create: (_) => ListDistrictCubit(sl<GetListDistrict>()),
              ),
            ],

            child: FindLocation(location: data),
          );
        },
      ),

      GoRoute(
        path: '/payment-information',
        builder: (context, state) {
          final data = state.extra as PaymentData;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<GenerateQrCubit>()),
              BlocProvider(create: (_) => sl<SendNotificationCubit>()),
              BlocProvider(
                create: (_) => PaymentWsCubit(sl<PaymentWsService>()),
              ),
            ],
            child: PaymentInformationPage(data: data),
          );
        },
      ),
      GoRoute(
        path: '/detail-booking-transaction',
        builder: (context, state) {
          final data = state.extra as PaymentData;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    sl<DetailHistoryCubit>()..getDetailHistory(data.id),
              ),
              BlocProvider(create: (_) => sl<GenerateQrCubit>()),
              BlocProvider(create: (_) => sl<SendNotificationCubit>()),
            ],
            child: DetailBookingTransactionPage(data: data),
          );
        },
      ),
      GoRoute(
        path: '/product',
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              // PRODUCT CUBIT
              BlocProvider<ProductCubit>(
                create: (_) {
                  final cubit = sl<ProductCubit>();
                  cubit.getInitialProducts(); // Ambil list produk
                  return cubit;
                },
              ),

              // CART CUBIT
              BlocProvider<CartCubit>(
                create: (_) {
                  final cubit = sl<CartCubit>();

                  // Panggil fetchCart setelah build selesai
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    cubit.fetchCart();
                  });

                  return cubit;
                },
              ),
            ],
            child: const ProductPage(),
          );
        },
      ),

      GoRoute(
        path: '/reviews-product',
        builder: (context, state) => const ProductReviewsPage(),
      ),
      GoRoute(
        path: '/opm',
        builder: (context, state) {
          final LatLong? data = state.extra as LatLong?;
          return OpmPage(latLong: data);
        },
      ),
      GoRoute(
        path: '/tracking-product',
        builder: (context, state) {
          final trxId = state.extra as int;
          return BlocProvider(
            create: (_) => sl<DetailHistoryCubit>()..getDetailHistory(trxId),
            child: TrackingProductPage(trxId: trxId),
          );
        },
      ),

      GoRoute(
        path: '/detail-product',
        builder: (context, state) {
          final id = state.extra as int;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    DetailProductCubit(sl<FetchDetailProduct>())
                      ..getDetailProduct(id),
              ),
              BlocProvider<CartCubit>(
                create: (_) {
                  final cubit = sl<CartCubit>();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    cubit.fetchCart();
                  });

                  return cubit;
                },
              ),
            ],

            child: ProductDetailPage(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/detail-transaction-product',
        builder: (context, state) {
          final data = state.extra as PaymentData;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    sl<DetailHistoryCubit>()..getDetailHistory(data.id),
              ),
              BlocProvider(create: (_) => sl<GenerateQrCubit>()),
            ],

            child: DetailTransactionProduct(data: data),
          );
        },
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final products = state.extra as List<ChartEntity>? ?? [];

          return BlocProvider(
            create: (_) => sl<CheckoutCubit>(),
            child: CheckoutPage(products: products),
          );
        },
      ),
      GoRoute(
        path: '/select-expedition',
        builder: (context, state) {
          final params = state.extra as ShippingParams;

          return BlocProvider(
            create: (_) => sl<ShippingCubit>()..getListShippings(params),
            child: SelectExpeditionPage(params: params),
          );
        },
      ),
      GoRoute(
        path: '/list-address',
        builder: (context, state) {
          bool? data = state.extra as bool?;
          return BlocProvider(
            create: (_) => sl<ListAddressCubit>()..getListAddress(),
            child: AddressListPage(isCheckout: data),
          );
        },
      ),
      GoRoute(
        path: '/add-address',
        builder: (context, state) {
          final data = state.extra as AddAddressData?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AddAddressCubit(
                  sl<AddAddress>(),
                  sl<FetchDetailAddress>(),
                  sl<UpdateAddress>(),
                ),
              ),
            ],
            child: AddAddressPage(data: data),
          );
        },
      ),
      GoRoute(
        path: '/list-district',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<ListDistrictCubit>(),
            child: AddAddressPage(),
          );
        },
      ),
      GoRoute(
        path: '/select-payment-method',
        builder: (context, state) {
          return SelectPaymentMethodPage(methods: dummyPaymentMethods);
        },
      ),
      GoRoute(
        path: '/ppob',
        builder: (context, state) {
          return PpobPage();
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return PpobPage();
        },
      ),
      GoRoute(
        path: '/detail-ppob',

        builder: (context, state) {
          final status = state.extra is Map
              ? (state.extra as Map)['status']
              : null;
          final title = state.extra is Map
              ? (state.extra as Map)['title']
              : null;

          return DetailPpobPage(status: status, title: title);
        },
      ),

      GoRoute(
        path: '/input-ppob-listrik',
        builder: (context, state) {
          final title = state.extra as String;
          return InputPpobPage(title: title);
        },
      ),
      GoRoute(
        path: '/input-ppob-pdam',
        builder: (context, state) {
          final title = state.extra as String;
          return InputPpobPdam(title: title);
        },
      ),
      GoRoute(
        path: '/check-taglist',
        builder: (context, state) {
          final title = state.extra as String;
          return CheckTaglistPage(title: title);
        },
      ),
      GoRoute(
        path: '/assurance',
        builder: (context, state) {
          return AssurancePage();
        },
      ),
      GoRoute(
        path: '/input-assurance',
        builder: (context, state) {
          // final text = state.extra as String;
          return InputAssurancePage(assurance: "AIA");
        },
      ),
      GoRoute(
        path: '/check-assurance',
        builder: (context, state) {
          // final text = state.extra as String;
          return CheckAssurancePage();
        },
      ),
      GoRoute(
        path: '/chart',
        builder: (context, state) {
          // final id = state.extra as int;
          return BlocProvider(
            create: (_) => sl<CartCubit>()..fetchCart(),
            child: CartPage(),
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'KAS Autocare',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: appRouter,
        );
      },
    );
  }
}

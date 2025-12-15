class ApiConstant {
  static const String baseUrl = 'https://api-clean.buitentech.co.id/api';
  static const String sentry =
      'https://93caaf5c25829d3c384c22365579ace6@o4505861416419328.ingest.us.sentry.io/4510162994659328';

  static const String product = '/branch-products';
  static const String transactions = '/transactions';
  static const String transactionsNews = '/transaction-news';
  static const String listTransactionHistory = '$transactionsNews/list';
  static const String detailTransaction = '$transactionsNews/detail';
  static const String address = '/address';
  static const String region = '/region';
  static const String auth = '/auth';

  static const String detailUser = '$auth/detail';

  static const String login = '$auth/login';
  static const String logout = '$auth/logout';
  static const String checkemail = '$auth/register/check-email';
  static const String register = '$auth/register';
  static const String sendOtp = '$auth/register/send-otp';
  static const String verifyOtp = '$auth/register/verify-otp';
  static const String sendOtpforgotPass = '$auth/forgot-password/send-otp';
  static const String verifyOtpforgotPass = '$auth/forgot-password/verify-otp';
  static const String resetPass = '$auth/forgot-password/reset';

  static const String getVehicleCust = '/transactions/get-vehicle';
  static const String createVehicleCust = '/transactions/create-vehicle';
  static const String getbranchByLocation = '/transactions/branches/nearest';
  static const String createBooking = '/transactions/booking';

  static const String listPackage = '/package-news/list';
  static const String listService = '/services-new/list';
  static const String listCity = '/winpay/city';

  static const String features = '/features';
  static const String listBrand = '/brands/list';
  static const String listModel = '/models/list';

  static const String listProduct = '$product/list';
  static const String detailProduct = '$product/detail';
  static const String addChart = '$product-transction/cart';
  static const String listChart = '$product-transction/cart/list';
  static const String deleteChart = '$product-transction/cart';
  static const String checkShipping = '$product-transction/check-price';
  static const String checkoutProduct = '$product-transction/create';
  static const String generateQRProduct = '$product-transction/qris';
  static const String generateQRService = '$transactions/payment/qris';

  static const String addAddress = '$address/create';
  static const String listAddress = '$address/list';
  static const String detailAddress = '$address/detail';
  static const String deleteAddress = '$address/delete';
  static const String updateAddress = '$address/update';
  static const String getListDistrict = '$region/district';
  static const String getListTime = '/schedule/available-slots';
}

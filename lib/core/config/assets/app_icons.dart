class AppIcons {
  static const _base = 'assets/icons';

  static String path(String name, {ImageFormater format = ImageFormater.png}) {
    return '$_base/$name.${format.name}';
  }

  static final location = path('location');
  static final homeInactive = path('home-inactive');
  static final homeActive = path('home-active');
  static final historyActive = path('history-active');
  static final historyInactive = path('history-inactive');
  static final mutasiActive = path('mutasi-active');
  static final mutasiInactive = path('mutasi-inactive');
  static final voucherInactive = path('voucher-inactive');
  static final voucherActive = path('voucher-active');
  static final profileActive = path('profile-active');
  static final profileInactive = path('profile-inactive');
  static final cartIcon = path('cart-icon');
  static final wallet = path('wallet');
  static final warningIcon = path('warning-icon');
  static final successIcon = path('success-icon');
  static final failedIcon = path('failed-icon');
}

enum ImageFormater { jpg, png, jpeg }

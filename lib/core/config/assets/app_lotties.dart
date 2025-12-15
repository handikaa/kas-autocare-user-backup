class AppLotties {
  static const _base = 'assets/lotties';

  static String path(
    String name, {
    LottieFormater format = LottieFormater.json,
  }) {
    return '$_base/$name.${format.name}';
  }

  static final loading = path('loading');
  static final failed = path('failed');
}

enum LottieFormater { json }

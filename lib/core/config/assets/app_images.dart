class AppImages {
  static const _base = 'assets/images';

  static String path(String name, {ImageFormater format = ImageFormater.png}) {
    return '$_base/$name.${format.name}';
  }

  static final logoTeks = path('teks-logo');
  static final intro1 = path('intro1');
  static final intro2 = path('intro2');
  static final intro21 = path('intro21');
  static final intro22 = path('intro22');
  static final intro23 = path('intro23');
  static final intro3 = path('intro3');
  static final carwash = path('carwash');
  static final sampel = path('sampel');
  static final qris = path('qris');
  static final baner = path('baner');
}

enum ImageFormater { jpg, png, jpeg }

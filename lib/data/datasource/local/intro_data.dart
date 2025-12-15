import '../../../core/config/assets/app_images.dart';

final List<Map<String, dynamic>> pages = [
  {
    "image": AppImages.path('intro1', format: ImageFormater.jpg),
    "title": "Ingin Mencuci Mobil",
    "desc":
        "Klin Autocare bisa membantu mobil Anda bersih berkilau kapan saja Anda membutuhkannya hanya dengan beberapa ketukan",
  },
  {
    "image": [
      AppImages.path('intro2', format: ImageFormater.jpg),
      AppImages.path('intro3', format: ImageFormater.jpg),
      AppImages.path('intro4', format: ImageFormater.jpg),
    ],
    "title": "Pilih Layanan Ideal",
    "desc":
        "Pilih dari berbagai layanan yang dirancang untuk memenuhi kebutuhan mobil Anda dengan sempurna.",
  },
  {
    "image": AppImages.path('intro6', format: ImageFormater.jpg),
    "title": "Nikmati Perjalanan Anda",
    "desc":
        "Duduk santai, rileks, dan nikmati perjalanan yang tenang di dalam mobil yang baru dibersihkan.",
  },
];

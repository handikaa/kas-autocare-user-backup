import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/assets/app_icons.dart' hide ImageFormater;
import '../../../core/config/assets/app_images.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../cubit/banner_carousel_cubit/get_list_banner_cubit.dart';
import '../../cubit/get_detail_user_cubit.dart';
import '../../cubit/notification/get_list_notification_cubit.dart';
import '../../widget/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List dataMenu = [
    {
      "title": "Layanan Cuci",
      "icon": AppIcons.path('location'),
      'route': '/service',
    },
    // {"title": "Produk", "icon": AppIcons.path('location'), 'route': '/product'},
    // {
    //   "title": "Tiket,Tagihan,\nPembayaran",
    //   "icon": AppIcons.path('location'),
    //   'route': '/ppob',
    // },
  ];

  int _currentIndex = 0;

  Future<void> onRefresh() async {
    context.read<GetDetailUserCubit>().fetchDetailUser();
    context.read<GetListBannerCubit>().execute();
    context.read<GetListNotificationCubit>().getListNotif();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.resumed) {
      // optional: supaya tidak bentrok dengan build pertama
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) onRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    double widthDevice = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.light.background,
      body: RefreshIndicator(
        backgroundColor: AppColors.light.primary,
        color: AppColors.common.white,
        onRefresh: () {
          return onRefresh();
        },
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  color: AppColors.light.primary,
                  height: heightDevice * 0.17,
                  width: widthDevice,
                ),

                Column(
                  children: [
                    BlocBuilder<
                      GetListNotificationCubit,
                      GetListNotificationState
                    >(
                      builder: (context, state) {
                        bool isNewNotif = false;

                        if (state is GetListNotifSuccess) {
                          for (var notif in state.data) {
                            if (notif.isRead == 0) {
                              isNewNotif = true;
                            }
                          }
                        }

                        return _profileAppbar(isNewNotif);
                      },
                    ),
                    AppGap.height(heightDevice * 0.01),

                    // _findNearbyCarwash(widthDevice),
                    // AppGap.height(38),
                    _bannerInformation(),

                    AppGap.height(38),
                    _menu(),
                    // AppGap.height(30),
                    // _topMerchant(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _topMerchant() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                "Merchant Unggulan Bulan Ini",
                variant: TextVariant.heading8,
                weight: TextWeight.bold,
              ),
            ],
          ),
          AppGap.height(10),
          Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MerchantCard(
                  img: AppImages.path('carwash', format: ImageFormater.jpg),
                  rating: 3.2,
                  text: "Carwash Cilebut",
                  type: '',
                  isOpen: false,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _profileAppbar(bool isNewNotif) {
    return Padding(
      padding: AppPadding.all(16),
      child: BlocBuilder<GetDetailUserCubit, GetDetailUserState>(
        builder: (context, state) {
          if (state is GetDetailUserLoading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.common.white,
                      child: AppIcon(
                        size: 32,
                        color: AppColors.light.primary,
                        icon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "----",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Selamat Datang Kembali",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
          if (state is GetDetailUserError) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  state.message,
                  variant: TextVariant.heading7,
                  weight: TextWeight.semiBold,
                  color: AppColors.light.error,
                ),
              ],
            );
          }
          if (state is GetDetailUserLoading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  "Loading",
                  variant: TextVariant.heading7,
                  weight: TextWeight.semiBold,
                  color: AppColors.light.error,
                ),
              ],
            );
          }

          if (state is GetDetailUserSuccess) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.common.white,
                      child: AppIcon(
                        size: 32,
                        color: AppColors.light.primary,
                        icon: Icons.person,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.data.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Selamat Datang Kembali",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    var res = await context.push('/notification');

                    if (res == null) {
                      context.read<GetListNotificationCubit>().getListNotif();
                    }
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.common.white,
                        child: Icon(
                          Icons.notifications,
                          color: AppColors.light.primary,
                        ),
                      ),
                      if (isNewNotif)
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: AppColors.light.error,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _bannerInformation() {
    return BlocBuilder<GetListBannerCubit, GetListBannerState>(
      builder: (context, state) {
        if (state is GetListBannerLoading) {
          return _shimmerCarouselLoading();
        }
        if (state is GetListBannerError) {
          return _carouselError(message: state.message, onRetry: () {});
        }

        if (state is GetListBannerSuccess) {
          var data = state.data;

          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 170,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: data.map((banner) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(banner.image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              AppGap.height(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(data.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 20 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.light.primary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }),
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget _carouselError({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 28,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Coba lagi'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = index == 0;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 20 : 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _shimmerCarouselLoading() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 170,
              autoPlay: false,

              enlargeCenterPage: false,
              viewportFraction: 0.9,
            ),
            items: [
              Builder(
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 5),
                        ),
                      ],
                      color: Colors.white, // penting: shimmer butuh color solid
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _menu() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(dataMenu.length, (index) {
        var data = dataMenu[index];
        return GestureDetector(
          onTap: () {
            context.push(data['route']);
          },
          child: Column(
            children: [
              AppIconImage(data['icon'], width: 58),
              AppGap.height(10),
              AppText(
                data['title'],
                variant: TextVariant.body3,
                weight: TextWeight.medium,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _findNearbyCarwash(double widthDevice) {
    return Padding(
      padding: AppPadding.horizontal(16),
      child: AppBox(
        color: AppColors.common.white,
        height: 60,
        width: widthDevice,
        borderRadius: 16,
        child: Row(
          children: [
            Row(
              children: [
                AppGap.width(10),
                AppIconImage(AppIcons.path('location'), width: 40),
                AppGap.width(10),
                AppText(
                  "Cari Carwash Terdekat .....",
                  variant: TextVariant.body1,
                  weight: TextWeight.medium,
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 20),
            AppGap.width(10),
          ],
        ),
      ),
    );
  }
}

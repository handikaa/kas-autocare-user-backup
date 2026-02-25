import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/inject/depedency_injection.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../cubit/banner_carousel_cubit/get_list_banner_cubit.dart';
import '../../cubit/get_detail_user_cubit.dart';
import '../../cubit/list_history_cubit.dart';
import '../../cubit/logout_cubit.dart';
import '../../cubit/notification/get_list_notification_cubit.dart';
import '../../cubit/notification/save_fcm_cubit.dart';
import '../history/history_page.dart';
import '../home_page/home_page.dart';
import '../profile/profile_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  final pageController = PageController();

  late final SaveFcmCubit _saveFcmCubit;

  @override
  void initState() {
    super.initState();
    _saveFcmCubit = sl<SaveFcmCubit>();
    _saveFcmCubit.saveFcm();
  }

  @override
  void dispose() {
    _saveFcmCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<GetDetailUserCubit>()..fetchDetailUser(),
        ),

        BlocProvider(create: (_) => sl<GetListBannerCubit>()..execute()),
        BlocProvider(
          create: (_) => sl<GetListNotificationCubit>()..getListNotif(),
        ),
        BlocProvider(create: (_) => sl<ListHistoryCubit>()),
        BlocProvider(create: (_) => sl<LogoutCubit>()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            children: [
              HomePage(),

              HistoryPage(),

              // VoucherPage(),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: StylishBottomBar(
            items: [
              BottomBarItem(
                icon: Image.asset(AppIcons.homeInactive),
                selectedIcon: Image.asset(AppIcons.homeActive),
                title: const Text('Beranda'),
                selectedColor: AppColors.light.primary,
                badgePadding: const EdgeInsets.only(left: 4, right: 4),
              ),
              BottomBarItem(
                icon: Image.asset(AppIcons.historyInactive),
                selectedIcon: Image.asset(AppIcons.historyActive),
                title: const Text('Riwayat'),
                selectedColor: AppColors.light.primary,
                badgePadding: const EdgeInsets.only(left: 4, right: 4),
              ),

              // BottomBarItem(
              //   icon: Image.asset(AppIcons.voucherInactive),
              //   selectedIcon: Image.asset(AppIcons.voucherActive),
              //   title: const Text('Voucher'),
              //   selectedColor: AppColors.light.primary,
              //   badgePadding: const EdgeInsets.only(left: 4, right: 4),
              // ),
              BottomBarItem(
                icon: Image.asset(AppIcons.profileInactive),
                selectedIcon: Image.asset(AppIcons.profileActive),
                title: const Text('Profile'),
                selectedColor: AppColors.light.primary,
                badgePadding: const EdgeInsets.only(left: 4, right: 4),
              ),
            ],
            option: AnimatedBarOptions(iconStyle: IconStyle.Default),
            hasNotch: false,

            currentIndex: selectedIndex,
            notchStyle: NotchStyle.square,
            onTap: (index) {
              if (index == selectedIndex) return;
              pageController.jumpToPage(index);
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

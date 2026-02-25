import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../cubit/get_detail_user_cubit.dart';
import '../../cubit/logout_cubit.dart';
import '../../widget/bottomsheet/wording_bottomsheet.dart';
import '../../widget/widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void showWordingLogout() {
    AppBottomSheets.showConfirmationBottomSheet(
      context,
      title: "Apakah anda yakin ingin keluar aplikasi?",
      message: '',
      onConfirm: () {
        context.read<LogoutCubit>().logout();
      },
    );
  }

  void _openContactSupport() async {
    final Uri url = Uri.parse("https://wa.link/4ktg8p");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.background,
      bottomNavigationBar: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            context.go('/login');
          }
          if (state is LogoutError) {
            context.pop();

            showAppSnackBar(
              context,
              message: state.message,
              type: SnackType.error,
            );
          }

          if (state is LogoutLoading) {
            AppDialog.loading(context);
          }
        },

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: AppElevatedButton(
                    text: "Keluar",
                    onPressed: () => showWordingLogout(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: AppColors.light.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AppText(
                      "Profile",
                      variant: TextVariant.heading7,
                      weight: TextWeight.bold,
                      color: AppColors.common.white,
                    ),
                  ],
                ),
                AppGap.height(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.common.white,
                      child: AppIcon(
                        size: 32,
                        color: AppColors.light.primary,
                        icon: Icons.person,
                      ),
                    ),
                  ],
                ),
                AppGap.height(16),
                BlocBuilder<GetDetailUserCubit, GetDetailUserState>(
                  builder: (context, state) {
                    if (state is GetDetailUserLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            "--",
                            variant: TextVariant.heading7,
                            weight: TextWeight.semiBold,
                            color: AppColors.common.white,
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

                    if (state is GetDetailUserSuccess) {
                      final data = state.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            data.name,
                            variant: TextVariant.heading7,
                            weight: TextWeight.semiBold,
                            color: AppColors.common.white,
                          ),
                        ],
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.light.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  "0 Poin Yang Tersedia",
                  variant: TextVariant.body1,
                  weight: TextWeight.bold,
                  color: AppColors.common.white,
                ),
              ],
            ),
          ),

          CardMenuProfile(
            ontap: () {
              context.push('/list-address');
            },
            title: 'Alamat Pengiriman',
          ),
          AppGap.height(12),
          CardMenuProfile(
            ontap: () {
              _openContactSupport();
              //
            },
            title: 'Kontak Support',
          ),
        ],
      ),
    );
  }
}

class CardMenuProfile extends StatelessWidget {
  const CardMenuProfile({super.key, required this.ontap, required this.title});

  final VoidCallback ontap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18),

        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
          color: AppColors.common.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AppText(
              title,
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
            Spacer(),
            AppIcon(
              icon: Icons.arrow_forward_ios_sharp,
              color: AppColors.common.grey400,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../icon/app_icon.dart';
import '../text/app_text.dart';

class AppbarScreen extends StatelessWidget {
  const AppbarScreen({
    super.key,
    this.textAppbar,
    required this.body,
    this.isScrolled = true,
    this.hideAppbar = false,
    this.bottomNavigationBar,
  });

  final String? textAppbar;
  final Widget? bottomNavigationBar;
  final List<Widget> body;
  final bool isScrolled;
  final bool hideAppbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: AppColors.common.white,
      appBar: hideAppbar
          ? null
          : AppBar(
              backgroundColor: AppColors.common.white,
              leadingWidth: MediaQuery.of(context).size.width * 0.3,
              leading: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),

                    icon: AppIcon(
                      icon: Icons.arrow_back_ios_new,
                      color: AppColors.common.black,
                      size: 20,
                    ),
                  ),
                  AppText(
                    "Kembali",
                    variant: TextVariant.body1,
                    weight: TextWeight.semiBold,
                  ),
                ],
              ),
            ),

      body: isScrolled == true
          ? ListView(children: body)
          : Column(children: body),
    );
  }
}

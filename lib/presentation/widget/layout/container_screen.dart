import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../widget.dart';

class ContainerScreen extends StatelessWidget {
  final String title;
  final bool hideBackButton;
  final bool hideAppbar;
  final List<Widget> body;
  final Widget? rightButton;
  final Color? bgColor;
  final bool usePadding;
  final Widget? bottomNavigationBar;
  final bool scrollable;
  final VoidCallback? ontap;

  const ContainerScreen({
    super.key,
    required this.title,
    required this.scrollable,
    required this.body,
    this.hideBackButton = false,
    this.hideAppbar = false,
    this.rightButton,
    this.bgColor,
    this.usePadding = true,
    this.bottomNavigationBar,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.primary,
      appBar: hideAppbar
          ? null
          : PreferredSize(
              preferredSize: const Size(double.infinity, 70),
              child: SafeArea(
                child: appBar(
                  context: context,
                  title: title,
                  hideBackButton: hideBackButton,
                  rightButton: rightButton,
                ),
              ),
            ),
      body: Container(
        padding: usePadding
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 15)
            : EdgeInsets.zero,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.light.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: scrollable
            ? ListView(physics: const BouncingScrollPhysics(), children: body)
            : Column(children: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget appBar({
    required String title,
    bool hideBackButton = false,
    Widget? rightButton,
    Color? buttonColor,
    required BuildContext context,
  }) {
    return Container(
      height: kToolbarHeight + 10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!hideBackButton)
                GestureDetector(
                  onTap: ontap ?? () => context.pop(),
                  child: const AppIcon(icon: Icons.arrow_back_ios_new),
                ),
              if (!hideBackButton) AppGap.width(12),
              AppText(
                title,
                variant: TextVariant.heading8,
                weight: TextWeight.bold,
                color: AppColors.common.white,
              ),
            ],
          ),

          rightButton ?? const SizedBox(width: 24),
        ],
      ),
    );
  }
}

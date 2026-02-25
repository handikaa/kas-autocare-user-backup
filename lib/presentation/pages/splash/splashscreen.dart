import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/assets/app_images.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

import '../../cubit/splash_cubit.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().start();
      context.read<SplashCubit>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashStatus>(
      listener: (context, state) {
        if (state == SplashStatus.intro) {
          context.go('/intro');
        } else if (state == SplashStatus.login) {
          context.go('/login');
        } else if (state == SplashStatus.home) {
          context.go('/dashboard');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.common.white,
        body: Center(child: Image.asset(AppImages.logoTeks, width: 300)),
      ),
    );
  }
}

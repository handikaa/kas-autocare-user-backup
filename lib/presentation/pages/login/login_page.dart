import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/utils/app_dialog.dart';
import 'package:kas_autocare_user/data/params/login_params.dart';
import 'package:kas_autocare_user/presentation/cubit/login_cubit.dart';
import 'package:kas_autocare_user/presentation/widget/bottomsheet/wording_bottomsheet.dart';

import '../../../core/config/assets/app_images.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../widget/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObsecure = true;
  bool _isFormValid = false;

  void toogleIsObsecure() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        _nameController.text.length >= 6 &&
        _passwordController.text.length >= 6;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void doLogin() async {
    LoginParams payload = LoginParams(
      username: _nameController.text,
      password: _passwordController.text,
    );

    context.read<LoginCubit>().doLogin(payload: payload);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          AppDialog.loading(context);
        }

        if (state is LoginError) {
          context.pop();
          AppBottomSheets.showErrorBottomSheet(
            context,
            title: "Login Gagal",
            message: state.message,
          );
        }

        if (state is LoginComplete) {
          context.go('/dashboard');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.common.white,
          body: Padding(
            padding: AppPadding.all(16),
            child: ListView(
              children: [
                AppGap.height(80),
                Image.asset(AppImages.logoTeks, width: 250),
                AppGap.height(80),

                AppTextFormField(
                  label: "Email",
                  hintText: "Email",
                  controller: _nameController,
                ),
                AppGap.height(20),

                AppTextFormField(
                  label: "Kata Sandi",
                  hintText: "Kata Sandi",
                  controller: _passwordController,
                  isPassword: true,
                  isObsecure: _isObsecure,
                  onToggleObsecure: toogleIsObsecure,
                  maxLines: 1,
                ),
                AppGap.height(20),
                InkWell(
                  onTap: () =>
                      context.push('/register-input-email', extra: 'forgot'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(
                        "Lupa Kata Sandi?",
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                      ),
                    ],
                  ),
                ),
                AppGap.height(45),
                Row(
                  children: [
                    Expanded(
                      child: AppElevatedButton(
                        text: "Masuk",
                        onPressed: _isFormValid
                            ? () {
                                doLogin();
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                AppGap.height(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      "Kamu Belum Mempunyai akun? ",
                      variant: TextVariant.body2,
                      weight: TextWeight.medium,
                    ),
                    InkWell(
                      onTap: () => context.push(
                        '/register-input-email',
                        extra: 'regist',
                      ),
                      child: AppText(
                        " Daftar",
                        color: AppColors.light.primary,
                        variant: TextVariant.body2,
                        weight: TextWeight.medium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

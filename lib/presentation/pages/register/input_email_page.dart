import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/utils/app_dialog.dart';
import 'package:kas_autocare_user/core/utils/app_snackbar.dart';
import 'package:kas_autocare_user/presentation/cubit/forgot_pass_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/register_cubit.dart';

import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_validator.dart';
import '../../widget/layout/appbar_screen.dart';
import '../../widget/widget.dart';

class InputEmailPage extends StatefulWidget {
  const InputEmailPage({super.key, required this.type});

  final String type;

  @override
  State<InputEmailPage> createState() => _InputEmailPageState();
}

class _InputEmailPageState extends State<InputEmailPage> {
  final TextEditingController _emailC = TextEditingController();

  bool isValid = false;
  final _formKey = GlobalKey<FormState>();

  void checkFormValid() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      isValid = isFormValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'forgot') {
      return _buildForgotPage(context);
    } else {
      return _buildRegisterPage(context);
    }
  }

  Widget _buildRegisterPage(BuildContext context) {
    return AppbarScreen(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: AppElevatedButton(
                  text: "Kirim Kode Verifikasi",
                  onPressed: isValid
                      ? () {
                          context.read<RegisterCubit>().checkEmail(
                            email: _emailC.text,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
      body: [
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterCheckEmailLoading) {
              return AppDialog.loading(context);
            }
            if (state is RegisterCheckEmailError) {
              context.pop();
              return showAppSnackBar(
                context,
                message: state.message,
                type: SnackType.error,
              );
            }

            if (state is RegisterCheckEmailLoaded) {
              if (state.isAvailable == false) {
                context.pop();
                return showAppSnackBar(
                  context,
                  message: "Email sudah terdaftar di akun lain",
                  type: SnackType.error,
                );
              } else {
                context.pop();
                context.push(
                  '/register-input-otp',
                  extra: {"email": _emailC.text, "type": 'regist'},
                );
              }
            }
          },
          child: Column(
            children: [
              AppGap.height(40),
              AppText(
                "Masukan Email",
                variant: TextVariant.heading7,
                weight: TextWeight.bold,
              ),
              AppGap.height(20),
              AppText(
                "Masukan email untuk melakukan pendaftaran",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),

              AppGap.height(20),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: AppTextFormField(
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Masukan email",
                    controller: _emailC,
                    validator: AppValidator.validateEmail,
                    onChanged: (value) {
                      checkFormValid();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppbarScreen _buildForgotPage(BuildContext context) {
    return AppbarScreen(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: AppElevatedButton(
                  text: "Kirim Kode Verifikasi",
                  onPressed: isValid
                      ? () {
                          context.read<ForgotPassCubit>().sendOtp(
                            email: _emailC.text,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
      body: [
        BlocListener<ForgotPassCubit, ForgotPassState>(
          listener: (context, state) {
            if (state is SendForgotLoading) {
              return AppDialog.loading(context);
            }
            if (state is SendForgotError) {
              context.pop();
              return showAppSnackBar(
                context,
                message: state.message,
                type: SnackType.error,
              );
            }

            if (state is SendForgotSuccess) {
              context.pop();
              context.push(
                '/register-input-otp',
                extra: {"email": _emailC.text, "type": 'forgot'},
              );
            }
          },
          child: Column(
            children: [
              AppGap.height(40),
              AppText(
                "Masukan Email",
                variant: TextVariant.heading7,
                weight: TextWeight.bold,
              ),
              AppGap.height(20),
              AppText(
                "Masukan email untuk mengganti password",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),

              AppGap.height(20),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: AppTextFormField(
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Masukan email",
                    controller: _emailC,
                    validator: AppValidator.validateEmail,
                    onChanged: (value) {
                      checkFormValid();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

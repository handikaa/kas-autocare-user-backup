import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/core/utils/app_dialog.dart';
import 'package:kas_autocare_user/core/utils/app_snackbar.dart';
import 'package:kas_autocare_user/presentation/cubit/forgot_pass_cubit.dart';
import 'package:kas_autocare_user/presentation/widget/button/app_elevated_button.dart';
import 'package:kas_autocare_user/presentation/widget/layout/appbar_screen.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';

import '../../widget/form/app_text_form.dart';
import '../../widget/layout/spacing.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _confirmPassC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObsecure = true;
  bool _isObsecureConfirmPass = true;
  bool _isValid = false;

  String? passwordError;
  String? confirmPasswordError;

  void toogleIsObsecure() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }

  void toogleIsObsecureConfirmPass() {
    setState(() {
      _isObsecureConfirmPass = !_isObsecureConfirmPass;
    });
  }

  void checkFormValid({required bool fromPasswordField}) {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
      _isValid = false;
    });

    final pass = _passwordC.text.trim();
    final confirm = _confirmPassC.text.trim();

    if (pass.isNotEmpty && pass.length < 8) {
      setState(() {
        passwordError = "Password minimal 8 karakter";
      });
    }

    if (confirm.isNotEmpty && confirm.length < 8) {
      setState(() {
        confirmPasswordError = "Password minimal 8 karakter";
      });
    }

    if (pass.isNotEmpty &&
        confirm.isNotEmpty &&
        pass.length >= 8 &&
        confirm.length >= 8 &&
        pass != confirm) {
      setState(() {
        passwordError = "Password tidak sama";
        confirmPasswordError = "Password tidak sama";
      });
    }

    final passwordLengthValid = pass.length >= 8 && confirm.length >= 8;
    final passwordMatch = pass == confirm;

    setState(() {
      _isValid = passwordLengthValid && passwordMatch;
    });

    _formKey.currentState?.validate();
  }

  void doReset() {
    context.read<ForgotPassCubit>().passwordReset(
      email: widget.email,
      pass: _passwordC.text,
      confirmPass: _confirmPassC.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPassCubit, ForgotPassState>(
      listener: (context, state) {
        if (state is ForgotPassLoading) {
          AppDialog.loading(context);
        }
        if (state is ForgotPassError) {
          context.pop();
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
        if (state is ForgotPassSuccess) {
          context.pop();
          showAppSnackBar(
            context,
            message: "Berhasil Mengubah Password, Silahkan Login",
            type: SnackType.success,
          );
          context.go('/login');
        }
      },
      child: AppbarScreen(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: AppElevatedButton(
                    text: "Reset Password",
                    onPressed: _isValid
                        ? () {
                            doReset();
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: [
          AppGap.height(40),
          AppText(
            "Reset ulang password",
            variant: TextVariant.heading7,
            weight: TextWeight.bold,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                AppGap.height(30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppGap.height(10),
                      AppTextFormField(
                        label: "Kata Sandi",
                        hintText: "Kata Sandi",
                        controller: _passwordC,
                        isPassword: true,
                        isObsecure: _isObsecure,
                        onToggleObsecure: toogleIsObsecure,
                        maxLines: 1,
                        isRequired: true,
                        validator: (p0) {
                          if (passwordError != null) {
                            return passwordError;
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            checkFormValid(fromPasswordField: true),
                      ),

                      AppGap.height(10),
                      AppTextFormField(
                        label: "Konfirmasi Kata Sandi",
                        hintText: "Konfirmasi  Kata Sandi",
                        controller: _confirmPassC,
                        isPassword: true,
                        isObsecure: _isObsecureConfirmPass,
                        onToggleObsecure: toogleIsObsecureConfirmPass,
                        maxLines: 1,
                        isRequired: true,
                        validator: (p0) {
                          if (confirmPasswordError != null) {
                            return confirmPasswordError;
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            checkFormValid(fromPasswordField: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

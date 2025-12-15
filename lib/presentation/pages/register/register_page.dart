import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/utils/app_dialog.dart';
import 'package:kas_autocare_user/core/utils/app_snackbar.dart';
import 'package:kas_autocare_user/core/utils/share_method.dart';
import 'package:kas_autocare_user/data/params/register_payload.dart';
import 'package:kas_autocare_user/presentation/cubit/register_cubit.dart';
import 'package:kas_autocare_user/presentation/widget/layout/appbar_screen.dart';

import '../../../core/config/theme/app_text_style.dart';
import '../../widget/widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.email, required this.otpCode});
  final String email;
  final String otpCode;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _userNameC = TextEditingController();
  final TextEditingController _phoneNumberC = TextEditingController();
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

  void checkFormValid({required bool fromPasswordField}) {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
    });

    final pass = _passwordC.text.trim();
    final confirm = _confirmPassC.text.trim();

    if (fromPasswordField) {
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
    }

    final allFilled =
        _emailC.text.isNotEmpty &&
        _nameC.text.isNotEmpty &&
        _userNameC.text.isNotEmpty &&
        pass.isNotEmpty &&
        confirm.isNotEmpty;

    final passwordLengthValid = pass.length >= 8 && confirm.length >= 8;
    final passwordMatch = pass == confirm;

    setState(() {
      _isValid = allFilled && passwordLengthValid && passwordMatch;
    });

    _formKey.currentState?.validate();
  }

  void doRegister() {
    RegisterPayload payload = RegisterPayload(
      name: _nameC.text,
      username: _userNameC.text,
      phone: _phoneNumberC.text,
      email: widget.email,
      password: _passwordC.text,
      passwordConfirmation: _confirmPassC.text,
      otp: widget.otpCode,
    );

    context.read<RegisterCubit>().registerUser(payload);
  }

  void toogleIsObsecureConfirmPass() {
    setState(() {
      _isObsecureConfirmPass = !_isObsecureConfirmPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _emailC.text = widget.email;
    });

    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterlLoading) {
          AppDialog.loading(context);
        }
        if (state is RegisterlError) {
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
        if (state is RegisterlLoaded) {
          showAppSnackBar(
            context,
            message: "Berhasil Mendaftar, Silahkan Login",
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
                    text: "Daftar",
                    onPressed: _isValid
                        ? () {
                            doRegister();
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
            "Register akun baru",
            variant: TextVariant.heading7,
            weight: TextWeight.bold,
          ),
          AppGap.height(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: AppText(
              "Bergabung bersama kami di KAS, dan nikmati semua kemudahannya",
              maxLines: 3,
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                AppGap.height(30),
                AppTextFormField(
                  label: "Nama",
                  hintText: "Masukan nama anda",
                  controller: _nameC,
                  isRequired: true,
                  onChanged: (value) =>
                      checkFormValid(fromPasswordField: false),
                ),

                AppGap.height(10),
                AppTextFormField(
                  label: "Username",
                  hintText: "Masukan username anda",
                  controller: _userNameC,
                  isRequired: true,
                  onChanged: (value) =>
                      checkFormValid(fromPasswordField: false),
                ),

                AppGap.height(10),
                AppTextFormField(
                  label: "Nomor HP",
                  hintText: "Masukan nomor hp anda",
                  controller: _phoneNumberC,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NoInvalidPasteFormatter(),
                  ],
                  onChanged: (value) =>
                      checkFormValid(fromPasswordField: false),
                ),

                AppGap.height(10),
                AppTextFormField(
                  label: "Email",
                  hintText: "Masukan email anda",
                  controller: _emailC,
                  readOnly: true,
                  isRequired: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NoInvalidPasteFormatter(),
                  ],
                ),

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

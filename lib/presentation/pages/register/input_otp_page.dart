import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/presentation/cubit/forgot_pass_cubit.dart';
import 'package:pinput/pinput.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/share_method.dart';
import '../../cubit/verify_otp_cubit.dart';
import '../../widget/layout/appbar_screen.dart';
import '../../widget/widget.dart';

class InputOtpPage extends StatefulWidget {
  final String email;
  final String type;

  const InputOtpPage({super.key, required this.email, required this.type});

  @override
  State<InputOtpPage> createState() => _InputOtpPageState();
}

class _InputOtpPageState extends State<InputOtpPage> {
  final TextEditingController _otpC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? otpError;

  int countdown = 0;
  Timer? timer;

  void startCountdown() {
    setState(() => countdown = 120);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
      } else {
        setState(() => countdown--);
      }
    });

    context.read<VerifyOtpCubit>().sendOtp(email: widget.email);
    print("Mengirim ulang kode OTP...");
  }

  void startCountdownForgot() {
    setState(() => countdown = 120);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
      } else {
        setState(() => countdown--);
      }
    });

    context.read<ForgotPassCubit>().sendOtp(email: widget.email);
    print("Mengirim ulang kode OTP...");
  }

  void _closeDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.type == 'forgot') {
      setState(() => countdown = 120);

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown == 0) {
          timer.cancel();
        } else {
          setState(() => countdown--);
        }
      });
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   context.read<ForgotPassCubit>().sendOtp(email: widget.email);
      // });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<VerifyOtpCubit>().sendOtp(email: widget.email);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 90,
      height: 70,
      textStyle: TextStyle(
        fontSize: 24,
        color: AppColors.common.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.light.primary30,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.common.black, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
    );

    if (widget.type == 'forgot') {
      return _buildInputOtpForgot(
        defaultPinTheme,
        focusedPinTheme,
        errorPinTheme,
        context,
      );
    } else {
      return _buildInputOtpRegist(
        defaultPinTheme,
        focusedPinTheme,
        errorPinTheme,
        context,
      );
    }
  }

  Widget _buildInputOtpForgot(
    PinTheme defaultPinTheme,
    PinTheme focusedPinTheme,
    PinTheme errorPinTheme,
    BuildContext context,
  ) {
    return BlocListener<ForgotPassCubit, ForgotPassState>(
      listener: (context, state) {
        if (state is ForgotPassLoading) {
          AppDialog.loading(context);
        }
        if (state is SendForgotLoading) {
          AppDialog.loading(context);
        }

        if (state is ForgotPassError) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
        if (state is SendForgotError) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }

        if (state is SendForgotSuccess) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.success,
          );

          context.push('/reset-password', extra: widget.email);
        }
        if (state is ForgotPassSuccess) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.success,
          );

          context.push('/reset-password', extra: widget.email);
        }
      },
      child: AppbarScreen(
        body: [
          AppGap.height(40),
          AppText(
            "Verifikasi Kode",
            variant: TextVariant.heading7,
            weight: TextWeight.bold,
          ),
          AppGap.height(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: AppText(
              "Kode Verifikasi dikirim ke Email anda ${widget.email}",
              maxLines: 3,
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ),

          AppGap.height(20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Pinput(
                controller: _otpC,
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,

                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                showCursor: true,

                preFilledWidget: AppText(
                  '-',
                  variant: TextVariant.body3,
                  weight: TextWeight.medium,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  NoInvalidPasteFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return "Kode harus 6 digit";
                  }
                  if (otpError != null) {
                    return otpError;
                  }
                  return null;
                },

                onCompleted: (code) {
                  context.read<ForgotPassCubit>().verifyOtp(
                    email: widget.email,
                    code: code,
                  );
                },
              ),
            ),
          ),

          AppGap.height(20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                "Belum dapat kode verifikasi ?",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
              InkWell(
                onTap: countdown == 0
                    ? () {
                        startCountdownForgot();
                      }
                    : null,
                child: AppText(
                  countdown == 0 ? " Kirim Lagi" : " ${countdown}s",
                  variant: TextVariant.body2,
                  weight: TextWeight.semiBold,
                  color: countdown == 0
                      ? AppColors.light.darkprimary
                      : AppColors.common.grey400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputOtpRegist(
    PinTheme defaultPinTheme,
    PinTheme focusedPinTheme,
    PinTheme errorPinTheme,
    BuildContext context,
  ) {
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is SendOtpLoading) {
          AppDialog.loading(context);
        }
        if (state is VerifyOTPLoading) {
          AppDialog.loading(context);
        }

        if (state is SendOtpError) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
        if (state is VerifyOTPError) {
          _closeDialog(context);
          setState(() {
            otpError = state.message;
          });

          _formKey.currentState!.validate();
          // showAppSnackBar(
          //   context,
          //   message: state.message,
          //   type: SnackType.error,
          // );
        }
        if (state is VerifyOTPSuccess) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.success,
          );

          context.push(
            '/register',
            extra: {"email": widget.email, "otp": _otpC.text},
          );
        }

        if (state is SendOtpLoaded) {
          _closeDialog(context);
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.success,
          );
        }
      },
      child: AppbarScreen(
        body: [
          AppGap.height(40),
          AppText(
            "Verifikasi Kode",
            variant: TextVariant.heading7,
            weight: TextWeight.bold,
          ),
          AppGap.height(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: AppText(
              "Kode Verifikasi dikirim ke Email anda ${widget.email}",
              maxLines: 3,
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ),

          AppGap.height(20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Pinput(
                controller: _otpC,
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,

                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                showCursor: true,

                preFilledWidget: AppText(
                  '-',
                  variant: TextVariant.body3,
                  weight: TextWeight.medium,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  NoInvalidPasteFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return "Kode harus 6 digit";
                  }
                  if (otpError != null) {
                    return otpError;
                  }
                  return null;
                },

                onCompleted: (code) {
                  context.read<VerifyOtpCubit>().verifyOtp(
                    email: widget.email,
                    code: code,
                  );
                },
              ),
            ),
          ),

          AppGap.height(20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                "Belum dapat kode verifikasi ?",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
              InkWell(
                onTap: countdown == 0
                    ? () {
                        startCountdown();
                      }
                    : null,
                child: AppText(
                  countdown == 0 ? " Kirim Lagi" : " ${countdown}s",
                  variant: TextVariant.body2,
                  weight: TextWeight.semiBold,
                  color: countdown == 0
                      ? AppColors.light.darkprimary
                      : AppColors.common.grey400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

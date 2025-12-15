import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../config/assets/app_lotties.dart';

class AppDialog {
  static void loading(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DialogBase(
        lottieAsset: AppLotties.loading,
        title: "Mohon Tunggu",
        message: message,
      ),
    );
  }

  static void success(
    BuildContext context, {
    String title = "Berhasil",
    String message = "Aksi berhasil dilakukan",
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DialogBase(
        lottieAsset: 'assets/lottie/success.json',
        title: title,
        message: message,
        onClose: onClose,
      ),
    );
  }

  static void error(
    BuildContext context, {
    String title = "Gagal",
    String message = "Terjadi kesalahan",
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DialogBase(
        lottieAsset: 'assets/lottie/error.json',
        title: title,
        message: message,
        onClose: onClose,
      ),
    );
  }

  static void close(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}

class _DialogBase extends StatelessWidget {
  final String lottieAsset;
  final String title;
  final String message;
  final VoidCallback? onClose;

  const _DialogBase({
    required this.lottieAsset,
    required this.title,
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(lottieAsset, height: 100, repeat: true),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (onClose != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onClose?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("OK"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

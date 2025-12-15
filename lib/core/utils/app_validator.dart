class AppValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email tidak boleh kosong";

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (!emailRegex.hasMatch(value)) {
      return "Alamat email tidak valid";
    }

    return null;
  }

  static String? validateRequired(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? "Field ini tidak boleh kosong";
    }
    return null;
  }
}

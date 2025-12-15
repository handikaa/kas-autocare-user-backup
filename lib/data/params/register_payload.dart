import 'dart:convert';

String registerPayloadToJson(RegisterPayload data) =>
    json.encode(data.toJson());

class RegisterPayload {
  final String name;
  final String username;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;

  final String otp;

  RegisterPayload({
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "phone": phone,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
    "role": "customer",
    "otp": otp,
  };
}

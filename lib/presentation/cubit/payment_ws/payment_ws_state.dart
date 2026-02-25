part of 'payment_ws_cubit.dart';

enum PaymentWsStatus { idle, connecting, waiting, paid, failed, error }

class PaymentWsState extends Equatable {
  final PaymentWsStatus status;
  final String reference;
  final String channel;
  final String connState; // optional debug
  final Map<String, dynamic>? payload;
  final String? error;

  const PaymentWsState({
    required this.status,
    required this.reference,
    required this.channel,
    this.connState = '-',
    this.payload,
    this.error,
  });

  factory PaymentWsState.idle() => const PaymentWsState(
    status: PaymentWsStatus.idle,
    reference: '',
    channel: '',
  );

  PaymentWsState copyWith({
    PaymentWsStatus? status,
    String? reference,
    String? channel,
    String? connState,
    Map<String, dynamic>? payload,
    String? error,
    bool clearError = false,
  }) {
    return PaymentWsState(
      status: status ?? this.status,
      reference: reference ?? this.reference,
      channel: channel ?? this.channel,
      connState: connState ?? this.connState,
      payload: payload ?? this.payload,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    status,
    reference,
    channel,
    connState,
    payload,
    error,
  ];
}

import 'package:equatable/equatable.dart';

class TimeEntity extends Equatable {
  final String time;
  final String timeFormatted;
  final bool available;
  final String status;
  final String colorCode;

  const TimeEntity({
    required this.time,
    required this.timeFormatted,
    required this.available,
    required this.status,
    required this.colorCode,
  });

  @override
  List<Object?> get props => [
    time,
    timeFormatted,
    available,
    status,
    colorCode,
  ];
}

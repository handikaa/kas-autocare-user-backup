import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../widget.dart';

class BaseDatePickerBottomSheet extends StatefulWidget {
  final Function(DateTime selectedDate)? onApply;

  const BaseDatePickerBottomSheet({super.key, this.onApply});

  @override
  State<BaseDatePickerBottomSheet> createState() =>
      _BaseDatePickerBottomSheetState();
}

class _BaseDatePickerBottomSheetState extends State<BaseDatePickerBottomSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late int _selectedYear;
  late int _selectedMonth;

  late final DateTime _firstAllowedDay;
  late final DateTime _lastAllowedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;

    _firstAllowedDay = DateTime(now.year, now.month, now.day);

    final nextMonth = DateTime(now.year, now.month + 1, 1);
    _lastAllowedDay = DateTime(nextMonth.year, nextMonth.month + 1, 0);
  }

  void _onApply() {
    if (_selectedDay != null) {
      widget.onApply?.call(_selectedDay!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<int>(
                      value: _selectedYear,
                      dropdownColor: AppColors.common.white,
                      style: TextStyle(color: AppColors.common.black),
                      iconEnabledColor: AppColors.common.black,
                      onChanged: (val) {},
                      items: [
                        DropdownMenuItem<int>(
                          value: now.year,
                          child: Text(
                            now.year.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: _canGoToPreviousMonth()
                                ? AppColors.common.black
                                : AppColors.common.grey400,
                          ),
                          onPressed: _canGoToPreviousMonth()
                              ? () {
                                  setState(() {
                                    _selectedMonth--;
                                    if (_selectedMonth < 1) {
                                      _selectedMonth = 12;
                                      _selectedYear--;
                                    }
                                    final newFocused = DateTime(
                                      _selectedYear,
                                      _selectedMonth,
                                      1,
                                    );

                                    _focusedDay =
                                        newFocused.isBefore(_firstAllowedDay)
                                        ? _firstAllowedDay
                                        : newFocused;
                                  });
                                }
                              : null,
                        ),
                        AppText(
                          DateFormat.MMMM(
                            'id_ID',
                          ).format(DateTime(_selectedYear, _selectedMonth)),
                          variant: TextVariant.body2,
                          weight: TextWeight.bold,
                        ),

                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: _canGoToNextMonth()
                                ? AppColors.common.black
                                : AppColors.common.grey400,
                          ),
                          onPressed: _canGoToNextMonth()
                              ? () {
                                  setState(() {
                                    _selectedMonth++;
                                    if (_selectedMonth > 12) {
                                      _selectedMonth = 1;
                                      _selectedYear++;
                                    }
                                    final newFocused = DateTime(
                                      _selectedYear,
                                      _selectedMonth,
                                      1,
                                    );

                                    _focusedDay =
                                        newFocused.isAfter(_lastAllowedDay)
                                        ? _lastAllowedDay
                                        : newFocused;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: _firstAllowedDay,
                  lastDay: _lastAllowedDay,
                  locale: 'id_ID',
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (selectedDay.isBefore(_firstAllowedDay) ||
                        selectedDay.isAfter(_lastAllowedDay))
                      return;

                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;

                      _selectedYear = focusedDay.year;
                      _selectedMonth = focusedDay.month;
                    });
                  },
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.light.primary,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.light.primary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.light.primary,
                    ),
                    disabledTextStyle: TextStyle(
                      color: AppColors.common.grey400,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: AppColors.light.error),
                  ),
                  enabledDayPredicate: (day) {
                    return !day.isBefore(_firstAllowedDay) &&
                        !day.isAfter(_lastAllowedDay);
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppElevatedButton(
                    text: 'Terapkan',
                    onPressed: _onApply,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canGoToPreviousMonth() {
    final currentMonthStart = DateTime(_selectedYear, _selectedMonth, 1);
    final firstAllowedMonthStart = DateTime(
      _firstAllowedDay.year,
      _firstAllowedDay.month,
      1,
    );
    return currentMonthStart.isAfter(firstAllowedMonthStart);
  }

  bool _canGoToNextMonth() {
    final currentMonthStart = DateTime(_selectedYear, _selectedMonth, 1);
    final lastAllowedMonthStart = DateTime(
      _lastAllowedDay.year,
      _lastAllowedDay.month,
      1,
    );
    return currentMonthStart.isBefore(lastAllowedMonthStart);
  }
}

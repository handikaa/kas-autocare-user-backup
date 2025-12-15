import 'dart:developer';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/data/params/history_params.dart';
import 'package:kas_autocare_user/presentation/widget/layout/spacing.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/utils/share_method.dart';
import '../button/app_elevated_button.dart';
import '../button/app_outline_button.dart';

class FilterHistorySheet extends StatefulWidget {
  final String? status;
  final String? statusValue;
  final String? transaction;
  final String? convertstartDate;
  final String? selectedstartDate;
  final String? convertendDate;
  final String? selectedendDate;
  final String sortOrder;

  const FilterHistorySheet({
    super.key,
    this.status,
    this.transaction,
    this.convertstartDate,
    this.selectedstartDate,
    this.convertendDate,
    this.selectedendDate,
    this.sortOrder = "Terbaru",
    this.statusValue,
  });

  @override
  State<FilterHistorySheet> createState() => _FilterHistorySheetState();
}

class _FilterHistorySheetState extends State<FilterHistorySheet> {
  String? selectedStatus;
  String? selectedStatusValue;
  String? selectedTransactions;
  String? selectedPaymentMethod;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedStart;
  String? convertStart;
  String? convertEnd;
  String? selectedEnd;

  String sortOrder = "Terbaru";

  List statusOptions = [
    {"name": "Pending", "value": "pending"},
    {"name": "Prosess", "value": "in_progress"},
    {"name": "Pembayaran", "value": "process_payment"},
    {"name": "Selesai", "value": "completed"},
    {"name": "Dibatalkan", "value": "canceled"},
    {"name": "Kadaluwarsa", "value": "expired"},
  ];

  // final List<String> statusOptions = [
  //   "Selesai",
  //   "Gagal",
  //   "Diproses",
  //   "Pembayaran",
  // ];

  final List<String> transactionOptions = [
    "Layanan Cuci",
    "Produk",
    "Listrik",
    "PDAM",
    "Ticket Pesawat",
    "Asuransi",
    "E Money",
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
    selectedStatusValue = widget.statusValue;
    selectedTransactions = widget.transaction;
    // selectedDate = widget.date;
    selectedStart = widget.selectedstartDate;
    convertStart = widget.convertstartDate;
    convertEnd = widget.convertendDate;
    selectedEnd = widget.selectedendDate;
    sortOrder = widget.sortOrder;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              AppText(
                "Status Transaksi",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: statusOptions.map((opt) {
                  final name = opt["name"]!;
                  final value = opt["value"]!;

                  return _buildChip(
                    label: name,
                    selected: selectedStatusValue == value,
                    onTap: () {
                      setState(() {
                        selectedStatus = name; // tampil di UI
                        selectedStatusValue = value; // dikirim ke API
                      });
                    },
                  );
                }).toList(),
              ),
              // const SizedBox(height: 16),
              // AppText(
              //   "Detail Transaksi",
              //   variant: TextVariant.body2,
              //   weight: TextWeight.semiBold,
              // ),
              // const SizedBox(height: 8),

              // Wrap(
              //   spacing: 8,
              //   runSpacing: 8,
              //   children: transactionOptions.map((v) {
              //     final isSelected = selectedTransactions == v;
              //     return _buildChip(
              //       label: v,
              //       selected: isSelected,
              //       onTap: () {
              //         setState(() {
              //           selectedTransactions = isSelected ? null : v;
              //         });
              //       },
              //     );
              //   }).toList(),
              // ),
              AppGap.height(16),
              AppText(
                "Tanggal",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
              AppGap.height(8),

              GestureDetector(
                onTap: () => _showDatePicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.common.grey400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        selectedStart != null && selectedEnd != null
                            ? "$selectedStart - $selectedEnd"
                            : "Pilih Tanggal Yang Ingin Ditampilkan",
                        variant: TextVariant.body2,
                        weight: TextWeight.medium,
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppColors.common.black,
                      ),
                    ],
                  ),
                ),
              ),

              // AppGap.height(16),
              // AppText(
              //   "Urutkan",
              //   variant: TextVariant.body2,
              //   weight: TextWeight.semiBold,
              // ),
              // AppGap.height(8),

              // RadioListTile<String>(
              //   title: AppText(
              //     "Terbaru",
              //     align: TextAlign.left,
              //     variant: TextVariant.body3,
              //     weight: TextWeight.medium,
              //   ),
              //   activeColor: AppColors.light.primary,
              //   value: "Terbaru",
              //   groupValue: sortOrder,
              //   visualDensity: const VisualDensity(
              //     horizontal: -4,
              //     vertical: -4,
              //   ),
              //   dense: true,
              //   contentPadding: EdgeInsets.zero,
              //   onChanged: (value) => setState(() => sortOrder = value!),
              // ),
              // RadioListTile<String>(
              //   title: AppText(
              //     "Terlama",
              //     align: TextAlign.left,
              //     variant: TextVariant.body3,
              //     weight: TextWeight.medium,
              //   ),
              //   value: "Terlama",
              //   groupValue: sortOrder,
              //   visualDensity: const VisualDensity(
              //     horizontal: -4,
              //     vertical: -4,
              //   ),
              //   dense: true,
              //   contentPadding: EdgeInsets.zero,
              //   onChanged: (value) => setState(() => sortOrder = value!),
              // ),
              AppGap.height(20),

              Row(
                children: [
                  Expanded(
                    child: AppElevatedButton(
                      text: "Terapkan",
                      onPressed: () {
                        if (startDate != null) {
                          convertStart = DateTimeFormatter.formatDateForParams(
                            startDate!,
                          );
                        }
                        if (endDate != null) {
                          convertEnd = DateTimeFormatter.addOneDayFormatted(
                            endDate!,
                          );
                        }

                        HistoryParams? result = HistoryParams(
                          convertstartDate: convertStart,
                          convertendDate: convertEnd,
                          status: selectedStatus,
                          statusValue: selectedStatusValue,
                          selectedstartDate: selectedStart,
                          selectedendDate: selectedEnd,
                        );

                        context.pop(result);
                      },
                    ),
                  ),
                ],
              ),

              AppGap.height(8),

              Row(
                children: [
                  Expanded(
                    child: AppOutlineButton(
                      text: "Reset",
                      onPressed: () {
                        setState(() {
                          selectedStatus = null;
                          selectedStatusValue = null;
                          selectedTransactions = null;
                          selectedEnd = null;
                          selectedStart = null;
                          startDate = null;
                          endDate = null;
                          sortOrder = "Terbaru";
                          convertStart = null;
                          convertEnd = null;
                        });

                        // context.pop(null);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.light.primary : AppColors.common.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.light.primary
                : AppColors.common.grey400,
          ),
        ),
        child: AppText(
          label,
          variant: TextVariant.body3,
          weight: TextWeight.medium,
          color: selected ? AppColors.common.white : AppColors.common.black,
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now().subtract(const Duration(days: 30)),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      endDate: endDate,
      startDate: startDate,
      backgroundColor: AppColors.common.white,
      primaryColor: AppColors.light.primary,
      onApplyClick: (start, end) {
        setState(() {
          startDate = start;
          endDate = end;
          selectedStart = DateTimeFormatter.formatDateOnly(startDate!);
          selectedEnd = DateTimeFormatter.formatDateOnly(endDate!);
        });
      },
      onCancelClick: () {
        setState(() {
          endDate = null;
          startDate = null;
        });
      },
    );
  }
}

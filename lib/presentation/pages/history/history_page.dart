import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/utils/app_snackbar.dart';
import 'package:kas_autocare_user/core/utils/share_method.dart';
import 'package:kas_autocare_user/data/model/payment_data.dart';
import 'package:kas_autocare_user/data/params/history_params.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../domain/entities/history_transaction_entity.dart';
import '../../cubit/list_history_cubit.dart';
import '../../widget/bottomsheet/filter_history_sheet.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? selectedStatus;
  String? selectedStatusValue;
  String? selectedTransactions;
  String? convertstartDate;
  String? selectedstartDate;
  String? convertendDate;
  String? selectedendDate;
  String sortOrder = "Terbaru";
  HistoryParams? params;
  List<HistoryTransactionEntity> _histories = [];
  List<HistoryTransactionEntity> _filteredHistories = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  final int _perPage = 10;

  @override
  void initState() {
    super.initState();

    // load page pertama
    _loadInitialData();

    // listen infinite scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent -
                  100 && // buffer dikit
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreData();
      }
    });
  }

  void _applySearch(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredHistories = [];
      } else {
        _filteredHistories = _histories.where((e) {
          final status = e.status.toLowerCase();
          final code = (e.licensePlate).toLowerCase();
          final title = e.transactionItems.isNotEmpty
              ? (e.transactionItems.first.itemType ?? '').toLowerCase()
              : '';

          return status.contains(query) ||
              code.contains(query) ||
              title.contains(query);
        }).toList();
      }
    });
  }

  void _loadInitialData() {
    _page = 1;
    _hasMore = true;
    context.read<ListHistoryCubit>().getListHistory(params, page: _page);
  }

  void _loadMoreData() {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _page++;
    });

    context.read<ListHistoryCubit>().getListHistory(params, page: _page);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHistoryCard(HistoryTransactionEntity item) {
    final transactionItem = item.transactionItems.isNotEmpty
        ? item.transactionItems.first
        : null;

    final date = DateTimeFormatter.formatDateTime(item.createdAt);

    final formattedPrice = TextFormatter.formatRupiah(item.finalPrice);

    final Color typeColor = transactionItem != null
        ? ShareMethod.getHistoryIconColor(transactionItem.itemType)
        : AppColors.common.grey400;

    final Color textColor = transactionItem != null
        ? ShareMethod.getHistoryIconColor(transactionItem.itemType)
        : AppColors.common.grey400;

    final String typeStatus = ShareMethod.getStatus(item.status);
    final String plate = item.licensePlate;

    // Title & subtitle fallback
    final String typeTitle = transactionItem != null
        ? ShareMethod.getTitle(transactionItem.itemType)
        : "Transaksi";

    final String typeSubTitle = transactionItem != null
        ? ShareMethod.getSubTitle(transactionItem.itemType)
        : "Item tidak tersedia";

    // Icon fallback
    final IconData typeIcon = transactionItem != null
        ? ShareMethod.getHistoryIcon(transactionItem.itemType)
        : Icons.receipt;

    return GestureDetector(
      onTap: () {
        PaymentData? data = PaymentData(subMerchant: 0, id: item.id, type: '');
        print("DEBUG : Id Merchant null try please call the developer");
        if (transactionItem?.itemType != 'product') {
          context.push('/detail-booking-transaction', extra: data);
        } else if (transactionItem?.itemType == 'product') {
          context.push('/detail-transaction-product', extra: data);
        } else {
          showAppSnackBar(
            context,
            message: "Item Transaksi tidak valid ",
            type: SnackType.error,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.common.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: typeColor.withOpacity(0.4),
            child: Icon(typeIcon, color: typeColor),
          ),
          title: AppText(
            typeTitle,
            align: TextAlign.left,
            variant: TextVariant.body2,
            weight: TextWeight.semiBold,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                "$typeSubTitle\n$plate",
                maxLines: 2,
                align: TextAlign.left,
                variant: TextVariant.body3,
                weight: TextWeight.medium,
              ),

              const SizedBox(height: 3),
              AppText(
                date,
                variant: TextVariant.body3,
                weight: TextWeight.regular,
                color: AppColors.common.solidGrey,
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                formattedPrice,
                variant: TextVariant.body3,
                weight: TextWeight.semiBold,
              ),
              AppGap.height(4),

              AppText(
                ShareMethod.getStatus(item.status),
                variant: TextVariant.body3,
                weight: TextWeight.semiBold,
                color: ShareMethod.getTextColor(item.status),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.light.primary,
      color: AppColors.common.white,
      onRefresh: () {
        return context.read<ListHistoryCubit>().getListHistory(params, page: 1);
      },
      child: ContainerScreen(
        title: "Riwayat",
        scrollable: false,
        hideBackButton: true,
        body: [
          _buildSearchFilterHistory(),
          BlocConsumer<ListHistoryCubit, ListHistoryState>(
            listener: (context, state) {
              if (state is ListHistoryLoaded) {
                final newData = state.data;

                setState(() {
                  if (_isLoadingMore) {
                    // mode load more → append
                    if (newData.isEmpty) {
                      _hasMore = false; // tidak ada data lagi
                    } else {
                      _histories.addAll(newData);
                    }
                    _isLoadingMore = false;
                  } else {
                    // load pertama / refresh → replace
                    _histories = newData;
                  }
                });
              }

              if (state is ListHistoryError) {
                setState(() {
                  _isLoadingMore = false;
                });

                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackType.error,
                );
              }
            },
            builder: (context, state) {
              // loading awal
              if (state is ListHistoryLoading && _histories.isEmpty) {
                return const Expanded(
                  child: Center(child: AppCircularLoading()),
                );
              }
              if (state is ListHistoryLoadingFilter) {
                return const Expanded(
                  child: Center(child: AppCircularLoading()),
                );
              }

              final baseList = _searchController.text.isEmpty
                  ? _histories
                  : _filteredHistories;

              if (baseList.isEmpty) {
                return const Expanded(
                  child: Center(child: Text("Data kosong")),
                );
              }

              // // kalau mau sorted, bisa pakai sortedList di sini
              // final sortedList = [
              //   ..._histories.where((e) => e.status == "Proses"),
              //   ..._histories.where((e) => e.status != "Proses"),
              // ];

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: baseList.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isLoadingMore && index == baseList.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: AppCircularLoading()),
                      );
                    }

                    final data = baseList[index];
                    return _buildHistoryCard(data);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterHistory() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<HistoryParams?>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (_) => FilterHistorySheet(
                    status: selectedStatus,
                    statusValue: selectedStatusValue,
                    transaction: selectedTransactions,
                    convertstartDate: convertstartDate,
                    selectedstartDate: selectedstartDate,
                    convertendDate: convertendDate,
                    selectedendDate: selectedendDate,
                    sortOrder: sortOrder,
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedStatus = result.status;
                    convertstartDate = result.convertstartDate;
                    convertendDate = result.convertendDate;
                    selectedstartDate = result.selectedstartDate;
                    selectedendDate = result.selectedendDate;
                    selectedStatusValue = result.statusValue;

                    _page = 1;

                    params = result;
                  });

                  context.read<ListHistoryCubit>().getListHistoryFilter(
                    params,
                    page: _page,
                  );
                }
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: AppIcon(
                  icon: Icons.filter_alt_outlined,
                  color: AppColors.common.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: TextField(
                  onSubmitted: (value) {
                    final query = value.trim();

                    if (query.isEmpty) {
                      // context.read<ProductCubit>().resetFilterAndSearch();
                    } else {
                      // context.read<ProductCubit>().applySearch(query);
                    }
                  },
                  controller: _searchController,
                  cursorColor: AppColors.light.primary,
                  cursorWidth: 2.2,
                  cursorHeight: 20,
                  cursorRadius: const Radius.circular(4),
                  style: TextStyle(
                    color: AppColors.common.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) => _applySearch(value),
                  decoration: InputDecoration(
                    hintText: 'Cari...',
                    hintStyle: TextStyle(color: AppColors.common.black),

                    suffixIcon: AppIcon(
                      icon: Icons.search,
                      color: AppColors.common.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        AppGap.height(12),
      ],
    );
  }
}

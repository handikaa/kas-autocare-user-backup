import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';

import '../icon/app_circular_loading.dart';
import '../widget.dart';

class DynamicMultiSelectBottomSheet<T> extends StatefulWidget {
  final String searchHint;
  final Future<List<T>> Function() onFetchData;
  final String Function(T item) itemLabel;
  final ValueChanged<List<T>> onSelectionChanged;
  final List<T>? initiallySelected;

  const DynamicMultiSelectBottomSheet({
    super.key,
    required this.searchHint,
    required this.onFetchData,
    required this.itemLabel,
    required this.onSelectionChanged,
    this.initiallySelected,
  });

  @override
  State<DynamicMultiSelectBottomSheet<T>> createState() =>
      _DynamicMultiSelectBottomSheetState<T>();
}

class _DynamicMultiSelectBottomSheetState<T>
    extends State<DynamicMultiSelectBottomSheet<T>> {
  List<T> allItems = [];
  List<T> filteredItems = [];
  List<T> selectedItems = [];

  bool isLoading = true;
  bool isError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedItems = widget.initiallySelected ?? [];
    _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final result = await widget.onFetchData();
      if (result.isEmpty) {
        setState(() {
          isError = true;
          allItems = [];
          filteredItems = [];
        });
      } else {
        setState(() {
          allItems = result;
          filteredItems = result;
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching data: $e');
      setState(() {
        isError = true;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems
          .where((item) => widget.itemLabel(item).toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleSelection(T item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
    widget.onSelectionChanged(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              SearchBorder(
                searchController: _searchController,
                searchHint: widget.searchHint,
              ),

              Expanded(
                child: isLoading
                    ? const Center(child: AppCircularLoading())
                    : isError
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            AppText(
                              'Terjadi kesalahan, data kosong',
                              variant: TextVariant.body2,
                              weight: TextWeight.medium,
                            ),

                            ElevatedButton(
                              onPressed: _fetchData,
                              child: AppText(
                                'Coba Lagi',
                                variant: TextVariant.body2,
                                weight: TextWeight.medium,
                              ),
                            ),
                          ],
                        ),
                      )
                    : filteredItems.isEmpty
                    ? const Center(
                        child: AppText(
                          'Data tidak ditemukan',
                          variant: TextVariant.body2,
                          weight: TextWeight.medium,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final label = widget.itemLabel(item);
                          final isSelected = selectedItems.contains(item);

                          return CheckboxListTile(
                            activeColor: AppColors.light.primary,
                            checkColor: AppColors.common.white,

                            side: BorderSide(
                              color: AppColors.common.grey400,
                              width: 2,
                            ),
                            title: AppText(
                              align: TextAlign.left,
                              label,
                              variant: TextVariant.body2,
                              weight: TextWeight.medium,
                            ),
                            value: isSelected,
                            onChanged: (_) => _toggleSelection(item),
                          );
                        },
                      ),
              ),

              if (!isLoading && !isError)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: AppElevatedButton(
                      text: "Selesai",
                      onPressed: () => Navigator.pop(context, selectedItems),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

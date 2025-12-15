import 'package:flutter/material.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';

import '../icon/app_circular_loading.dart';
import '../widget.dart';

class DynamicSelectionBottomSheet<T> extends StatefulWidget {
  final String searchHint;
  final Future<List<T>> Function() onFetchData;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onItemSelected;
  final T? selectedItem;

  const DynamicSelectionBottomSheet({
    super.key,
    required this.searchHint,
    required this.onFetchData,
    required this.itemLabel,
    required this.onItemSelected,
    this.selectedItem,
  });

  @override
  State<DynamicSelectionBottomSheet<T>> createState() =>
      _DynamicSelectionBottomSheetState<T>();
}

class _DynamicSelectionBottomSheetState<T>
    extends State<DynamicSelectionBottomSheet<T>> {
  List<T> allItems = [];
  List<T> filteredItems = [];
  bool isLoading = true;
  bool hasError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await widget.onFetchData();

      if (!mounted) return;
      setState(() {
        allItems = result;
        filteredItems = result;
        hasError = result.isEmpty;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Error fetching data: $e');
      setState(() => hasError = true);
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged() {
    if (!mounted) return;
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems
          .where((item) => widget.itemLabel(item).toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
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
                child: Builder(
                  builder: (context) {
                    if (isLoading) {
                      return const Center(child: AppCircularLoading());
                    }

                    if (hasError) {
                      return _buildErrorState();
                    }

                    if (filteredItems.isEmpty) {
                      return const Center(child: Text('Data tidak ditemukan'));
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final label = widget.itemLabel(item);
                        final isSelected = item == widget.selectedItem;

                        return ListTile(
                          title: AppText(
                            label,
                            variant: TextVariant.body1,
                            align: TextAlign.left,
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            widget.onItemSelected(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon: Icons.warning_amber_rounded,
              color: AppColors.common.lightOrange,
              size: 80,
            ),

            AppGap.height(16),
            AppText(
              'Terjadi kesalahan, data kosong',
              align: TextAlign.center,
              variant: TextVariant.body3,
              weight: TextWeight.regular,
            ),
            AppGap.height(16),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppColors.light.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

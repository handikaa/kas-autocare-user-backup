import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/data/model/add_address_data.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../domain/entities/address_entity.dart';
import '../../cubit/list_address_cubit.dart';
import '../../widget/bottomsheet/confirm_delete_bottomsheet.dart';
import '../../widget/card/address_card.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key, this.isCheckout});

  final bool? isCheckout;

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final TextEditingController _search = TextEditingController();
  // void _addAddress(Address newAddress) {
  //   setState(() {
  //     _addresses.add(newAddress);
  //   });
  // }

  // void _deleteAddress(int index) {
  //   setState(() {
  //     _addresses.removeAt(index);
  //   });
  // }

  // Future<void> _navigateToAddAddress() async {
  //   final newAddress = await context.push<Address>('/add-address');

  //   if (newAddress != null) {
  //     _addAddress(newAddress);
  //   }
  // }

  void _selectAddress(AddressEntity address) {
    if (widget.isCheckout != null) {
      context.pop(address);
    }
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,
        padding: AppPadding.all(16),
        child: Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: "Tambah Alamat",
                onPressed: () async {
                  final result = await context.push('/add-address');

                  if (result == true) {
                    context.read<ListAddressCubit>().getListAddress();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: "Daftar Alamat",
      scrollable: true,
      bottomNavigationBar: _buildBottomButton(),
      body: [
        BlocBuilder<ListAddressCubit, ListAddressState>(
          builder: (context, state) {
            if (state is ListAddressLoading) {
              return Column(children: [Center(child: AppCircularLoading())]);
            }
            if (state is DeleteAddressLoading) {
              return Column(children: [Center(child: AppCircularLoading())]);
            }
            if (state is ListAddressError) {
              return Column(
                children: [
                  Center(
                    child: AppText(
                      state.message,
                      variant: TextVariant.body2,
                      weight: TextWeight.bold,
                    ),
                  ),
                ],
              );
            }

            if (state is ListAddressLoaded) {
              return Column(
                children: [
                  AppSearchForm(hintText: 'Cari Alamat', controller: _search),

                  const SizedBox(height: 16),
                  if (state.data.isEmpty)
                    Center(
                      child: AppText("Data Kosong", variant: TextVariant.body2),
                    ),
                  ...state.data.asMap().entries.map((entry) {
                    final addr = entry.value;

                    return AddressCard(
                      showButton: true,
                      name: addr.name,
                      phone: addr.phoneNumber,
                      address: addr.fullAddress,
                      isPrimary: addr.isDefault,
                      onTap: () => _selectAddress(addr),
                      onEdit: () async {
                        AddAddressData data = AddAddressData(
                          isEdit: true,
                          id: addr.id,
                        );

                        final result = await context.push(
                          '/add-address',
                          extra: data,
                        );

                        if (result == true) {
                          context.read<ListAddressCubit>().getListAddress();
                        }
                      },
                      onDelete: () {
                        ConfirmDeleteBottomSheet.show(
                          context,
                          title: 'Hapus Alamat',
                          onConfirm: () {
                            context.read<ListAddressCubit>().addressDelete(
                              addr.id,
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

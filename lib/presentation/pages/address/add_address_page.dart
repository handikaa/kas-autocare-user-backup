// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/data/model/add_address_data.dart';
import 'package:kas_autocare_user/domain/entities/address_entity.dart';
import 'package:kas_autocare_user/domain/entities/district_entity.dart';
import 'package:kas_autocare_user/presentation/widget/icon/app_circular_loading.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/share_method.dart';
import '../../../data/params/payload_address_input.dart';
import '../../cubit/add_address_cubit.dart';
import '../../widget/bottomsheet/wording_bottomsheet.dart';
import '../../widget/widget.dart';

class AddAddressPage extends StatefulWidget {
  final AddAddressData? data;
  const AddAddressPage({super.key, this.data});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late final int idAddr;

  AddAddressCubit get addAddressCubit => context.read<AddAddressCubit>();
  PayloadAddressInput input = PayloadAddressInput();

  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  DistrictEntity? selectedDistrict;
  LatLong? latlong;
  String? address;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int districtId = 0;

  bool _isFormValid = false;
  bool _isDefaultAdd = false;

  final geocoding = GeocodingService(
    nominatimHost: 'nominatim.openstreetmap.org',
    userAgent: 'com.kasautocare.app/1.0',
  );

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      idAddr = widget.data!.id!;
      // _isEdit = widget.data?.isEdit ?? false;
      addAddressCubit.getDetailAddress(idAddr);
    }
  }

  void _validateForm() {
    setState(() {
      _isFormValid = false;
    });

    if (_addressController.text.isEmpty) return;

    if (_nameController.text.isEmpty) return;
    if (_phoneController.text.isEmpty) return;
    // if (_postalCodeController.text.isEmpty) return;
    if (selectedDistrict == null) return;

    setState(() {
      _isFormValid = true;
    });
  }

  void toogleDefaultAddress() {
    setState(() {
      _isDefaultAdd = !_isDefaultAdd;
    });
  }

  void addNewAddress() {
    final payload = input.copyWith(
      name: _nameController.text,
      phoneNumber: int.tryParse(_phoneController.text) ?? 0,
      districtId: selectedDistrict!.districtId,
      fullAddress: _addressController.text,
      postalCode: _postalCodeController.text,
      isDefault: _isDefaultAdd,
      latitude: latlong?.latitude.toString() ?? '',
      longitude: latlong?.longitude.toString() ?? '',
    );

    addAddressCubit.createNewAddress(payload);
  }

  void updateAddress() {
    final payload = input.copyWith(
      name: _nameController.text,
      phoneNumber: int.tryParse(_phoneController.text) ?? 0,
      districtId: selectedDistrict!.districtId,
      fullAddress: _addressController.text,
      postalCode: _postalCodeController.text,
      isDefault: _isDefaultAdd,
      latitude: latlong?.latitude.toString() ?? '',
      longitude: latlong?.longitude.toString() ?? '',
    );

    addAddressCubit.addressUpdate(payload: payload, id: idAddr);
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,
        padding: AppPadding.all(16),
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<AddAddressCubit, AddAddressState>(
                builder: (context, state) {
                  if (state is AddressLoading) {
                    return AppElevatedButton(text: "Simpan Perubahan");
                  }

                  return AppElevatedButton(
                    text: "Simpan Perubahan",
                    onPressed: _isFormValid
                        ? () {
                            if (widget.data != null) {
                              updateAddress();
                            } else {
                              addNewAddress();
                            }
                          }
                        : null,
                  );
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
    double maxH = MediaQuery.of(context).size.height;

    return BlocListener<AddAddressCubit, AddAddressState>(
      listener: (context, state) {
        if (state is AddressLoading) {
          AppDialog.loading(context, message: "Menambah alamat baru...");
        }

        if (state is AddressError) {
          AppBottomSheets.showErrorBottomSheet(
            context,
            title: 'Gagal menambah alamat',
            message: state.message,
          );
        }
        if (state is AddressLoaded) {
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.success,
          );
          context.pop(true);
          context.pop(true);
        }
        if (state is DetailAddressLoading) {
          Column(children: [Center(child: AppCircularLoading())]);
        }

        if (state is DetailAddressLoaded) {
          AddressEntity data = state.data;

          setState(() {
            _isDefaultAdd = data.isDefault;
            _nameController.text = data.name;
            _phoneController.text = data.phoneNumber.toString();
            _districtController.text =
                "${data.provinceName} ${data.cityName} ${data.districtName} ${data.districtName}";
            _addressController.text = data.fullAddress;
            _postalCodeController.text = data.postalCode;

            latlong = LatLong(data.latitude, data.longitude);

            selectedDistrict = DistrictEntity(
              id: 0,
              districtId: data.districtId,
              districtName: data.districtName,
              regencyName: data.cityName,
              provinceName: data.provinceName,
            );
          });

          _validateForm();
        }
      },
      child: ContainerScreen(
        title: "Tambah Alamat",
        scrollable: true,
        bottomNavigationBar: _buildBottomButton(),
        body: [
          Form(
            key: _formKey,
            onChanged: _validateForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBox(
                  color: AppColors.common.white,
                  borderRadius: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.light.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                address ?? "Pilih Titik Lokasi (Opsional)",
                                align: TextAlign.left,
                                maxLines: 2,
                                variant: TextVariant.body3,
                                weight: TextWeight.medium,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final initialLatLng =
                                    (latlong != null &&
                                        latlong!.latitude != 0.0 &&
                                        latlong!.longitude != 0.0)
                                    ? latlong
                                    : null;

                                final res = await context.push(
                                  '/opm',
                                  extra: initialLatLng,
                                );

                                if (res != null && res is PickedData) {
                                  setState(() {
                                    latlong = LatLong(
                                      res.latLong.latitude,
                                      res.latLong.longitude,
                                    );
                                    address = res.address;
                                  });
                                }
                              },
                              child: AppText(
                                "Ubah",
                                variant: TextVariant.body3,
                                color: AppColors.light.primary,
                              ),
                            ),
                          ],
                        ),

                        if (latlong != null &&
                            latlong!.latitude != 0.0 &&
                            latlong!.longitude != 0.0)
                          Container(
                            height: maxH * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                FlutterMap(
                                  key: ValueKey(
                                    "${latlong!.latitude},${latlong!.longitude}",
                                  ),
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      latlong!.latitude,
                                      latlong!.longitude,
                                    ),
                                    initialZoom: 17,
                                    onTap: (tapPosition, point) {},
                                    interactionOptions:
                                        const InteractionOptions(
                                          flags: ~InteractiveFlag.rotate,
                                        ),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      userAgentPackageName:
                                          "com.kasautocare.app",
                                    ),

                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(
                                            latlong!.latitude,
                                            latlong!.longitude,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: const Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: FloatingActionButton(
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    elevation: 4,
                                    child: Icon(
                                      Icons.my_location,
                                      color: AppColors.light.primary,
                                    ),
                                    onPressed: () {
                                      _mapController.move(
                                        LatLng(
                                          latlong!.latitude,
                                          latlong!.longitude,
                                        ),
                                        17,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                AppGap.height(20),
                Row(
                  children: [
                    Switch(
                      inactiveTrackColor: AppColors.common.grey400,
                      activeColor: AppColors.light.primary,
                      value: _isDefaultAdd,
                      onChanged: (value) => toogleDefaultAddress(),
                    ),
                    AppGap.width(12),
                    AppText(
                      'Jadikan alamat utama?',
                      variant: TextVariant.body2,
                      weight: TextWeight.medium,
                    ),
                  ],
                ),
                AppGap.height(16),

                AppTextFormField(
                  label: "Nama Penerima",
                  hintText: "Masukkan nama penerima",
                  controller: _nameController,
                  readOnly: widget.data != null ? true : false,
                  onChanged: (_) => _validateForm(),
                ),
                AppGap.height(16),

                AppTextFormField(
                  keyboardType: TextInputType.number,
                  label: "Nomor Hp",

                  hintText: "Masukkan nomor telepon penerima",
                  controller: _phoneController,
                  onChanged: (_) => _validateForm(),
                  readOnly: widget.data != null ? true : false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    NoInvalidPasteFormatter(),
                  ],
                ),
                AppGap.height(16),

                AppTextFormField(
                  label: "Kecamatan",
                  hintText: "Masukkan kecamatan",
                  controller: _districtController,
                  readOnly: true,
                  onTap: () async {
                    final res = await context.push(
                      '/find-location',
                      extra: 'disctrict',
                    );

                    if (res != null && res is DistrictEntity) {
                      setState(() {
                        selectedDistrict = res;

                        _districtController.text =
                            "${res.provinceName}, ${res.regencyName}, ${res.districtName}";
                      });

                      _validateForm();
                    }
                  },
                ),
                AppGap.height(16),

                AppTextFormField(
                  label: "Alamat Lengkap",
                  hintText: "Masukkan alamat lengkap",
                  controller: _addressController,
                  onChanged: (_) => _validateForm(),
                  maxLines: null, // auto-expand
                  maxHeight: 150, // maksimal tinggi
                ),
                AppGap.height(16),

                if (widget.data != null)
                  AppTextFormField(
                    keyboardType: TextInputType.number,
                    label: "Kode Pos",
                    readOnly: true,
                    hintText: "Masukkan kode pos dengan valid",
                    controller: _postalCodeController,
                    onChanged: (_) => _validateForm(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NoInvalidPasteFormatter(),
                    ],
                  ),
                AppGap.height(16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

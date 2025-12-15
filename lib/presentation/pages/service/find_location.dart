import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/share_method.dart';
import '../../../data/model/params_location.dart';
import '../../../domain/entities/city_entity.dart';
import '../../../domain/entities/district_entity.dart';
import '../../cubit/city_cubit.dart';
import '../../cubit/list_district_cubit.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class FindLocation extends StatefulWidget {
  final String location;

  const FindLocation({super.key, required this.location});

  @override
  State<FindLocation> createState() => _FindLocationState();
}

class _FindLocationState extends State<FindLocation> {
  final TextEditingController _findLocationController = TextEditingController();
  Timer? _debounce;

  final List<CityEntity> _allCities = [];
  List<CityEntity> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    if (widget.location == 'disctrict') {
      // context.read<ListDistrictCubit>().fetchListDistrict();
    } else {
      context.read<CityCubit>().getListCity();
    }

    _findLocationController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _findLocationController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = [];
      } else {
        _filteredCities = _allCities
            .where((city) => city.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _findLocationController.removeListener(_onSearchChanged);
    _findLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      scrollable: false,
      title: 'Cari Lokasi',
      body: [
        if (widget.location != 'disctrict') ...[
          AppGap.height(16),
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: AppCircularLoading()),
              );

              final position = await ShareMethod.getCurrentUserLocation();
              if (context.mounted) Navigator.pop(context);

              if (position != null) {
                if (context.mounted) {
                  context.pop(
                    ParamsLocation(
                      lat: position.latitude,
                      long: position.longitude,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gagal mengambil lokasi pengguna'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: AppBox(
              color: AppColors.common.white,
              borderRadius: 8,
              child: Padding(
                padding: AppPadding.all(14),
                child: Row(
                  children: [
                    AppText(
                      'Lokasi Anda Saat Ini',
                      variant: TextVariant.body3,
                      weight: TextWeight.medium,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.my_location_outlined,
                      color: AppColors.common.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppGap.height(16),
        ],

        AppSearchForm(
          hintText: widget.location == 'disctrict'
              ? "Masukan minimal 3 huruf"
              : "Cari Lokasi",
          controller: _findLocationController,
          onChanged: widget.location == 'disctrict'
              ? (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 400), () {
                    if (value.length >= 3) {
                      context.read<ListDistrictCubit>().fetchListDistrict(
                        value,
                      );
                    }
                  });
                }
              : null,
        ),

        AppGap.height(16),
        if (widget.location == 'disctrict')
          Expanded(
            child: BlocBuilder<ListDistrictCubit, ListDistrictState>(
              builder: (context, state) {
                if (state is ListDistrictLoading) {
                  return const Center(child: AppCircularLoading());
                }

                if (state is ListDistrictError) {
                  return Center(
                    child: Text(
                      'Gagal memuat data kota: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is ListDistrictLoaded) {
                  final query = _findLocationController.text.toLowerCase();

                  final districts = state.data.where((q) {
                    final district = q.districtName.toLowerCase();
                    final regency = q.regencyName.toLowerCase();
                    final province = q.provinceName.toLowerCase();

                    return district.contains(query) ||
                        regency.contains(query) ||
                        province.contains(query);
                  }).toList();

                  if (districts.isEmpty) {
                    return const Center(child: Text("Kota tidak ditemukan"));
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: districts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final district = districts[index];
                      return GestureDetector(
                        onTap: () {
                          context.pop(
                            DistrictEntity(
                              districtId: district.districtId,
                              districtName: district.districtName,
                              id: district.id,
                              provinceName: district.provinceName,
                              regencyName: district.regencyName,
                            ),
                          );
                        },
                        child: AppBox(
                          color: AppColors.common.white,
                          borderRadius: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: AppText(
                              "${district.provinceName}, ${district.regencyName}, ${district.districtName}",
                              variant: TextVariant.body3,
                              weight: TextWeight.medium,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),

        if (widget.location == 'city')
          Expanded(
            child: BlocBuilder<CityCubit, CityState>(
              builder: (context, state) {
                if (state is CityLoading) {
                  return const Center(child: AppCircularLoading());
                }

                if (state is CityError) {
                  return Center(
                    child: Text(
                      'Gagal memuat data kota: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is CityLoaded) {
                  final cities = state.cities
                      .where(
                        (city) => city.name.toLowerCase().contains(
                          _findLocationController.text.toLowerCase(),
                        ),
                      )
                      .toList();

                  if (cities.isEmpty) {
                    return const Center(child: Text("Kota tidak ditemukan"));
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cities.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      return GestureDetector(
                        onTap: () {
                          context.pop(ParamsLocation(city: city.name));
                        },
                        child: AppBox(
                          color: AppColors.common.white,
                          borderRadius: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: AppText(
                              city.name,
                              variant: TextVariant.body3,
                              weight: TextWeight.medium,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
      ],
    );
  }
}

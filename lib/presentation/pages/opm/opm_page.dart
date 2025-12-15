import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/utils/share_method.dart';
import '../../widget/layout/container_screen.dart';

class OpmPage extends StatefulWidget {
  const OpmPage({super.key, this.latLong});

  final LatLong? latLong;

  @override
  State<OpmPage> createState() => _OpmPageState();
}

class _OpmPageState extends State<OpmPage> {
  LatLong? _initialPosition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _setupInitialPosition();
  }

  Future<void> _setupInitialPosition() async {
    // Jika ada injection latlong → langsung pakai
    if (widget.latLong != null &&
        widget.latLong!.latitude != 0 &&
        widget.latLong!.longitude != 0) {
      _initialPosition = widget.latLong;
      _loading = false;
      setState(() {});
      return;
    }

    final position = await ShareMethod.getCurrentUserLocation();

    if (position != null) {
      _initialPosition = LatLong(position.latitude, position.longitude);
    } else {
      _initialPosition = const LatLong(0.0, 0.0);
    }

    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: "Pilih titik alamat",
      scrollable: false,
      usePadding: false,
      body: [
        if (_loading) const Center(child: CircularProgressIndicator()),

        if (!_loading)
          Expanded(
            child: FlutterLocationPicker.withConfiguration(
              initPosition: _initialPosition,
              userAgent: 'com.kasautocare/1.0.0 (https://kasprima.co.id)',

              onPicked: (PickedData pickedData) {
                context.pop(pickedData);
              },

              mapConfiguration: const MapConfiguration(
                initZoom: 15.0,
                stepZoom: 1.0,
                mapLanguage: 'id',
                urlTemplate:
                    "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=45xNIVuX2WaE5xryLHiX",
              ),

              searchConfiguration: SearchConfiguration(
                searchBarHintColor: AppColors.common.black,
                searchBarBackgroundColor: AppColors.common.white,
                searchBarTextColor: AppColors.common.black,
                searchResultIconColor: AppColors.common.black,
                showSearchBar: true,
                searchBarHintText: 'Cari lokasi...',
                maxSearchResults: 12,
                searchbarDebounceDuration: Duration(milliseconds: 400),
                searchResultIcon: Icons.location_on,
              ),

              controlsConfiguration: ControlsConfiguration(
                showZoomController: true,
                showLocationController: true,

                locationIcon: Icons.my_location_rounded,
                locationButtonBackgroundColor: AppColors.light.primary,
                buttonElevation: 8.0,
                controlButtonsSpacing: 16.0,
                zoomButtonsColor: AppColors.common.white,
                locationButtonsColor: AppColors.common.white,
                zoomButtonsBackgroundColor: AppColors.light.primary,
              ),

              markerConfiguration: const MarkerConfiguration(
                markerIcon: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
                showMarkerShadow: false,
                animateMarker: true,
              ),

              selectButtonConfiguration: SelectButtonConfiguration(
                selectLocationButtonText: 'Pilih Lokasi Ini',
                selectLocationButtonStyle: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.light.primary,
                  foregroundColor: AppColors.common.white,
                  shadowColor: Colors.black45,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

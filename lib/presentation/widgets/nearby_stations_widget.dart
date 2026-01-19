import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/data/models/station_model.dart';
import 'package:testtt/presentation/cubits/location/location_cubit.dart';

import 'package:testtt/presentation/cubits/station/station_cubit.dart';

/// Main widget to display nearby stations based on user location
class NearbyStationsWidget extends StatefulWidget {
  const NearbyStationsWidget({super.key});

  @override
  State<NearbyStationsWidget> createState() => _NearbyStationsWidgetState();
}

class _NearbyStationsWidgetState extends State<NearbyStationsWidget> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocation();
    });
  }

  Future<void> _initLocation() async {
    if (_initialized) return;
    _initialized = true;

    final locationCubit = context.read<LocationCubit>();
    final stationCubit = context.read<StationCubit>();

    // Get user location
    final success = await locationCubit.getCurrentLocation();
    final locationState = locationCubit.state;

    if (success && locationState is LocationLoaded) {
      // Load stations with real user location
      await stationCubit.loadStationsWithLocation(
        locationState.position.latitude,
        locationState.position.longitude,
      );
    } else {
      // Load stations without location sorting
      stationCubit.loadMockStations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<StationCubit, StationState>(
          builder: (context, stationState) {
            // Loading state
            if (locationState is LocationLoading ||
                stationState is StationLoading) {
              return const StationLoadingWidget();
            }

            // Error state - permission denied or other
            // Note: LocationError state might be permission denied
            if (locationState is LocationError) {
              return StationPermissionDeniedWidget(
                onOpenSettings: () =>
                    context.read<LocationCubit>().openSettings(),
              );
            }

            // Get stations
            final stations = stationState is StationLoaded
                ? stationState.stations
                : <Station>[];

            if (stations.isEmpty) {
              return const SizedBox.shrink();
            }

            double? userLat;
            double? userLng;
            if (locationState is LocationLoaded) {
              userLat = locationState.position.latitude;
              userLng = locationState.position.longitude;
            }

            // Show nearby stations list
            return StationsListWidget(
              stations: stations,
              userLatitude: userLat,
              userLongitude: userLng,
            );
          },
        );
      },
    );
  }
}

/// Loading state widget
class StationLoadingWidget extends StatelessWidget {
  const StationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorsManager.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Recherche des stations proches...',
            style: TextStyles.body.copyWith(color: ColorsManager.greycolor),
          ),
        ],
      ),
    );
  }
}

/// Permission denied widget
class StationPermissionDeniedWidget extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const StationPermissionDeniedWidget({
    super.key,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_off,
                color: ColorsManager.warning,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Localisation désactivée',
                  style: TextStyles.bodyBold.copyWith(
                    color: ColorsManager.warning,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Activez la localisation pour voir les stations proches de vous.',
            style: TextStyles.smallText,
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onOpenSettings,
            child: Text(
              'Ouvrir les paramètres',
              style: TextStyles.body.copyWith(
                color: ColorsManager.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stations list widget
class StationsListWidget extends StatelessWidget {
  final List<Station> stations;
  final double? userLatitude;
  final double? userLongitude;

  const StationsListWidget({
    super.key,
    required this.stations,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        StationsHeaderWidget(
          hasLocation: userLatitude != null,
        ),
        SizedBox(height: 12.h),
        // Horizontal list
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: stations.take(6).length,
            itemBuilder: (context, index) {
              final station = stations[index];
              return StationCardWidget(
                station: station,
                isNearest: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Stations header widget
class StationsHeaderWidget extends StatelessWidget {
  final bool hasLocation;

  const StationsHeaderWidget({
    super.key,
    required this.hasLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Stations proches',
            style: TextStyles.sectionTitle.copyWith(
              color: ColorsManager.blackcolor,
            ),
          ),
          if (hasLocation)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ColorsManager.softGrey,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.gps_fixed,
                    size: 12.sp,
                    color: ColorsManager.greycolor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'GPS',
                    style: TextStyles.smallText.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Individual station card widget - Modern responsive design
class StationCardWidget extends StatelessWidget {
  final Station station;
  final bool isNearest;

  const StationCardWidget({
    super.key,
    required this.station,
    this.isNearest = false,
  });

  /// Opens external map app with directions to the station
  Future<void> _openMapsWithDirections(BuildContext context) async {
    final lat = station.latitude;
    final lng = station.longitude;
    final name = Uri.encodeComponent(station.name);

    // Try Google Maps first, then Apple Maps, then browser
    final googleMapsUrl = Uri.parse(
      'google.navigation:q=$lat,$lng&mode=d',
    );
    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$lat,$lng&dirflg=d',
    );
    final webUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$name',
    );

    try {
      // Try Google Maps app
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      }
      // Try Apple Maps (iOS)
      else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      }
      // Fallback to web browser
      else if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir la carte'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        debugPrint('Error launching maps: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = station.isOpen;

    return Container(
      width: 200.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isNearest
              ? ColorsManager.blackcolor
              : ColorsManager.textfieldbordercolor,
          width: isNearest ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openMapsWithDirections(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section - Name and status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Station icon - simple
                    Icon(
                      Icons.store_rounded,
                      size: 20.sp,
                      color: ColorsManager.blackcolor,
                    ),
                    SizedBox(width: 10.w),
                    // Station name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.name,
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsManager.blackcolor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          // Status - simple text
                          Text(
                            isOpen ? 'Ouvert' : 'Fermé',
                            style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorsManager.greycolor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Bottom section - Distance and ETA
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.softGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Distance
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14.sp,
                            color: ColorsManager.greycolor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${station.distanceKm} km',
                            style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.blackcolor,
                            ),
                          ),
                        ],
                      ),
                      // Divider
                      Container(
                        width: 1,
                        height: 12.h,
                        color: ColorsManager.greycolor,
                      ),
                      // ETA
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.sp,
                            color: ColorsManager.greycolor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${station.etaMinutes} min',
                            style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.blackcolor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

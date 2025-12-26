import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/station_model.dart';
import 'package:testtt/presentation/widgets/Custom_checkout_appbar.dart';
import 'package:testtt/presentation/widgets/order_item_card.dart';
import 'package:testtt/providers/cart_provider.dart';
import 'package:testtt/providers/location_provider.dart';
import 'package:testtt/providers/order_provider.dart';
import 'package:testtt/providers/product_station_provider.dart';

/// Station Map Checkout Screen
/// User reviews order items, selects pickup station, and confirms
class StationCheckoutScreen extends StatefulWidget {
  const StationCheckoutScreen({super.key});

  @override
  State<StationCheckoutScreen> createState() => _StationCheckoutScreenState();
}

class _StationCheckoutScreenState extends State<StationCheckoutScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Load stations with real distance calculation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStationsWithRealDistance();
    });
  }

  /// Load stations using user's real GPS location for accurate distances
  Future<void> _loadStationsWithRealDistance() async {
    final stationProvider = Provider.of<ProductStationProvider>(
      context,
      listen: false,
    );
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    // Get user's current location
    final position = locationProvider.currentPosition;

    if (position != null) {
      // Use real GPS coordinates for distance calculation
      await stationProvider.loadStationsWithLocation(
        position.latitude,
        position.longitude,
      );
    } else {
      // Try to get location first
      await locationProvider.getCurrentLocation();
      final newPosition = locationProvider.currentPosition;

      if (newPosition != null) {
        await stationProvider.loadStationsWithLocation(
          newPosition.latitude,
          newPosition.longitude,
        );
      } else {
        // Fallback to mock data if location unavailable
        stationProvider.loadMockStations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      appBar: CustomAppBAr(),
      body: Consumer2<ProductStationProvider, CartProvider>(
        builder: (context, stationProvider, cartProvider, child) {
          return Column(
            children: [
              // Order Items Section
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      // Order Items Title
                      Text(
                        'Your Order',
                        style: TextStyles.heading2.copyWith(
                          fontSize: 20.sp,
                          color: ColorsManager.blackcolor,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Order Items List
                      ...cartProvider.items.map(
                        (item) => OrderItemCard(
                          item: item,
                          onRemove: () {
                            cartProvider.removeFromCart(item.id, item.size);
                          },
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Station Selection Dropdown
                      Text(
                        'Select Pickup Station',
                        style: TextStyles.heading2.copyWith(
                          fontSize: 18.sp,
                          color: ColorsManager.blackcolor,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      _buildStationDropdown(stationProvider),

                      SizedBox(height: 24.h),

                      // Map Section
                      if (stationProvider.selectedStation != null) ...[
                        Text(
                          'Station Location',
                          style: TextStyles.heading2.copyWith(
                            fontSize: 18.sp,
                            color: ColorsManager.blackcolor,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildMap(stationProvider),
                        SizedBox(height: 16.h),
                        _buildStationInfoCard(stationProvider.selectedStation!),
                      ],

                      SizedBox(height: 100.h), // Space for bottom bar
                    ],
                  ),
                ),
              ),

              // Bottom Total & Confirm Section
              _buildBottomSection(stationProvider, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStationDropdown(ProductStationProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.textfieldbordercolor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: provider.selectedStation?.id,
          hint: Text(
            'Choose a station',
            style: TextStyles.body.copyWith(color: ColorsManager.greycolor),
          ),
          icon:
              Icon(Icons.keyboard_arrow_down, color: ColorsManager.blackcolor),
          items: provider.stations.map((station) {
            return DropdownMenuItem<String>(
              value: station.id,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18.sp,
                    color: ColorsManager.greycolor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      station.name,
                      style: TextStyles.body.copyWith(
                        color: ColorsManager.blackcolor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${station.distanceKm} km',
                    style: TextStyles.smallText.copyWith(
                      color: ColorsManager.greycolor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (stationId) {
            if (stationId != null) {
              provider.selectStation(stationId);
              _animateMapToStation(provider.selectedStation!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMap(ProductStationProvider provider) {
    final selectedStation = provider.selectedStation!;

    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.textfieldbordercolor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(
              selectedStation.latitude,
              selectedStation.longitude,
            ),
            initialZoom: 15.0,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.parkandpick.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    selectedStation.latitude,
                    selectedStation.longitude,
                  ),
                  width: 48,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsManager.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsManager.whitecolor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.coffee,
                      color: ColorsManager.whitecolor,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _animateMapToStation(Station station) {
    _mapController.move(LatLng(station.latitude, station.longitude), 15.0);
  }

  Widget _buildStationInfoCard(Station station) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.softGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.textfieldbordercolor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: ColorsManager.blackcolor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  station.name,
                  style: TextStyles.body.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.blackcolor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: station.isOpen
                      ? ColorsManager.greenColor.withOpacity(0.1)
                      : ColorsManager.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  station.isOpen ? 'Open' : 'Closed',
                  style: TextStyles.smallText.copyWith(
                    color: station.isOpen
                        ? ColorsManager.greenColor
                        : ColorsManager.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            station.address,
            style: TextStyles.smallText.copyWith(
              color: ColorsManager.greycolor,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildInfoChip(
                icon: Icons.directions_walk,
                label: '${station.distanceKm} km',
              ),
              _buildInfoChip(
                icon: Icons.access_time,
                label: '${station.etaMinutes} min',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: ColorsManager.greycolor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyles.smallText.copyWith(
              color: ColorsManager.blackcolor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    ProductStationProvider stationProvider,
    CartProvider cartProvider,
  ) {
    final totalPrice = cartProvider.total;
    final canConfirm = stationProvider.selectedStation != null &&
        stationProvider.selectedStation!.isOpen &&
        !stationProvider.isConfirming;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.blackcolor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payment',
                  style: TextStyles.body.copyWith(
                    fontSize: 16.sp,
                    color: ColorsManager.greycolor,
                  ),
                ),
                Text(
                  PriceFormatter.formatPriceCAD(totalPrice),
                  style: TextStyles.heading1.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed:
                    canConfirm ? () => _handleConfirm(stationProvider) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canConfirm
                      ? ColorsManager.primary
                      : ColorsManager.greycolor,
                  foregroundColor: ColorsManager.whitecolor,
                  elevation: 0,
                  disabledBackgroundColor: ColorsManager.greycolor.withOpacity(
                    0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: stationProvider.isConfirming
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: ColorsManager.whitecolor,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Confirm Order',
                        style: TextStyles.buttonText.copyWith(fontSize: 16.sp),
                      ),
              ),
            ),

            // Error Message
            if (stationProvider.errorMessage != null) ...[
              SizedBox(height: 12.h),
              Text(
                stationProvider.errorMessage!,
                style: TextStyles.smallText.copyWith(
                  color: ColorsManager.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Station not selected warning
            if (stationProvider.selectedStation == null) ...[
              SizedBox(height: 12.h),
              Text(
                'Please select a pickup station',
                style: TextStyles.smallText.copyWith(
                  color: ColorsManager.warning,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Station closed warning
            if (stationProvider.selectedStation != null &&
                !stationProvider.selectedStation!.isOpen) ...[
              SizedBox(height: 12.h),
              Text(
                'Selected station is currently closed',
                style: TextStyles.smallText.copyWith(
                  color: ColorsManager.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirm(ProductStationProvider stationProvider) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final success = await stationProvider.confirmPickup('ORDER_ID_PLACEHOLDER');

    if (success && mounted) {
      // Create order from cart items
      final order = orderProvider.createOrder(
        items: cartProvider.items,
        station: stationProvider.selectedStation!,
        totalPrice: cartProvider.total,
      );

      // Clear the cart after order is created
      cartProvider.clearCart();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Commande ${order.id} confirmée à ${stationProvider.selectedStation!.name}',
            style: TextStyles.body.copyWith(color: ColorsManager.whitecolor),
          ),
          backgroundColor: ColorsManager.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );

      // Navigate back to home screen
      Navigator.of(context).pop();
    }
  }
}

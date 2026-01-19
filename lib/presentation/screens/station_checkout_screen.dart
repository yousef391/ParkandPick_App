import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/station_model.dart';
import 'package:testtt/presentation/cubits/cart/cart_cubit.dart';
import 'package:testtt/presentation/cubits/location/location_cubit.dart';
import 'package:testtt/presentation/cubits/order/order_cubit.dart';
import 'package:testtt/presentation/cubits/station/station_cubit.dart';
import 'package:testtt/presentation/cubits/payment/payment_cubit.dart';
import 'package:testtt/presentation/cubits/payment/payment_state.dart';
import 'package:testtt/presentation/widgets/Custom_checkout_appbar.dart';
import 'package:testtt/presentation/widgets/order_item_card.dart';
import 'package:testtt/presentation/widgets/delivery_method_selector.dart';

/// Station Map Checkout Screen
/// User reviews order items, selects pickup station, and confirms
class StationCheckoutScreen extends StatefulWidget {
  const StationCheckoutScreen({super.key});

  @override
  State<StationCheckoutScreen> createState() => _StationCheckoutScreenState();
}

class _StationCheckoutScreenState extends State<StationCheckoutScreen> {
  String _selectedDeliveryMethod = 'pickup';
  String? _selectedDeliveryType; // 'doordash' or 'ubereats'
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
    final locationCubit = context.read<LocationCubit>();
    final stationCubit = context.read<StationCubit>();

    // Check if we already have location
    if (locationCubit.state is LocationLoaded) {
      final pos = (locationCubit.state as LocationLoaded).position;
      await stationCubit.loadStationsWithLocation(pos.latitude, pos.longitude);
    } else {
      // Try to get location
      final success = await locationCubit.getCurrentLocation();
      if (success && locationCubit.state is LocationLoaded) {
        final pos = (locationCubit.state as LocationLoaded).position;
        await stationCubit.loadStationsWithLocation(
            pos.latitude, pos.longitude);
      } else {
        // Fallback or just load mock stations
        stationCubit.loadMockStations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      appBar: CustomAppBAr(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<StationCubit, StationState>(
            listener: (context, state) {
              if (state is StationConfirmSuccess) {
                // Confirm success handled in _handleConfirm logic or here
                // But _handleConfirm waits for result, so maybe not needed here if logic is there.
                // Actually StationCubit.confirmPickup returns boolean too.
              } else if (state is StationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: ColorsManager.redAccent,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<StationCubit, StationState>(
              builder: (context, stationState) {
                // If stations are loading, show loader? Or just show UI with empty/loading state?
                // For now, if initial, we show content, list might be empty.

                final List<Station> stations =
                    stationState is StationLoaded ? stationState.stations : [];
                final Station? selectedStation = stationState is StationLoaded
                    ? stationState.selectedStation
                    : null;
                final bool isConfirming = stationState is StationLoaded
                    ? stationState.isConfirming
                    : false;

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
                            ...cartState.items.map(
                              (item) => OrderItemCard(
                                item: item,
                                onRemove: () {
                                  context
                                      .read<CartCubit>()
                                      .removeFromCart(item.id, item.size);
                                },
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Delivery Method Selection
                            DeliveryMethodSelector(
                              selectedMethod: _selectedDeliveryMethod,
                              onChanged: (String method) {
                                setState(() {
                                  _selectedDeliveryMethod = method;
                                  if (method == 'pickup') {
                                    _selectedDeliveryType = null;
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 20.h),

                            if (_selectedDeliveryMethod == 'delivery') ...[
                              Text(
                                'Sélectionnez le service de livraison',
                                style: TextStyles.heading2.copyWith(
                                  fontSize: 18.sp,
                                  color: ColorsManager.blackcolor,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _selectedDeliveryType = 'doordash'),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
                                        decoration: BoxDecoration(
                                          color: _selectedDeliveryType ==
                                                  'doordash'
                                              ? ColorsManager.primary
                                              : ColorsManager.softGrey,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: _selectedDeliveryType ==
                                                    'doordash'
                                                ? ColorsManager.primary
                                                : ColorsManager
                                                    .textfieldbordercolor,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.delivery_dining,
                                                color: _selectedDeliveryType ==
                                                        'doordash'
                                                    ? ColorsManager.whitecolor
                                                    : ColorsManager.darkblue,
                                                size: 28.sp),
                                            SizedBox(height: 8.h),
                                            Text('DoorDash',
                                                style: TextStyles.bodyBold.copyWith(
                                                    color:
                                                        _selectedDeliveryType ==
                                                                'doordash'
                                                            ? ColorsManager
                                                                .whitecolor
                                                            : ColorsManager
                                                                .darkblue,
                                                    fontSize: 14.sp)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _selectedDeliveryType = 'ubereats'),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
                                        decoration: BoxDecoration(
                                          color: _selectedDeliveryType ==
                                                  'ubereats'
                                              ? ColorsManager.primary
                                              : ColorsManager.softGrey,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: _selectedDeliveryType ==
                                                    'ubereats'
                                                ? ColorsManager.primary
                                                : ColorsManager
                                                    .textfieldbordercolor,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.delivery_dining,
                                                color: _selectedDeliveryType ==
                                                        'ubereats'
                                                    ? ColorsManager.whitecolor
                                                    : ColorsManager.darkblue,
                                                size: 28.sp),
                                            SizedBox(height: 8.h),
                                            Text('UberEats',
                                                style: TextStyles.bodyBold.copyWith(
                                                    color:
                                                        _selectedDeliveryType ==
                                                                'ubereats'
                                                            ? ColorsManager
                                                                .whitecolor
                                                            : ColorsManager
                                                                .darkblue,
                                                    fontSize: 14.sp)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                            ],

                            if (_selectedDeliveryMethod == 'pickup') ...[
                              // Station Selection Dropdown
                              Text(
                                'Select Pickup Station',
                                style: TextStyles.heading2.copyWith(
                                  fontSize: 18.sp,
                                  color: ColorsManager.blackcolor,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              _buildStationDropdown(stations, selectedStation),
                              SizedBox(height: 24.h),
                            ],

                            // Map Section
                            if (selectedStation != null) ...[
                              Text(
                                'Station Location',
                                style: TextStyles.heading2.copyWith(
                                  fontSize: 18.sp,
                                  color: ColorsManager.blackcolor,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              _buildMap(selectedStation),
                              SizedBox(height: 16.h),
                              _buildStationInfoCard(selectedStation),
                            ],

                            SizedBox(height: 100.h), // Space for bottom bar
                          ],
                        ),
                      ),
                    ),

                    // Bottom Total & Confirm Section
                    _buildBottomSection(
                        selectedStation, isConfirming, cartState.total),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStationDropdown(
      List<Station> stations, Station? selectedStation) {
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
          value: selectedStation?.id,
          hint: Text(
            'Choose a station',
            style: TextStyles.body.copyWith(color: ColorsManager.greycolor),
          ),
          icon:
              Icon(Icons.keyboard_arrow_down, color: ColorsManager.blackcolor),
          items: stations.map((station) {
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
              final stationCubit = context.read<StationCubit>();
              stationCubit.selectStation(stationId);
              // We find the station to animate to it
              try {
                final station = stations.firstWhere((s) => s.id == stationId);
                _animateMapToStation(station);
              } catch (e) {/* ignore */}
            }
          },
        ),
      ),
    );
  }

  Widget _buildMap(Station selectedStation) {
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
    Station? selectedStation,
    bool isConfirming,
    double totalPrice,
  ) {
    final canConfirm =
        selectedStation != null && selectedStation.isOpen && !isConfirming;

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

            // Checkout Button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Hero(
                tag: 'checkout_button',
                child: BlocConsumer<PaymentCubit, PaymentState>(
                  listener: (context, paymentState) {
                    if (paymentState is PaymentReady) {
                      _handlePresentPayment();
                    } else if (paymentState is PaymentSuccess) {
                      _handleOrderCreation();
                    } else if (paymentState is PaymentFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(paymentState.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, paymentState) {
                    final isLoading = paymentState is PaymentLoading ||
                        context.read<StationCubit>().state is StationLoading;

                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleCheckoutProcess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          disabledBackgroundColor:
                              ColorsManager.primary.withOpacity(0.6),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading)
                              SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            else ...[
                              const Text(
                                'Confirm & Pay',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              const Icon(Icons.arrow_forward_rounded, size: 24),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Station not selected warning
            if (selectedStation == null) ...[
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
            if (selectedStation != null && !selectedStation.isOpen) ...[
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

  Future<void> _handleCheckoutProcess() async {
    // 1. Validate Delivery Method
    final locationState = context.read<LocationCubit>().state;
    if (_selectedDeliveryMethod == 'delivery' &&
        locationState is! LocationLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery location')),
      );
      return;
    }

    if (_selectedDeliveryMethod == 'pickup') {
      final stationState = context.read<StationCubit>().state;
      if (stationState is! StationLoaded ||
          stationState.selectedStation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a pickup station')),
        );
        return;
      }
    }

    // 2. Init Payment Sheet
    final total = context.read<CartCubit>().state.total;
    // Amount in cents (e.g., $10.00 = 1000)
    final amountInCents = (total * 100).round().toDouble();

    await context.read<PaymentCubit>().initPaymentSheet(amountInCents);
  }

  Future<void> _handlePresentPayment() async {
    await context.read<PaymentCubit>().presentPaymentSheet();
  }

  Future<void> _handleOrderCreation() async {
    final cartState = context.read<CartCubit>().state;
    final stationState = context.read<StationCubit>().state;

    if (stationState is StationLoaded && stationState.selectedStation != null) {
      // Show local loading if needed, or rely on OrderCubit state
      // But we are already in "Success" of payment, so user expects navigation.

      await context.read<OrderCubit>().createOrder(
            items: cartState.items,
            station: stationState.selectedStation!,
            totalPrice: cartState.total,
          );

      if (!mounted) return;

      final orderState = context.read<OrderCubit>().state;
      if (orderState is OrderError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Order failed to save: ${orderState.message}')),
        );
      } else {
        context.read<CartCubit>().clearCart();
        context.pushReplacement('/order-success');
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/order_model.dart';
import 'package:testtt/presentation/widgets/empty_state_widget.dart';
import 'package:testtt/providers/order_provider.dart';

/// Orders Screen - Displays order history
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      appBar: AppBar(
        backgroundColor: ColorsManager.whitecolor,
        elevation: 0,
        title: Text(
          'Mes Commandes',
          style: GoogleFonts.roboto(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: ColorsManager.blackcolor,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          if (!orderProvider.hasOrders) {
            return EmptyStateWidget(
              hasSearch: false,
              hasFilter: false,
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return _OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

/// Order Card - Single order item in list
class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.blackcolor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _showOrderDetails(context),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Order ID + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.id,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorsManager.blackcolor,
                      ),
                    ),
                    _buildStatusBadge(),
                  ],
                ),
                SizedBox(height: 12.h),

                // Station info
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18.sp,
                      color: ColorsManager.greycolor,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        order.stationName,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsManager.blackcolor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Items summary + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.summaryText,
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        color: ColorsManager.greycolor,
                      ),
                    ),
                    Text(
                      _formatDate(order.createdAt),
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        color: ColorsManager.greycolor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Divider
                Divider(
                  color: ColorsManager.textfieldbordercolor,
                  height: 1,
                ),
                SizedBox(height: 12.h),

                // Total price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsManager.blackcolor,
                      ),
                    ),
                    Text(
                      PriceFormatter.formatPriceCAD(order.totalPrice),
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorsManager.primary,
                      ),
                    ),
                  ],
                ),

                // ETA for active orders
                if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.preparing) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: ColorsManager.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Prêt dans ~${order.estimatedMinutes ?? 15} min',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;

    switch (order.status) {
      case OrderStatus.pending:
        bgColor = ColorsManager.warning.withOpacity(0.15);
        textColor = ColorsManager.warning;
        break;
      case OrderStatus.preparing:
        bgColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue;
        break;
      case OrderStatus.ready:
        bgColor = ColorsManager.primary.withOpacity(0.15);
        textColor = ColorsManager.primary;
        break;
      case OrderStatus.completed:
        bgColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        bgColor = ColorsManager.redAccent.withOpacity(0.15);
        textColor = ColorsManager.redAccent;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        order.statusText,
        style: GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Color _getBorderColor() {
    switch (order.status) {
      case OrderStatus.ready:
        return ColorsManager.primary;
      case OrderStatus.preparing:
        return Colors.blue;
      default:
        return ColorsManager.textfieldbordercolor;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return "À l'instant";
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else if (diff.inDays == 1) {
      return 'Hier';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }
}

/// Order Details Bottom Sheet
class _OrderDetailsSheet extends StatelessWidget {
  final Order order;

  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: ColorsManager.greycolor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Détails de la commande',
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.blackcolor,
                  ),
                ),
                Text(
                  order.id,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.greycolor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Items list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ColorsManager.textfieldcolor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          item.imagePath,
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50.w,
                            height: 50.w,
                            color: ColorsManager.greycolor.withOpacity(0.2),
                            child: Icon(Icons.coffee,
                                color: ColorsManager.greycolor),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorsManager.blackcolor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${item.size} • x${item.quantity}',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: ColorsManager.greycolor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        PriceFormatter.formatPriceCAD(item.totalPrice),
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsManager.blackcolor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Station & Total
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: ColorsManager.whitecolor,
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.blackcolor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Station
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20.sp,
                        color: ColorsManager.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.stationName,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorsManager.blackcolor,
                              ),
                            ),
                            Text(
                              order.stationAddress,
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: ColorsManager.greycolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsManager.blackcolor,
                        ),
                      ),
                      Text(
                        PriceFormatter.formatPriceCAD(order.totalPrice),
                        style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

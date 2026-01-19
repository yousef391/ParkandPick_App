import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/presentation/cubits/cart/cart_cubit.dart';

/// Reusable Order Item Card Widget
/// Displays order item with swipe-to-dismiss functionality
class OrderItemCard extends StatefulWidget {
  final OrderItem item;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const OrderItemCard({
    super.key,
    required this.item,
    this.onRemove,
    this.onTap,
  });

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _heightAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _heightAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    if (_isDismissing) return;
    _isDismissing = true;

    _animationController.forward().then((_) {
      widget.onRemove?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.item.name} removed from cart',
              style: TextStyles.body.copyWith(color: ColorsManager.whitecolor),
            ),
            backgroundColor: ColorsManager.primary,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              textColor: ColorsManager.whitecolor,
              onPressed: () {
                // Restore item via cubit
                context.read<CartCubit>().addToCart(widget.item);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissing) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scaleY: _heightAnimation.value,
              child: _buildCard(),
            ),
          );
        },
      );
    }

    return Dismissible(
      key: ValueKey(
        '${widget.item.id}_${widget.item.size}_${widget.item.addons.join('_')}',
      ),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: ColorsManager.redAccent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: Icon(
          Icons.delete_outline,
          color: ColorsManager.whitecolor,
          size: 24.sp,
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: ColorsManager.redAccent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(
          Icons.delete_outline,
          color: ColorsManager.whitecolor,
          size: 24.sp,
        ),
      ),
      onDismissed: (_) => _handleDismiss(),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.textfieldbordercolor),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: ColorsManager.softGrey,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                widget.item.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.coffee,
                  color: ColorsManager.primary,
                  size: 32.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: TextStyles.body.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.item.size,
                  style: TextStyles.smallText.copyWith(
                    color: ColorsManager.greycolor,
                  ),
                ),
                if (widget.item.addons.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Add-ons: ${widget.item.addons.join(', ')}',
                    style: TextStyles.smallText.copyWith(
                      color: ColorsManager.greycolor,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 6.h),
                Text(
                  PriceFormatter.formatPriceCAD(widget.item.price),
                  style: TextStyles.body.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.primary,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          _buildQuantityControls(),
        ],
      ),
    );
  }

  Widget _buildQuantityControls() {
    // We don't need Consumer/BlocBuilder here because parent rebuilds on state change
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.textfieldbordercolor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onTap: () {
              context.read<CartCubit>().decrementQuantity(
                    widget.item.id,
                    size: widget.item.size,
                  );
            },
          ),
          Container(
            width: 36.w,
            alignment: Alignment.center,
            child: Text(
              '${widget.item.quantity}',
              style: TextStyles.body.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.primaryDark,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onTap: () {
              context.read<CartCubit>().incrementQuantity(
                    widget.item.id,
                    size: widget.item.size,
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 32.w,
        height: 32.h,
        alignment: Alignment.center,
        child: Icon(icon, size: 18.sp, color: ColorsManager.primary),
      ),
    );
  }
}

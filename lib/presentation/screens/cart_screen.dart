import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/presentation/cubits/cart/cart_cubit.dart';

/// Cart Screen - View and manage cart items before checkout
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      appBar: AppBar(
        backgroundColor: ColorsManager.whitecolor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorsManager.blackcolor,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Mon Panier',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorsManager.blackcolor,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _buildEmptyCart(context);
          }
          return _buildCartContent(context, state);
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80.sp,
              color: ColorsManager.greycolor,
            ),
            SizedBox(height: 24.h),
            Text(
              'Votre panier est vide',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.blackcolor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ajoutez des produits pour commencer',
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                color: ColorsManager.greycolor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(color: ColorsManager.blackcolor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Continuer vos achats',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.blackcolor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartState state) {
    final cartCubit = context.read<CartCubit>();
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _CartItemCard(
                  item: item,
                  onIncrement: () => cartCubit.incrementQuantity(
                    item.id,
                    size: item.size,
                  ),
                  onDecrement: () => cartCubit.decrementQuantity(
                    item.id,
                    size: item.size,
                  ),
                  onRemove: () => cartCubit.removeFromCart(
                    item.id,
                    item.size,
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Section - Total & Checkout
        _buildBottomSection(context, state),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context, CartState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 80.h),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        border: Border(
          top: BorderSide(color: ColorsManager.textfieldbordercolor),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.itemCount} article${state.itemCount > 1 ? 's' : ''}',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: ColorsManager.greycolor,
                  ),
                ),
                Text(
                  PriceFormatter.formatPriceCAD(state.total),
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.blackcolor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primary,
                  foregroundColor: ColorsManager.whitecolor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Commander',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual cart item card with quantity controls
class _CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.whitecolor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.textfieldbordercolor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              item.imagePath,
              width: 70.w,
              height: 70.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70.w,
                height: 70.w,
                color: ColorsManager.softGrey,
                child: Icon(
                  Icons.coffee,
                  color: ColorsManager.greycolor,
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
                // Name & Remove button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsManager.blackcolor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: ColorsManager.greycolor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Size
                Text(
                  item.size,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: ColorsManager.greycolor,
                  ),
                ),
                SizedBox(height: 8.h),

                // Price & Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      PriceFormatter.formatPriceCAD(item.price),
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.blackcolor,
                      ),
                    ),

                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorsManager.textfieldbordercolor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onTap: onDecrement,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              '${item.quantity}',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorsManager.blackcolor,
                              ),
                            ),
                          ),
                          _QuantityButton(
                            icon: Icons.add,
                            onTap: onIncrement,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Icon(
          icon,
          size: 16.sp,
          color: ColorsManager.blackcolor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/constants/text_manager.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/presentation/widgets/button_widget.dart';

/// Bottom navigation bar for product details
/// Dumb widget - accepts callback, no business logic
class CustomProductDetailsBottomnavbar extends StatelessWidget {
  const CustomProductDetailsBottomnavbar({
    super.key,
    required this.onBuy,
    this.label,
    this.price,
  });

  final VoidCallback onBuy;
  final String? label;
  final double? price;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorsManager.whitecolor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.blackcolor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (price != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsManager.greycolor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      PriceFormatter.formatPriceCAD(price!),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorsManager.primary,
                      ),
                    ),
                  ],
                ),
              ),
            if (price != null) SizedBox(width: 12.w),
            Expanded(
              flex: price != null ? 1 : 1,
              child: ButtonWidget(
                title: label ?? TextManager.buyTitle,
                onTap: onBuy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

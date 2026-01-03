import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

/// Delivery Method Selection Widget
/// Allows user to choose between Pickup and Delivery
class DeliveryMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const DeliveryMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Méthode de réception',
          style: TextStyles.heading2.copyWith(
            fontSize: 18.sp,
            color: ColorsManager.blackcolor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildOption(context, 'pickup', 'Ramassage', Icons.storefront),
            SizedBox(width: 16.w),
            _buildOption(
                context, 'delivery', 'Livraison', Icons.delivery_dining),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(
      BuildContext context, String value, String label, IconData icon) {
    final isSelected = selectedMethod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color:
                isSelected ? ColorsManager.primary : ColorsManager.whitecolor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? ColorsManager.primary
                  : ColorsManager.textfieldbordercolor,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ColorsManager.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isSelected
                      ? ColorsManager.whitecolor
                      : ColorsManager.primary,
                  size: 28.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyles.bodyBold.copyWith(
                  color: isSelected
                      ? ColorsManager.whitecolor
                      : ColorsManager.primary,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/core/utils/delivery_service.dart';

/// Delivery Options Widget - External delivery via DoorDash / Uber Eats
/// Minimalist design for professional look
class DeliveryOptionsWidget extends StatelessWidget {
  const DeliveryOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Simple text
          Text(
            'Livraison à domicile',
            style: TextStyles.sectionTitle.copyWith(
              color: ColorsManager.blackcolor,
            ),
          ),
          SizedBox(height: 12.h),

          // Delivery buttons row
          Row(
            children: [
              // DoorDash Button
              Expanded(
                child: _DeliveryButton(
                  label: 'DoorDash',
                  onTap: () => _handleDoorDash(context),
                ),
              ),
              SizedBox(width: 12.w),
              // Uber Eats Button
              Expanded(
                child: _DeliveryButton(
                  label: 'Uber Eats',
                  onTap: () => _handleUberEats(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleDoorDash(BuildContext context) async {
    final success = await DeliveryService.openDoorDash();
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d\'ouvrir DoorDash'),
          backgroundColor: ColorsManager.blackcolor,
        ),
      );
    }
  }

  void _handleUberEats(BuildContext context) async {
    final success = await DeliveryService.openUberEats();
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible d\'ouvrir Uber Eats'),
          backgroundColor: ColorsManager.blackcolor,
        ),
      );
    }
  }
}

/// Individual delivery service button - Minimalist style
class _DeliveryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DeliveryButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: ColorsManager.whitecolor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: ColorsManager.textfieldbordercolor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.blackcolor,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.arrow_outward_rounded,
                size: 16.sp,
                color: ColorsManager.greycolor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

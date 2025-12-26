import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/product_extra.dart';

/// Addons Selector Widget - Professional & Clean
/// Responsibilities:
/// - Display available product extras
/// - Show selection state from provider
/// - Trigger provider methods on user interaction
/// - NO business logic in widget (separation of concerns)
class AddonsSelector extends StatelessWidget {
  final List<ProductExtra> availableExtras;
  final List<ProductExtra> selectedExtras;
  final VoidCallback onExtrasChanged;
  final bool showGroupHeaders;
  final EdgeInsets? padding;

  const AddonsSelector({
    super.key,
    required this.availableExtras,
    required this.selectedExtras,
    required this.onExtrasChanged,
    this.showGroupHeaders = true,
    this.padding,
  });

  bool _isSelected(ProductExtra extra) {
    return selectedExtras.any((e) => e.id == extra.id);
  }

  Map<ExtraType, List<ProductExtra>> _groupExtrasByType() {
    final Map<ExtraType, List<ProductExtra>> grouped = {};
    for (var extra in availableExtras) {
      grouped.putIfAbsent(extra.type, () => []).add(extra);
    }
    return grouped;
  }

  String _getTypeDisplayName(ExtraType type) {
    switch (type) {
      case ExtraType.coffee:
        return 'Coffee Extras';
      case ExtraType.milk:
        return 'Milk Options';
      case ExtraType.sweetener:
        return 'Sweeteners';
      case ExtraType.syrup:
        return 'Flavored Syrups';
      case ExtraType.topping:
        return 'Toppings';
      case ExtraType.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (availableExtras.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 20.h),
          if (showGroupHeaders)
            ..._buildGroupedExtras()
          else
            ..._buildFlatExtrasList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add-ons',
          style: TextStyles.heading2.copyWith(
            fontSize: 20.sp,
            color: ColorsManager.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Customize your order',
          style: TextStyles.smallText.copyWith(
            color: ColorsManager.greycolor,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGroupedExtras() {
    final grouped = _groupExtrasByType();
    final widgets = <Widget>[];

    grouped.forEach((type, extras) {
      widgets.add(_buildGroupHeader(type));
      for (var extra in extras) {
        widgets.add(_buildExtraItem(extra));
        widgets.add(SizedBox(height: 8.h));
      }
      widgets.add(SizedBox(height: 12.h));
    });

    return widgets;
  }

  Widget _buildGroupHeader(ExtraType type) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        _getTypeDisplayName(type),
        style: TextStyles.body.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: ColorsManager.primaryDark,
        ),
      ),
    );
  }

  List<Widget> _buildFlatExtrasList() {
    return availableExtras
        .map(
          (extra) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildExtraItem(extra),
          ),
        )
        .toList();
  }

  Widget _buildExtraItem(ProductExtra extra) {
    final isSelected = _isSelected(extra);
    final isFree = extra.price == 0;

    return GestureDetector(
      onTap: extra.isAvailable ? onExtrasChanged : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsManager.primary.withOpacity(0.08)
              : ColorsManager.whitecolor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? ColorsManager.primary
                : ColorsManager.textfieldbordercolor,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            _buildCheckbox(isSelected),
            SizedBox(width: 12.w),
            _buildExtraIcon(extra),
            SizedBox(width: 12.w),
            _buildExtraName(extra, isSelected),
            _buildPriceBadge(extra, isFree),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: isSelected ? ColorsManager.primary : ColorsManager.whitecolor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? ColorsManager.primary : ColorsManager.greycolor,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 16.sp, color: ColorsManager.whitecolor)
          : null,
    );
  }

  Widget _buildExtraIcon(ProductExtra extra) {
    return Text(extra.icon, style: TextStyle(fontSize: 20.sp));
  }

  Widget _buildExtraName(ProductExtra extra, bool isSelected) {
    return Expanded(
      child: Text(
        extra.name,
        style: TextStyles.body.copyWith(
          fontSize: 15.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: extra.isAvailable
              ? ColorsManager.primaryDark
              : ColorsManager.greycolor,
        ),
      ),
    );
  }

  Widget _buildPriceBadge(ProductExtra extra, bool isFree) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isFree
            ? ColorsManager.greenColor.withOpacity(0.1)
            : ColorsManager.softGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        isFree ? 'Free' : '+${PriceFormatter.formatPriceCAD(extra.price)}',
        style: TextStyles.smallText.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isFree ? ColorsManager.greenColor : ColorsManager.primaryDark,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(
              Icons.coffee_outlined,
              size: 48.sp,
              color: ColorsManager.greycolor.withOpacity(0.5),
            ),
            SizedBox(height: 12.h),
            Text(
              'No add-ons available',
              style: TextStyles.body.copyWith(
                color: ColorsManager.greycolor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

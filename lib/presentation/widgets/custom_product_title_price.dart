import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/text_styles.dart';

class CustomProductHeader extends StatefulWidget {
  const CustomProductHeader({
    super.key,
    required this.title,
    required this.price,
    required this.category,
  });
  final String title;
  final String price;
  final String category;

  @override
  State<CustomProductHeader> createState() => _CustomProductHeaderState();
}

class _CustomProductHeaderState extends State<CustomProductHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: TextStyles.heading2),
              SizedBox(height: 10.h),
              Text(widget.category, style: TextStyles.body),
            ],
          ),
          Text("${widget.price}", style: TextStyles.smallText),
        ],
      ),
    );
  }
}

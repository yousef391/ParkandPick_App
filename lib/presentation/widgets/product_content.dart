import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/cubits/product_details/product_details_cubit.dart';

class ProductContent extends StatelessWidget {
  const ProductContent({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context
                    .read<ProductDetailsCubit>()
                    .toggleDescriptionExpanded(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Description", style: TextStyles.body),
                    Icon(
                      state.isDescriptionExpanded
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      color: ColorsManager.primaryDark,
                      size: 28.r,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              AnimatedCrossFade(
                firstChild: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.smallText,
                ),
                secondChild: Text(description, style: TextStyles.smallText),
                crossFadeState: state.isDescriptionExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        );
      },
    );
  }
}

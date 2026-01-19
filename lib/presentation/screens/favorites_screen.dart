import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:testtt/presentation/widgets/empty_state_widget.dart';
import 'package:testtt/core/routes/app_pages.dart';

/// Favorites Screen
/// Displays user's favorite products with cubit-driven data
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      appBar: AppBar(
        backgroundColor: ColorsManager.whitecolor,
        elevation: 0,
        title: Text(
          'Favorites',
          style: TextStyles.heading2.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isEmpty) {
            return const EmptyStateWidget(hasSearch: false, hasFilter: false);
          }
          final favorites = state.favorites;
          final favoritesCubit = context.read<FavoritesCubit>();
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final product = favorites[index];
              return _FavoriteItem(
                product: product,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetails,
                    arguments: ProductDetailsArgs(
                      id: product.id,
                      image: product.imageUrl,
                      title: product.name,
                      price: product.price.toString(),
                      description: product.description,
                      category: product.category,
                    ),
                  );
                },
                onToggleFavorite: () => favoritesCubit.toggleFavorite(product),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const _FavoriteItem({
    required this.product,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorsManager.whitecolor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.textfieldbordercolor),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.blackcolor.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  width: 64.w,
                  height: 64.h,
                  color: ColorsManager.softGrey,
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.coffee, color: ColorsManager.primary),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyles.bodyBold.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.description,
                      style: TextStyles.smallText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      PriceFormatter.formatPriceCAD(product.price),
                      style: TextStyles.bodyBold.copyWith(
                        color: ColorsManager.primary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                tooltip: 'Remove from favorites',
                icon: const Icon(
                  Icons.favorite,
                  color: ColorsManager.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testtt/core/constants/text_manager.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart' show TextStyles;
import 'package:testtt/core/utils/price_formatter.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/presentation/widgets/custom_bottomnavbar.dart';
import 'package:testtt/presentation/widgets/custom_iconbutton.dart';
import 'package:testtt/presentation/widgets/custom_product_title_price.dart';
import 'package:testtt/presentation/widgets/product_content.dart';
import 'package:testtt/presentation/widgets/size_container_widget.dart';
import 'package:testtt/providers/cart_provider.dart';
import 'package:testtt/providers/products_details_provider.dart';

class ProductScreenDetails extends StatefulWidget {
  const ProductScreenDetails({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    this.category = 'Coffee',
  });

  final String id;
  final String image;
  final String title;
  final String price;
  final String description;
  final String category;

  @override
  State<ProductScreenDetails> createState() => _ProductScreenDetailsState();
}

class _ProductScreenDetailsState extends State<ProductScreenDetails> {
  bool isfavorite = false;

  @override
  void dispose() {
    // Reset provider state when leaving screen
    context.read<ProductDetailsProvider>().resetState();
    super.dispose();
  }

  void _handleAddToCart(BuildContext context) {
    final detailsProvider = context.read<ProductDetailsProvider>();
    final cartProvider = context.read<CartProvider>();

    // Create OrderItem from current selections
    final orderItem = OrderItem(
      id: widget.id,
      name: widget.title,
      size: detailsProvider.selectedSized,
      price: double.tryParse(widget.price) ?? 0.0,
      imagePath: widget.image,
      quantity: detailsProvider.quantity,
      addons: detailsProvider.selectedAddons,
    );

    // Add to cart
    cartProvider.addToCart(orderItem);

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ajouté au panier',
          style: TextStyles.body.copyWith(color: ColorsManager.whitecolor),
        ),
        backgroundColor: ColorsManager.blackcolor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Voir',
          textColor: ColorsManager.whitecolor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailsProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorsManager.whitecolor,
                ),
              ),
              actions: [
                CustomIconbutton(
                  icon: isfavorite
                      ? const Icon(
                          Icons.favorite,
                          color: ColorsManager.redAccent,
                        )
                      : const Icon(Icons.favorite_border_rounded),
                  ontap: () {
                    setState(() {
                      isfavorite = !isfavorite;
                    });
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.image,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: ColorsManager.softGrey,
                        child: Icon(
                          Icons.coffee,
                          size: 80.sp,
                          color: ColorsManager.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomProductHeader(
                    title: widget.title,
                    price: PriceFormatter.formatPriceCAD(
                      double.tryParse(widget.price) ?? 0.0,
                    ),
                    category: widget.category,
                  ),
                  SizedBox(height: 24.h),

                  // Description Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      TextManager.discTitle,
                      style: TextStyles.heading2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ProductContent(description: widget.description),
                  SizedBox(height: 24.h),

                  // Size Selection
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      TextManager.sizeTitle,
                      style: TextStyles.heading2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizeContainerWidget(
                            isSelected:
                                provider.selectedSized == TextManager.smallSize,
                            size: TextManager.smallSize,
                            ontap: () {
                              provider.setSelectedSize(TextManager.smallSize);
                            },
                          ),
                          SizedBox(width: 14.w),
                          SizeContainerWidget(
                            isSelected: provider.selectedSized ==
                                TextManager.middleSize,
                            size: TextManager.middleSize,
                            ontap: () {
                              provider.setSelectedSize(TextManager.middleSize);
                            },
                          ),
                          SizedBox(width: 14.w),
                          SizeContainerWidget(
                            isSelected:
                                provider.selectedSized == TextManager.longSize,
                            size: TextManager.longSize,
                            ontap: () {
                              provider.setSelectedSize(TextManager.longSize);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Quantity Controls
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity', style: TextStyles.heading2),
                        SizedBox(height: 12.h),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorsManager.textfieldbordercolor,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: provider.decrementQuantity,
                                icon: Icon(
                                  Icons.remove,
                                  color: ColorsManager.primary,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  '${provider.quantity}',
                                  style: TextStyles.body.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: provider.incrementQuantity,
                                icon: Icon(
                                  Icons.add,
                                  color: ColorsManager.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Addons Selector (placeholder - needs product extras data)
                  // AddonsSelector(
                  //   availableExtras: [],
                  //   selectedExtras: provider.selectedAddons
                  //       .map((name) => ProductExtra(name: name, ...))
                  //       .toList(),
                  //   onExtrasChanged: (extra) => provider.toggleAddon(extra.name),
                  // ),
                  SizedBox(height: 100.h), // Space for bottom navbar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomProductDetailsBottomnavbar(
        price: double.tryParse(widget.price) ?? 0.0,
        label: 'Ajouter au panier',
        onBuy: () => _handleAddToCart(context),
      ),
    );
  }
}

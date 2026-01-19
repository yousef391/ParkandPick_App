import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/extensions/sizedbox_extension.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/presentation/cubits/product/product_cubit.dart';
import 'package:testtt/presentation/widgets/categoy_chip_widdget.dart';
import 'package:testtt/presentation/widgets/empty_state_widget.dart';
import 'package:testtt/presentation/widgets/gretting_sectiond.dart';
import 'package:testtt/presentation/widgets/nearby_stations_widget.dart';
import 'package:testtt/presentation/widgets/product_card_widget.dart';
import 'package:testtt/presentation/widgets/search_bar_widget.dart';
import 'package:go_router/go_router.dart';

/// Home Screen - Coffee Products List
/// Features: Greeting, Search, Category Filter, Product Grid
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _greetingAnimationController;
  late Animation<double> _greetingFadeAnimation;
  late Animation<Offset> _greetingSlideAnimation;

  // Categories
  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'All'},
    {'id': 'cafe', 'label': 'Café'},
    {'id': 'boissons', 'label': 'Boissons'},
    {'id': 'lunch', 'label': 'Boîte Lunch'},
    {'id': 'snacks', 'label': 'Snacks'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Load products on init
    context.read<ProductCubit>().fetchProducts();
  }

  void _initializeAnimations() {
    _greetingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _greetingFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _greetingAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _greetingSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _greetingAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _greetingAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _greetingAnimationController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    final cubit = context.read<ProductCubit>();
    _searchController.clear();
    cubit.searchProducts('');
    cubit.filterByCategory('all');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            String selectedCategory = 'all';
            List<Product> filteredProducts = [];
            bool isLoading = false;
            String searchQuery = '';

            if (state is ProductLoaded) {
              selectedCategory = state.selectedCategory;
              filteredProducts = state.filteredProducts;
              searchQuery = state.searchQuery;
            } else if (state is ProductLoading) {
              isLoading = true;
            }

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Animated Greeting Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _greetingFadeAnimation,
                    child: SlideTransition(
                      position: _greetingSlideAnimation,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const GreetingSection(),
                            SizedBox(height: 20.h),
                            SearchBarWidget(
                              controller: _searchController,
                              searchQuery: searchQuery,
                              onChanged: (value) {
                                context
                                    .read<ProductCubit>()
                                    .searchProducts(value);
                              },
                              onClear: () {
                                _searchController.clear();
                                context.read<ProductCubit>().searchProducts('');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Nearby Stations Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                    child: const NearbyStationsWidget(),
                  ),
                ),

                // Category Chips
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50.h,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return CategoryChip(
                          label: category['label']!,
                          isSelected: selectedCategory == category['id'],
                          onTap: () {
                            context
                                .read<ProductCubit>()
                                .filterByCategory(category['id']!);
                          },
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20.h).toSliver(),

                // Products Grid or Empty State
                if (isLoading)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200.h,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (filteredProducts.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 64.h,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: EmptyStateWidget(
                          hasSearch: searchQuery.isNotEmpty,
                          hasFilter: selectedCategory != 'all',
                          onClearFilters: _clearFilters,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.w,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          index: index,
                          onTap: () =>
                              _navigateToProductDetail(filteredProducts[index]),
                        );
                      }, childCount: filteredProducts.length),
                    ),
                  ),

                // Bottom padding
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + 20.h,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    context.push(
      '/product/${product.id}',
      extra: {'product': product},
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/extensions/sizedbox_extension.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/presentation/widgets/categoy_chip_widdget.dart';
import 'package:testtt/presentation/widgets/delivery_options_widget.dart';
import 'package:testtt/presentation/widgets/empty_state_widget.dart';
import 'package:testtt/presentation/widgets/gretting_sectiond.dart';
import 'package:testtt/presentation/widgets/nearby_stations_widget.dart';
import 'package:testtt/presentation/widgets/product_card_widget.dart';
import 'package:testtt/presentation/widgets/search_bar_widget.dart';
import 'package:testtt/core/routes/app_pages.dart';

/// Home Screen - Coffee Products List
/// Features: Greeting, Search, Category Filter, Product Grid
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _greetingAnimationController;
  late Animation<double> _greetingFadeAnimation;
  late Animation<Offset> _greetingSlideAnimation;

  // Categories
  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'label': 'All'},
    {'id': 'cup', 'label': 'Cup'},
    {'id': 'café', 'label': 'Café'},
    {'id': 'beans', 'label': 'Beans'},
    {'id': 'ground', 'label': 'Ground'},
    {'id': 'specials', 'label': 'Specials'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProducts();
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

  void _loadProducts() {
    // TODO: Load products from provider when API is ready
    // final provider = Provider.of<ProductProvider>(context, listen: false);
    // provider.fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _greetingAnimationController.dispose();
    super.dispose();
  }

  List<Product> _getFilteredProducts() {
    // TODO: Replace with provider data
    // final provider = Provider.of<ProductProvider>(context);
    // List<Product> filtered = provider.products;

    // Use centralized mock data from ProductExamples
    List<Product> filtered = ProductExamples.getAllProducts();

    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final nameLower = product.name.toLowerCase();
        final descLower = product.description.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower) || descLower.contains(queryLower);
      }).toList();
    }

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: CustomScrollView(
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
                          searchQuery: _searchQuery,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          onClear: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
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

            // Delivery Options - DoorDash / Uber Eats
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: const DeliveryOptionsWidget(),
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
                      isSelected: _selectedCategory == category['id'],
                      onTap: () {
                        setState(() {
                          _selectedCategory = category['id']!;
                        });
                      },
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 20.h).toSliver(),

            // Products Grid or Empty State
            filteredProducts.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 64.h,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: EmptyStateWidget(
                          hasSearch: _searchQuery.isNotEmpty,
                          hasFilter: _selectedCategory != 'all',
                          onClearFilters: _clearFilters,
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
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
        ),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
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
  }
}

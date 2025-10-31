import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/Constants/routes.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/currency_dropdown.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import 'package:mytravaly_flutter_assesment/Models/filtered_hotel_model.dart';
import 'package:mytravaly_flutter_assesment/Screens/filtered_hotels.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/button_type.dart';
import 'package:mytravaly_flutter_assesment/Utils/helpers/loader.dart';
import '../../Services/popular_stay_service.dart';
import '../CustomUI/CustomWidgets/filter_bottom_sheet.dart';
import '../Models/hotel_filter_model.dart';
import '../Models/popular_stays_model.dart';
import '../services/hotel_filter_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<PopularStay>>? _futureStays;

  HotelFilter _filter = HotelFilter(
    checkIn: DateTime.now(),
    checkOut: DateTime.now().add(const Duration(days: 1)),
    rooms: 2,
    adults: 2,
    children: 0,
    arrayOfExcludedSearchType: [],
    rid: 0,
    limit: 5,
    preloaderList: [],
    searchType: 'hotelIdSearch',
  );

  @override
  void initState() {
    super.initState();
    _futureStays = PopularStayService.fetchPopularStays();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: FilterBottomSheet(
              initialFilter: _filter,
              onApply: (updatedFilter) {
                setState(() {
                  _filter = updatedFilter;
                  final hotelsFuture =
                  HotelService.fetchHotels(filter: _filter, context: context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => FilteredHotels(
                        filteredHotelFuture: hotelsFuture,
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _showStayDetails(PopularStay stay) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stay.propertyName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${stay.propertyStar} ★  |  ${stay.googleReview.overallRating} ⭐ (${stay.googleReview.totalUserRating} reviews)",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${stay.propertyAddress.street}, ${stay.propertyAddress.city}, ${stay.propertyAddress.state}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      stay.propertyImage,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/no_image.jpg',
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Policies & Amenities",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPolicyList(stay, theme),
                  const SizedBox(height: 16),
                  Text(
                    "Pricing",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _priceTag("Static Price", stay.staticPrice.displayAmount, theme),
                      _priceTag("Marked Price", stay.markedPrice.displayAmount, theme),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Center(
                  //   child: ElevatedButton.icon(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: theme.colorScheme.primary,
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 24, vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     icon: const Icon(Icons.open_in_new, color: Colors.white),
                  //     label: const Text("View Details", style: TextStyle(color: Colors.white)),
                  //     onPressed: () => Navigator.pushNamed(
                  //       context,
                  //       Routes.webView,
                  //       arguments: stay.propertyUrl,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _priceTag(String title, String amount, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
        const SizedBox(height: 4),
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyList(PopularStay stay, ThemeData theme) {
    final p = stay.propertyPoliciesAndAmenities.data;
    if (p == null) {
      return Text("No policies available.",
          style: theme.textTheme.bodyMedium);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _policyItem("Cancel Policy", p.cancelPolicy, theme),
        _policyItem("Refund Policy", p.refundPolicy, theme),
        _policyItem("Child Policy", p.childPolicy, theme),
        _policyItem("Damage Policy", p.damagePolicy, theme),
        _policyItem("Restrictions", p.propertyRestriction, theme),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip("Free Wi-Fi", p.freeWifi, theme),
            _chip("Free Cancellation", p.freeCancellation, theme),
            _chip("Pay Now", p.payNow, theme),
            _chip("Pay at Hotel", p.payAtHotel, theme),
            _chip("Couple Friendly", p.coupleFriendly, theme),
            _chip("Pets Allowed", p.petsAllowed, theme),
          ],
        ),
      ],
    );
  }

  Widget _policyItem(String title, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          text: "$title: ",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.normal,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool active, ThemeData theme) {
    return Chip(
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: active
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
      backgroundColor: active
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPageView(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.searchHotelList),
                      prefixIcon: Icons.search,
                      text: "Search",
                      type: ButtonType.warning,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.filter_list_rounded,
                          color: theme.colorScheme.primary),
                      tooltip: "Filter",
                      onPressed: _openFilterSheet,
                    ),
                  ],
                ),
                CurrencyDropdown(onCurrencyChange: (val){
                  print(val);
                  setState(() {
                    _futureStays = PopularStayService.fetchPopularStays();

                  });

                },),
              ],
            ),
          ),

          // List
          Expanded(
            child: FutureBuilder<List<PopularStay>>(
              future: _futureStays,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomLoader());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error)),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No stays found",
                        style: theme.textTheme.bodyMedium),
                  );
                }

                final stays = snapshot.data!;
                return ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: stays.length,
                  itemBuilder: (context, index) {
                    final stay = stays[index];
                    return Card(
                      color: theme.colorScheme.surface,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: isDark ? 0 : 3,
                      shadowColor: theme.shadowColor.withOpacity(0.2),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _showStayDetails(stay),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: Image.network(
                                stay.propertyImage,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/no_image.jpg',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    height: 180,
                                    color: theme.colorScheme.surfaceContainerHighest
                                        .withOpacity(0.3),
                                    child: const Center(child: CustomLoader()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stay.propertyName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber.withOpacity(0.8),
                                          size: 18),
                                      const SizedBox(width: 4),
                                      Text(stay.googleReview.overallRating.toString(),
                                          style: theme.textTheme.bodyMedium),
                                      const Spacer(),

                                      Text(
                                        "${stay.staticPrice.currencySymbol} ${stay.staticPrice.currencyAmount}",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    stay.propertyAddress.city,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

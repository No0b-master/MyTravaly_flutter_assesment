import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/Constants/routes.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/currency_dropdown.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/filter_bottom_sheet.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import 'package:mytravaly_flutter_assesment/Models/filtered_hotel_model.dart';
import 'package:mytravaly_flutter_assesment/Screens/filtered_hotels.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/button_type.dart';
import 'package:mytravaly_flutter_assesment/Utils/helpers/date_formator.dart';
import 'package:mytravaly_flutter_assesment/Utils/helpers/loader.dart';
import '../../Services/popular_stay_service.dart';
import '../Models/hotel_filter_model.dart';
import '../Models/popular_stays_model.dart';
import '../Utils/helpers/snackbar_message.dart';
import '../services/hotel_filter_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<PopularStay>>? _futureStays;
  late Future<List<FilteredHotelModel>?>? _hotelsFuture;
  HotelFilter _filter = HotelFilter(
    checkIn: DateTime.now(),
    checkOut: DateTime.now().add(Duration(days: 1)),
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
                print(updatedFilter);

                setState(() {
                  _filter = updatedFilter;

                  _hotelsFuture = HotelService.fetchHotels(filter: _filter, context: context);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> FilteredHotels(
                    filteredHotelFuture: _hotelsFuture,

                  ))) ;
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPageView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "Popular Stays",
                //   style: theme.textTheme.headlineSmall?.copyWith(
                //     fontWeight: FontWeight.bold,
                //     color: theme.colorScheme.onBackground,
                //   ),
                // ),
                Row(
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.searchHotelList);
                      },
                      prefixIcon: Icons.search,
                      text: "Search",
                      type: ButtonType.warning,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      tooltip: "Filter",
                      onPressed: _openFilterSheet,
                    ),
                  ],
                ),
                CurrencyDropdown()
              ],
            ),
          ),

          // --- Future Builder Section ---
          Expanded(
            child: FutureBuilder<List<PopularStay>>(
              future: _futureStays,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomLoader());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No stays found",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  );
                }

                final stays = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Image with fallback ---
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                stay.propertyImage,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/no_image.jpg',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 180,
                                        color: theme.colorScheme.surfaceVariant
                                            .withOpacity(0.3),
                                        child: const Center(
                                          child: CustomLoader(),
                                        ),
                                      );
                                    },
                              ),
                            ),

                            // --- Stay Info ---
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stay.propertyName,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber.withValues(
                                          alpha: 0.8,
                                        ),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        stay.rating.toString(),
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const Spacer(),
                                      Text(
                                        "₹${stay.staticPrice.toStringAsFixed(0)}",
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
                                    stay.city,
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

import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/filtered_hotel_model.dart';

class FilteredHotels extends StatelessWidget {
  final Future<List<FilteredHotelModel>?>? filteredHotelFuture;
  const FilteredHotels({super.key, this.filteredHotelFuture});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPageView(
      child: FutureBuilder<List<FilteredHotelModel>?>(
        future: filteredHotelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong 😞",
                style: theme.textTheme.titleMedium,
              ),
            );
          }

          final hotels = snapshot.data ?? [];
          if (hotels.isEmpty) {
            return const Center(child: Text("No hotels found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return _buildHotelCard(context, hotel);
            },
          );
        },
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, FilteredHotelModel hotel) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showHotelDetails(context, hotel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image and Rating Badge ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      hotel.propertyImage.fullUrl.isNotEmpty
                          ? hotel.propertyImage.fullUrl
                          : "https://via.placeholder.com/400x200.png?text=No+Image",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          hotel.googleReview?.data?.overallRating
                              .toStringAsFixed(1) ??
                              "N/A",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- Basic Info ---
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.propertyName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.propertyAddress.city.isNotEmpty
                              ? hotel.propertyAddress.city
                              : "Unknown Location",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${hotel.propertyMinPrice.currencySymbol}${hotel.propertyMinPrice.amount.toStringAsFixed(0)}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "/ night",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- Modal Bottom Sheet with full hotel details ---
  void _showHotelDetails(BuildContext context, FilteredHotelModel hotel) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  hotel.propertyName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hotel.propertyAddress.mapAddress,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    hotel.propertyImage.fullUrl.isNotEmpty
                        ? hotel.propertyImage.fullUrl
                        : "https://via.placeholder.com/400x200.png?text=No+Image",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 16),

                _infoTile("City", hotel.propertyAddress.city),
                _infoTile("Country", hotel.propertyAddress.country),
                _infoTile("Room", hotel.roomName),
                _infoTile("Adults", hotel.numberOfAdults.toString()),
                _infoTile("Property Type", hotel.propertyType),
                _infoTile("Stars", "${hotel.propertyStar} ⭐"),
                _infoTile("Google Rating",
                    "${hotel.googleReview?.data?.overallRating ?? 'N/A'} (${hotel.googleReview?.data?.totalUserRating ?? 0} reviews)"),

                const Divider(height: 24),

                Text("Available Deals",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (hotel.availableDeals.isEmpty)
                  Text("No deals available",
                      style: theme.textTheme.bodyMedium)
                else
                  ...hotel.availableDeals.map((deal) => ListTile(
                    title: Text(deal.headerName),
                    subtitle: Text(deal.dealType),
                    trailing: Text(
                      "${deal.price.currencySymbol}${deal.price.amount.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),

                const Divider(height: 24),

                Text("Price Details",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _infoTile("Marked Price",
                    "${hotel.markedPrice.currencySymbol}${hotel.markedPrice.amount}"),
                _infoTile("Min Price",
                    "${hotel.propertyMinPrice.currencySymbol}${hotel.propertyMinPrice.amount}"),
                _infoTile("Max Price",
                    "${hotel.propertyMaxPrice.currencySymbol}${hotel.propertyMaxPrice.amount}"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 4, child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

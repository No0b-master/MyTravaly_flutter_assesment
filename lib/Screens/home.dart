import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/Constants/routes.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/button_type.dart';
import '../../Services/popular_stay_service.dart';
import '../Models/popular_stays_model.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                Text(
                  "Popular Stays",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.searchHotelList);

                  },
                  prefixIcon: Icons.search,
                  text: "Search Hotels",
                  type: ButtonType.warning,

                ),
              ],
            ),
          ),

          // --- Future Builder Section ---
          Expanded(
            child: FutureBuilder<List<PopularStay>>(
              future: PopularStayService.fetchPopularStays(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                        onTap: () {
                          // TODO: navigate to stay details or open URL
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Image with fallback ---
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
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
                                        child: CircularProgressIndicator()),
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
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber.withOpacity(0.8),
                                          size: 18),
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

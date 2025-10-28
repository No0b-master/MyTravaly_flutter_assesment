import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import '../../models/hotel_model.dart';
import '../services/search_services.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key});

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<HotelModel>>? _futureHotels;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// --- Debounce handler (auto search after 500ms of typing)
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        setState(() {
          _futureHotels = SearchService.searchHotels(query);
        });
      } else {
        setState(() {
          _futureHotels = null;
        });
      }
    });
  }

  Widget _buildHotelCard(HotelModel hotel, ThemeData theme) {
    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: theme.brightness == Brightness.dark ? 0 : 3,
      shadowColor: theme.shadowColor.withOpacity(0.2),
      child: ListTile(
        leading: Icon(
          Icons.hotel,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        title: Text(
          hotel.propertyName ?? hotel.valueToDisplay ?? 'Unknown Hotel',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          [
            hotel.city,
            hotel.state,
            hotel.country,
          ].where((e) => e != null && e.isNotEmpty).join(', '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () {
          // TODO: Navigate to hotel details page
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPageView(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: "Search by hotel name, city, state or country",
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              prefixIcon: Icon(Icons.search,
                  color: theme.colorScheme.onSurface.withOpacity(0.7)),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear,
                    color: theme.colorScheme.onSurface.withOpacity(0.6)),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _futureHotels = null;
                  });
                },
              )
                  : null,
            ),
          ),
        ),

        Expanded(
          child: _futureHotels == null
              ? Center(
            child: Text(
              "Start searching for hotels",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          )
              : FutureBuilder<List<HotelModel>>(
            future: _futureHotels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No hotels found",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground
                          .withOpacity(0.7),
                    ),
                  ),
                );
              } else {
                final hotels = snapshot.data!;
                return ListView.builder(
                  itemCount: hotels.length,
                  itemBuilder: (context, index) =>
                      _buildHotelCard(hotels[index], theme),
                );
              }
            },
          ),
        ),
      ],
    ));
  }
}

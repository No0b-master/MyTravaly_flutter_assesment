import 'package:flutter/material.dart';
import '../../Models/hotel_filter_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final HotelFilter initialFilter;
  final Function(HotelFilter) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late DateTime? _checkIn;
  late DateTime? _checkOut;
  late int _rooms, _adults, _children;
  late List<String> _accommodation;
  late double _lowPrice, _highPrice;

  final List<String> accommodationTypes = [
    "all",
    "hotel",
    "resort",
    "bedAndBreakfast",
    "guestHouse",
    "Home Stay",
    "Villa",
    "apartment",
  ];

  @override
  void initState() {
    super.initState();
    _checkIn = widget.initialFilter.checkIn;
    _checkOut = widget.initialFilter.checkOut;
    _rooms = widget.initialFilter.rooms;
    _adults = widget.initialFilter.adults;
    _children = widget.initialFilter.children;
    _accommodation = List.from(widget.initialFilter.accommodation);
    _lowPrice = widget.initialFilter.lowPrice!;
    _highPrice = widget.initialFilter.highPrice;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkIn ?? DateTime.now())
          : (_checkOut ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  Widget _buildStepper(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text("$value", style: Theme.of(context).textTheme.bodyLarge),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      // height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text("Filter Hotels", style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),

          // --- Date pickers ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateSelector("Check-In", _checkIn, () => _selectDate(context, true)),
              _buildDateSelector("Check-Out", _checkOut, () => _selectDate(context, false)),
            ],
          ),
          const Divider(height: 24),

          // --- Room, adults, children ---
          _buildStepper("Rooms", _rooms, (val) => setState(() => _rooms = val)),
          _buildStepper("Adults", _adults, (val) => setState(() => _adults = val)),
          _buildStepper("Children", _children, (val) => setState(() => _children = val)),
          const Divider(height: 24),

          // --- Accommodation chips ---
          Text("Accommodation Type", style: theme.textTheme.bodyLarge),
          Wrap(
            spacing: 8,
            children: accommodationTypes.map((type) {
              final selected = _accommodation.contains(type);
              return FilterChip(
                label: Text(type),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      if (type == "all") {
                        _accommodation = ["all"];
                      } else {
                        _accommodation.remove("all");
                        _accommodation.add(type);
                      }
                    } else {
                      _accommodation.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const Divider(height: 24),

          // --- Price slider ---
          Text("Price Range: ₹${_lowPrice.round()} - ₹${_highPrice.round()}",
              style: theme.textTheme.bodyMedium),
          RangeSlider(
            values: RangeValues(_lowPrice, _highPrice),
            min: 0,
            max: 10000,
            divisions: 100,
            onChanged: (values) {
              setState(() {
                _lowPrice = values.start;
                _highPrice = values.end;
              });
            },
          ),

          const Spacer(),
          ElevatedButton(
            onPressed: () {
              final updated = widget.initialFilter
                ..checkIn = _checkIn
                ..checkOut = _checkOut
                ..rooms = _rooms
                ..adults = _adults
                ..children = _children
                ..accommodation = _accommodation
                ..lowPrice = _lowPrice
                ..highPrice = _highPrice;
              widget.onApply(updated);

            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Apply Filter"),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: theme.hintColor)),
              const SizedBox(height: 4),
              Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : "Select date",
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

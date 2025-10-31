import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:mytravaly_flutter_assesment/Constants/webservices.dart';
import '../../Constants/prefs.dart';
import '../../Utils/shared_preferences.dart';

class CurrencyDropdown extends StatefulWidget {
  const CurrencyDropdown({super.key});

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  List<Map<String, dynamic>> currencyList = [];
  String selectedCurrency = SessionManager.getString(Prefs.currency) == ""
      ? "INR"
      : SessionManager.getString(Prefs.currency);
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCurrencyList();
  }

  Future<void> fetchCurrencyList() async {
    try {
      final url = Uri.parse(Webservices.baseUrl);
      final payload = {
        "action": "getCurrencyList",
        "getCurrencyList": {"baseCode": "INR"}
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "authToken": SessionManager.getString(Prefs.authToken),
          "visitortoken": SessionManager.getString(Prefs.visitorToken),
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == true) {
        final List list = data["data"]["currencyList"];
        setState(() {
          currencyList = list
              .map((e) => {
            "code": e["currencyCode"],
            "name": e["currencyName"],
            "symbol": e["currencySymbol"]
          })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = data["message"] ?? "Failed to fetch currencies";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> onCurrencySelected(String value) async {
    setState(() {
      selectedCurrency = value;
    });
    await SessionManager.setString(Prefs.currency, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 🔹 Shimmer while loading
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        highlightColor: theme.colorScheme.surface.withValues(alpha: 0.8),
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      );
    }

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCurrency,
        dropdownColor: theme.colorScheme.surface,
        iconEnabledColor: theme.colorScheme.onSurfaceVariant,
        style: textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        items: currencyList.map((currency) {
          return DropdownMenuItem<String>(
            value: currency["code"],
            child: Text(
              "${currency["code"]} (${currency["symbol"]})",
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onCurrencySelected(value);
        },
      ),
    );
  }
}

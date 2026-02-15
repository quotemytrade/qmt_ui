import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotemytrade/core/providers/quote_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class LocationStepWidget extends ConsumerStatefulWidget {
  const LocationStepWidget({super.key});

  @override
  ConsumerState<LocationStepWidget> createState() => _LocationStepWidgetState();
}

class _LocationStepWidgetState extends ConsumerState<LocationStepWidget> {
  final TextEditingController _locationController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocode (you'd use Google Places API here)
    ref
        .read(quoteProvider.notifier)
        .setLocation('Bangalore, Karnataka (from GPS)');
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(quoteProvider.select((state) => state.location));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location input
        GooglePlaceAutoCompleteTextField(
          textEditingController: _locationController,
          googleAPIKey: 'YOUR_GOOGLE_PLACES_API_KEY', // Add your key
          inputDecoration: InputDecoration(
            hintText: 'Enter city, address, or postcode',
            prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          debounceTime: 400,
          countries: const ['in'], // India only
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {
            ref
                .read(quoteProvider.notifier)
                .setLocation(
                  prediction.description ??
                      prediction.structuredFormatting?.mainText ??
                      '',
                );
          },
          itemClick: (prediction) {
            _locationController.text = prediction.description ?? '';
            _locationController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0),
            );
          },
          itemBuilder: (context, index, prediction) {
            return ListTile(
              leading: const Icon(Icons.location_pin, color: AppColors.primary),
              title: Text(prediction.description ?? ''),
            );
          },
          seperatedBuilder: const Divider(),
          //padding: const EdgeInsets.all(16),
        ),

        const SizedBox(height: 24),

        // Current location button
        Center(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.my_location),
            label: const Text('Use my current location'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _getCurrentLocation,
          ),
        ),

        if (location != null) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    location,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () {
                    ref.read(quoteProvider.notifier).clearLocation();
                    _locationController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

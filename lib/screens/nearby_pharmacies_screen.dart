import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class NearbyPharmaciesScreen extends StatefulWidget {
  const NearbyPharmaciesScreen({super.key});

  @override
  _NearbyPharmaciesScreenState createState() => _NearbyPharmaciesScreenState();
}

class _NearbyPharmaciesScreenState extends State<NearbyPharmaciesScreen> {
  List<dynamic> pharmacies = [];
  bool isLoading = true;
  String errorMessage = '';
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Location permission denied';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
      });

      _fetchNearbyPharmacies(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Could not get location: $e';
      });
    }
  }

  Future<void> _fetchNearbyPharmacies(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://your-backend-url/api/pharmacies/nearby?lat=$lat&lng=$lng&radius=5',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          pharmacies = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load pharmacies';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = 'https://wa.me/$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Pharmacies')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : pharmacies.isEmpty
          ? const Center(child: Text('No nearby pharmacies found'))
          : ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = pharmacies[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(pharmacy['pharmacyName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pharmacy['address']),
                        Text(
                          '${pharmacy['distance'].toStringAsFixed(2)} km away',
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () =>
                          _launchWhatsApp(pharmacy['whatsappNumber']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

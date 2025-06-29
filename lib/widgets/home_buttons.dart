import 'package:flutter/material.dart';
import '../screens/nearby_pharmacies_screen.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[100],
            minimumSize: const Size.fromHeight(80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.local_pharmacy, color: Colors.black),
          label: const Text(
            "Find Pharmacy",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () {
            // Navigate to NearbyPharmaciesScreen when pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NearbyPharmaciesScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[100],
            minimumSize: const Size.fromHeight(80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.description, color: Colors.black),
          label: const Text(
            "Read Rx",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

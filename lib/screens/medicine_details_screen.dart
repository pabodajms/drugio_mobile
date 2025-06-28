import 'package:flutter/material.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> medicine;
  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(medicine['brandName'] ?? 'Medicine Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.medical_services, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          "${medicine['brandName'] ?? ''} (Brand)",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Generic Name : ${medicine['genericName'] ?? ''}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoRow("Type of Drug", medicine['typeOfDrug']),
                    _infoRow("Strength", medicine['strength']),
                    _infoRow("Dosage Form", medicine['dosageForm']),
                    _infoRow("Pack Size", medicine['packSize']),
                    _infoRow("Drug Schedule", medicine['drugSchedule']),
                    _infoRow("Shelf Life", medicine['shelfLife']),
                    _infoRow("Package Type", medicine['packageType']),
                    _infoRow("Temperature", medicine['temperature']),
                    _infoRow("Coat", medicine['coat']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Manufacturer Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${medicine['manufacturerName'] ?? ''} – ${medicine['manufactured_Country'] ?? ''}",
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Local Distributor Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${medicine['distributorName'] ?? ''}"),
                    Text("${medicine['distributorAddress'] ?? ''}"),
                    Text("${medicine['distributorContact'] ?? ''}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement contact pharmacy
              },
              child: const Text("Contact Pharmacy"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    if (value == null || value.toString().isEmpty)
      return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/medicine_service.dart';
import 'medicine_details_screen.dart';

class BrandsListScreen extends StatefulWidget {
  final String genericName;
  const BrandsListScreen({super.key, required this.genericName});

  @override
  State<BrandsListScreen> createState() => _BrandsListScreenState();
}

class _BrandsListScreenState extends State<BrandsListScreen> {
  List<dynamic> brands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  void fetchBrands() async {
    try {
      // You may need to implement this method in your MedicineService
      final results = await MedicineService.getBrandsByGeneric(
        widget.genericName,
      );
      setState(() {
        brands = results;
      });
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.genericName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : brands.isEmpty
          ? const Center(child: Text("No brands found."))
          : ListView.builder(
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: Text(brand['brandName'] ?? ''),
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        final details =
                            await MedicineService.getMedicineByBrandId(
                              brand['brand_Id'],
                            );
                        Navigator.of(context).pop(); // close spinner

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MedicineDetailsScreen(medicine: details),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to load medicine details."),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

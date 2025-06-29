import 'package:flutter/material.dart';
import '../services/medicine_service.dart';
import '../screens/brands_list_screen.dart';
import '../screens/medicine_details_screen.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  String query = "";
  String selectedFilter = "All";
  List<dynamic> medicines = [];
  bool isLoading = false;

  final filters = ["All", "Generic Name", "Brand Name"];

  void fetchMedicines() async {
    if (query.isEmpty) {
      setState(() {
        medicines = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String filterValue;
      switch (selectedFilter) {
        case "Generic Name":
          filterValue = "generic";
          break;
        case "Brand Name":
          filterValue = "brand";
          break;
        default:
          filterValue = "all";
      }

      final results = await MedicineService.searchMedicines(query, filterValue);

      setState(() {
        medicines = results;
      });
    } catch (e) {
      print("Search error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find Medicine",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Search here...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) {
              setState(() {
                query = val;
              });
              fetchMedicines();
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: filters.map((filter) {
              return Row(
                children: [
                  Checkbox(
                    value: selectedFilter == filter,
                    onChanged: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                      fetchMedicines();
                    },
                  ),
                  Text(filter),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (!isLoading && medicines.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];

                String title = "";
                String? subtitle;

                if (selectedFilter == "Generic Name") {
                  title = med['genericName'] ?? '';
                } else if (selectedFilter == "Brand Name") {
                  title = med['brandName'] ?? '';
                  subtitle = med['genericName'];
                } else {
                  title = med['brandName'] ?? '';
                  subtitle = med['genericName'];
                }

                return Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: subtitle != null && subtitle.isNotEmpty
                        ? Text(subtitle)
                        : null,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      if (selectedFilter == "Generic Name") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrandsListScreen(
                              genericName: med['genericName'],
                            ),
                          ),
                        );
                      } else if (selectedFilter == "Brand Name" ||
                          selectedFilter == "All") {
                        // show a loading indicator while fetching full details
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final fullDetails =
                              await MedicineService.getMedicineById(
                                med['medicine_Id'],
                              );

                          // close the loading indicator
                          Navigator.of(context).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MedicineDetailsScreen(medicine: fullDetails),
                            ),
                          );
                        } catch (e) {
                          Navigator.of(context).pop(); // close loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to load medicine details"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          if (!isLoading && medicines.isEmpty && query.isNotEmpty)
            const Center(child: Text("No medicines found.")),
        ],
      ),
    );
  }
}

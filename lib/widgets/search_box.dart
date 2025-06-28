import 'package:flutter/material.dart';
import '../services/medicine_service.dart';

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
                return Card(
                  child: ListTile(
                    title: Text(med['brandName'] ?? ''),
                    subtitle: Text(med['genericName'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // navigate to details if you want
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

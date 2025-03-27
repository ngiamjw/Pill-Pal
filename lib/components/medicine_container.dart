import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:developer' as developer;

class MedicineContainer extends StatelessWidget {
  final bool color;
  final String name;
  final int amt;
  final String dosage_type;
  const MedicineContainer(
      {super.key,
      required this.amt,
      required this.color,
      required this.name,
      required this.dosage_type});

  @override
  Widget build(BuildContext context) {
    const Map<String, String> routeAssetMap = {
      'ORAL': 'assets/pill.png',
      'TOPICAL': 'assets/patch.png',
      'INTRAVENOUS': 'assets/syringe.png',
      'INTRAMUSCULAR': 'assets/syringe.png',
      'OPHTHALMIC': 'assets/eye-drops.png',
      'DENTAL': 'assets/dental.png',
      'RESPIRATORY (INHALATION)': 'assets/inhaler.png',
      'SUBCUTANEOUS': 'assets/syringe.png',
      'CUTANEOUS': 'assets/patch.png',
      'SUBLINGUAL': 'assets/pill.png',
      'NASAL': 'assets/nasal-spray.png',
    };

    final ImagePath = routeAssetMap[dosage_type];
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Subtle shadow
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    Colors.blue.shade50, // Optional background color
                child: Transform.scale(
                  scale:
                      0.7, // Adjust this value to zoom in/out (less than 1 zooms out)
                  child: Image.asset(
                    ImagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              Text(amt.toString(), style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

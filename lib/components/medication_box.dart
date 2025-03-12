import 'package:flutter/material.dart';

class MedicationBox extends StatefulWidget {
  final Map<String, dynamic> medication;
  final VoidCallback onRemove;

  const MedicationBox({
    required this.medication,
    required this.onRemove,
  });

  @override
  _MedicationBoxState createState() => _MedicationBoxState();
}

class _MedicationBoxState extends State<MedicationBox> {
  final List<String> times = ["Morning", "Afternoon", "Evening", "Night"];
  final List<int> doses = List.generate(10, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Subtle shadow
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Medicine Name Text Input
            TextFormField(
              decoration: InputDecoration(labelText: "Medicine Name"),
              initialValue: widget.medication['medicine'],
              onChanged: (value) {
                widget.medication['medicine'] = value;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                // Doses Dropdown
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: "Doses"),
                    value: widget.medication['doses'],
                    items: doses
                        .map((dose) => DropdownMenuItem<int>(
                              value: dose,
                              child: Text(dose.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.medication['doses'] = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                // Time Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Time"),
                    value: widget.medication['time'],
                    items: times
                        .map((time) => DropdownMenuItem<String>(
                              value: time,
                              child: Text(time),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.medication['time'] = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            // Remove Medication Box Button
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                        onTap: widget.onRemove,
                        child: Icon(Icons.delete_outline)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

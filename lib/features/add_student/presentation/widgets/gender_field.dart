import 'package:flutter/material.dart';

class GenderField extends StatefulWidget {
  final List<String> genderOptions;
  final String? selectedGender;
  final Function(String?) onChanged;
  const GenderField({
    super.key,
    required this.genderOptions,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select your gender:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: "Select gender",
              contentPadding: EdgeInsets.all(10),
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            value: widget.selectedGender,
            onChanged: (newValue) {
              setState(() {
                widget.onChanged(newValue);
              });
            },
            items: widget.genderOptions.map((valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

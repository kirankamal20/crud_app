import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  final Function(Country) onCountrySelected;
  final Country selectedCountry;
  const CountryPicker(
      {super.key,
      required this.onCountrySelected,
      required this.selectedCountry});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  Country? _selectedCountry;
  final List<Country> countries = [
    Country(name: 'United States', flagCode: '🇺🇸'),
    Country(name: 'Canada', flagCode: '🇨🇦'),
    Country(name: 'United Kingdom', flagCode: '🇬🇧'),
    Country(name: 'Germany', flagCode: '🇩🇪'),
    Country(name: 'France', flagCode: '🇫🇷'),
    Country(name: 'Italy', flagCode: '🇮🇹'),
    Country(name: 'Spain', flagCode: '🇪🇸'),
    Country(name: 'Australia', flagCode: '🇦🇺'),
    Country(name: 'Japan', flagCode: '🇯🇵'),
    Country(name: 'China', flagCode: '🇨🇳'),
    Country(name: 'India', flagCode: '🇮🇳'),
    // Add more countries as needed
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Country>(
          isExpanded: true,
          value: _selectedCountry,
          hint: const Text('Select a country'),
          onChanged: (Country? newValue) {
            setState(() {
              _selectedCountry = newValue;
              widget.onCountrySelected(newValue!);
            });
          },
          items: countries.map<DropdownMenuItem<Country>>((Country country) {
            return DropdownMenuItem<Country>(
              value: country,
              child: Row(
                children: <Widget>[
                  Text(country.flagCode),
                  const SizedBox(width: 10),
                  Text(country.name),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Country {
  final String name;
  final String flagCode;

  Country({required this.name, required this.flagCode});
}

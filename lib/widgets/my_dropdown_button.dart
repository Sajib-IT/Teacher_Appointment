import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyDropdownButton extends StatelessWidget {
  final dynamic value;
  final List<dynamic> items;
  final Function onChanged;
  final String? hint;
  final bool isDense;

  const MyDropdownButton({
    super.key,
    required this.value,
    required this.items,
    this.hint,
    this.isDense = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<dynamic>(
      isExpanded: true,
      isDense: isDense,
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: kIsWeb ? 16 : 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent)),
        // Add more decoration..
      ),
      hint: Text(
        hint ?? 'Select a provider',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      items: items
          .map((item) => DropdownMenuItem<dynamic>(
                value: item,
                onTap: () {},
                child: Text(
                  item,
                  // maxLines: 1,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ))
          .toList(),
      onChanged: (value) {
        onChanged(value);
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 14),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        // padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        // offset: const Offset(10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey)),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

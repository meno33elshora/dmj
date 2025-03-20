import 'package:dmj_task/core/utils/extension.dart';
import 'package:flutter/material.dart';

class CustomeDropdown extends StatelessWidget {
  final String titleField;
  final List<String> states;
  final String selectedState;
  final Function(String? value) onChanged;

  const CustomeDropdown({
    super.key,
    required this.titleField,
    required this.states,
    required this.selectedState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // List of states
    // final List<String> states = ["New York", "California", "Texas"];

    // Selected state
    // String? selectedState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Status",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                )),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Row(
                  children: [
                    const Icon(
                      Icons.looks_3_rounded,
                      color: Colors.orange,
                    ),
                    5.pw,
                    Text(
                      "Select a state",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // value: selectedState,
                value: states.contains(selectedState) ? selectedState : null,
                elevation: 0,
                onChanged: (value) => onChanged(value),
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

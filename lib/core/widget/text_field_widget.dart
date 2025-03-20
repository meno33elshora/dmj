import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String titleField;
  final String hintField;
  final TextEditingController controller;
  final bool obscureText;
  final bool? readOnly;

  final TextInputType? keyboardType;
  final Function(String) validator;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;

  const TextFieldWidget({
    super.key,
    required this.titleField,
    required this.hintField,
    required this.controller,
    required this.obscureText,
    this.keyboardType,
    required this.validator,
    required this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleField,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          maxLines: obscureText ? 1 : 10,
          minLines: 1,
          readOnly: readOnly ?? false,
          keyboardType: keyboardType,
          onTap: onTap,
          validator: (value) => validator(value!),
          onChanged: (value) => onChanged(value),
          decoration: InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              hintText: hintField,
              hintStyle: const TextStyle(
                fontSize: 14.0,
              ),
              filled: true,
              fillColor: Colors.white,
              border: const UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class BaseAppInput extends StatelessWidget {
  const BaseAppInput({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.textInputAction,
  });

  final String? hintText;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: textInputAction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        hintText: hintText,
      ),
    );
  }
}

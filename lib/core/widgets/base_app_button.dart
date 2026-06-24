import 'package:flutter/material.dart';

class BaseAppButton extends StatelessWidget {
  const BaseAppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: enabled && !isLoading ? onTap : null,
        icon: isLoading
            ? SizedBox.square(
                dimension: IconTheme.of(context).size ?? 18,
                child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : Icon(icon ?? Icons.check),
        label: Text(label),
      ),
    );
  }
}

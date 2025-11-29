import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        onChanged: onChanged,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
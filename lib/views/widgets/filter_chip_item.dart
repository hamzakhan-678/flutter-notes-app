import 'package:flutter/material.dart';
import 'package:notes_application_mvvm/core/utils/my_colors.dart';

class FilterChipItem extends StatelessWidget {
  const FilterChipItem({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    this.onClicked,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? MyColors.secondaryColor : MyColors.primaryInverse,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '$label ($count)',
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

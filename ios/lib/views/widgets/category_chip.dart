import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // IKON KATEGORI
            // ==================================================

            AnimatedContainer(
              duration: const Duration(milliseconds: 150),

              width: 38,
              height: 38,

              decoration: BoxDecoration(
                color: selected ? green : const Color(0xFFE8F6EF),

                shape: BoxShape.circle,

                border: selected ? Border.all(color: green, width: 1) : null,
              ),

              child: Icon(
                icon,

                size: 19,

                color: selected ? Colors.white : green,
              ),
            ),

            const SizedBox(height: 5),

            // ==================================================
            // NAMA KATEGORI
            // ==================================================
            Text(
              label,

              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,

              style: TextStyle(
                color: selected ? green : blue,

                fontSize: 8.5,

                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

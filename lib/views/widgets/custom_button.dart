import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final double fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
    this.icon,
    this.height = 42,
    this.borderRadius = 8,
    this.fontSize = 12,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  static const Color green = Color(0xFF087F3E);
  static const Color blue = Color(0xFF092B8F);

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = backgroundColor ?? green;
    final Color foregroundColor =
        textColor ?? (outlined ? green : Colors.white);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                side: BorderSide(
                  color: buttonColor,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: _buildChild(foregroundColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: foregroundColor,
                disabledBackgroundColor: buttonColor.withOpacity(0.6),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: _buildChild(foregroundColor),
            ),
    );
  }

  Widget _buildChild(Color foregroundColor) {
    if (isLoading) {
      return SizedBox(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    if (icon == null) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
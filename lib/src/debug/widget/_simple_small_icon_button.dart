part of '../../../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _SimpleSmallIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  final String? text;
  final double? iconSize;
  final Color? iconColor;
  final bool selected;

  const _SimpleSmallIconButton({
    required this.iconData,
    this.text,
    this.onPressed,
    this.selected = false,
    this.iconSize = 16,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double adjustedIconSize =
        screenWidth < 500 ? (iconSize ?? 16) - 2 : iconSize ?? 16;

    final double textSize = screenWidth < 500 ? 12 : 14;

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: screenWidth < 500
          ? const EdgeInsets.fromLTRB(5, 5, 8, 5)
          : const EdgeInsets.fromLTRB(5, 10, 8, 10),
      minimumSize: Size.zero, // const Size(30, 30),
      backgroundColor: selected ? Colors.amberAccent : null,
    );

    final Icon icon = Icon(
      iconData,
      size: adjustedIconSize,
      color: iconColor,
    );

    // Hiển thị TextButton với icon và text (nếu có)
    if (text != null) {
      return TextButton.icon(
        icon: icon,
        label: Text(
          text!,
          style: TextStyle(fontSize: textSize),
        ),
        onPressed: onPressed,
        style: buttonStyle,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: icon,
      );
    }
  }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

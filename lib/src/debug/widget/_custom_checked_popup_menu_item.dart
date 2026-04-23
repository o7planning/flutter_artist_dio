import 'package:flutter/material.dart';

class CustomCheckedPopupMenuItem<T> extends PopupMenuEntry<T> {
  const CustomCheckedPopupMenuItem({
    super.key,
    required this.value,
    required this.checked,
    required this.child,
    this.enabled = true,
    this.padding,
  });

  final T value;
  final bool checked;
  final Widget child;
  final bool enabled;
  final EdgeInsetsGeometry? padding;

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(T? value) => value == this.value;

  @override
  State<CustomCheckedPopupMenuItem<T>> createState() =>
      _CustomCheckedPopupMenuItemState<T>();
}

class _CustomCheckedPopupMenuItemState<T>
    extends State<CustomCheckedPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color iconColor = !widget.enabled
        ? theme.disabledColor
        : (widget.checked
            ? colorScheme.primary
            : theme.iconTheme.color ?? colorScheme.onSurfaceVariant);

    return InkWell(
      onTap:
          widget.enabled ? () => Navigator.pop<T>(context, widget.value) : null,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        height: widget.height,
        child: Row(
          children: [
            Icon(
              widget.checked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: widget.enabled
                      ? theme.textTheme.bodyMedium!.color
                      : theme.disabledColor,
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

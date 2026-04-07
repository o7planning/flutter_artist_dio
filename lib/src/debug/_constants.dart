import 'package:flutter/material.dart';

const double defaultIconSize = 16;

TextStyle defaultTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: 13,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

TextStyle defaultLabelStyle(BuildContext context) {
  return TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
  );
}

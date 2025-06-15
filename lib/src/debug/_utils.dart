part of '../../rest_debug_screen.dart';

void _showSnackBar(BuildContext context, String value) {
  ScaffoldMessenger.of(context)
      .showSnackBar(new SnackBar(content: new Text(value)));
}

// TODO: Hide all.
void _closeAllSnackBars(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

part of '../../../flutter_artist_dio.dart';

class _CustomAppContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final int type;
  static const int _typeDefaullt = 0;
  static const int _typeTransparent = 1;
  static const int _typeBar = 2;

  const _CustomAppContainer({
    this.child,
    this.width,
  })  : height = null,
        padding = const EdgeInsets.all(10),
        type = _typeDefaullt;

  const _CustomAppContainer.transparent({
    this.child,
    this.width,
    this.padding = const EdgeInsets.all(0),
  })  : height = null,
        type = _typeTransparent;

  const _CustomAppContainer.bar({
    this.child,
  })  : padding = const EdgeInsets.all(5),
        width = null,
        height = null,
        type = _typeBar;

  Color _color(BuildContext context) {
    switch (type) {
      case _typeDefaullt:
        return Theme.of(context).cardColor;
      case _typeTransparent:
        return Colors.transparent;
      case _typeBar:
        return Colors.indigo.withAlpha(20);
      default:
        return Colors.transparent;
    }
  }

  Border? _border() {
    switch (type) {
      case _typeDefaullt:
        return Border.all(color: Colors.black12);
      case _typeTransparent:
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _color(context),
        borderRadius: BorderRadius.circular(
          4,
        ),
        border: _border(),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}

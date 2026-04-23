import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabThemeUtils {
  static TabbedViewThemeData getTabbedViewThemeData(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color contentAreaColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : Colors.white;

    final Color borderColor = theme.dividerColor;
    final Color selectedTabColor = colorScheme.primary;

    final borderSide = BorderSide(color: borderColor, width: 1);

    final borderSideSelected = BorderSide(color: selectedTabColor, width: 2.0);
    final borderSideNone = BorderSide(color: Colors.transparent, width: 0);

    TabbedViewThemeData themeData = TabbedViewThemeData.underline();

    final boxDecoTabDeselected = BoxDecoration(
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSideNone,
      ),
    );

    final boxDecoTabSelected = BoxDecoration(
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSideSelected,
      ),
    );

    final selectedStatus = TabStatusThemeData()
      ..fontColor = getTabTextColor(context, TabStatus.selected)
      ..buttonBackground = boxDecoTabSelected;

    final hoveredStatus = TabStatusThemeData()
      ..fontColor = getTabTextColor(context, TabStatus.hovered)
      ..buttonBackground = boxDecoTabSelected;

    themeData.tab
      ..textStyle = TextStyle(
        fontSize: 13,
        color: getTabTextColor(context, TabStatus.unselected),
      )
      ..selectedStatus = TabStatusThemeData(
          fontColor: getTabTextColor(context, TabStatus.selected))
      ..hoveredStatus = TabStatusThemeData(
          fontColor: getTabTextColor(context, TabStatus.hovered));

    themeData.tab
      ..selectedStatus = selectedStatus
      ..hoveredStatus = hoveredStatus
      ..decorationBuilder = ({
        required TabStyleContext styleContext,
        required TabBarPosition tabBarPosition,
      }) {
        return TabDecoration(
          color: styleContext.status == TabStatus.selected
              ? contentAreaColor
              : Colors.transparent,
          border: Border(
            left: borderSide,
            right: borderSide,
            top: borderSide,
            bottom: styleContext.status == TabStatus.selected
                ? borderSideSelected
                : borderSideNone,
          ),
        );
      }
      ..padding = const EdgeInsets.symmetric(vertical: 3, horizontal: 10)
      ..buttonsOffset = 0;

    themeData.tabsArea
      ..border = const BorderSide(color: Colors.transparent, width: 1)
      ..color = Colors.transparent
      ..initialGap = 0
      ..middleGap = 0
      ..minimalFinalGap = 0;

    themeData.contentArea
      ..color = contentAreaColor
      ..padding = const EdgeInsets.all(8)
      ..border = BorderSide.none;

    return themeData;
  }

  static Color getTabIconColor(BuildContext context, TabStatus tabStatus) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (tabStatus) {
      case TabStatus.selected:
        return colorScheme.primary;

      case TabStatus.hovered:
        return colorScheme.onSurface;

      case TabStatus.unselected:
      default:
        return colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  static Color getTabTextColor(BuildContext context, TabStatus status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (status) {
      case TabStatus.selected:
        return colorScheme.primary;

      case TabStatus.hovered:
        return colorScheme.onSurface;

      case TabStatus.unselected:
      default:
        return colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}

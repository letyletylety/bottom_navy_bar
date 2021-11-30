part of 'bottom_navy_bar.dart';

/// A beautiful and animated bottom navigation that paints a rounded shape
/// around its [items] to provide a wonderful look.
///
/// Update [selectedIndex] to change the selected item.
/// [selectedIndex] is required and must not be null.
class BottomNavyBarExpanded extends StatelessWidget {
  const BottomNavyBarExpanded({
    Key? key,
    this.selectedIndex = 0,
    this.iconSize = 24,
    this.backgroundColor,
    this.showElevation = true,
    this.animationDuration = const Duration(milliseconds: 270),
    required this.items,
    required this.onItemSelected,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.itemCornerRadius = 50.0,
    this.containerHeight = 56.0,
    this.curve = Curves.linear,
    this.backgroundMode = false,
    this.childMainAxisAlignment = MainAxisAlignment.start,
    this.itemWidthDiff = 80.0,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  /// The selected item is index. Changing this property will change and animate
  /// the item being selected. Defaults to zero.
  final int selectedIndex;

  /// The icon size of all items. Defaults to 24.
  final double iconSize;

  /// The background color of the navigation bar. It defaults to
  /// [Theme.bottomAppBarColor] if not provided.
  final Color? backgroundColor;

  /// Whether this navigation bar should show a elevation. Defaults to true.
  final bool showElevation;

  /// Use this to change the item's animation duration. Defaults to 270ms.
  final Duration animationDuration;

  /// Defines the appearance of the buttons that are displayed in the bottom
  /// navigation bar. This should have at least two items and five at most.
  final List<BottomNavyBarItem> items;

  /// A callback that will be called when a item is pressed.
  final ValueChanged<int> onItemSelected;

  /// Defines the alignment of the items.
  /// Defaults to [MainAxisAlignment.spaceBetween].
  final MainAxisAlignment mainAxisAlignment;

  /// The [items] corner radius, if not set, it defaults to 50.
  final double itemCornerRadius;

  /// Defines the bottom navigation bar height. Defaults to 56.
  final double containerHeight;

  /// Used to configure the animation curve. Defaults to [Curves.linear].
  final Curve curve;

  final bool backgroundMode;

  /// the main axis alignment foreach item
  final MainAxisAlignment childMainAxisAlignment;

  /// the difference between expanded width and collapsed width.
  final double itemWidthDiff;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int itemCount = items.length;
        double horizontalPadding = 8.0;

        screenWidth -= horizontalPadding;
        screenWidth -= horizontalPadding;

        double itemWidth = (screenWidth - itemWidthDiff) / itemCount;

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              if (showElevation)
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                ),
            ],
          ),
          child: SafeArea(
            child: Container(
              width: double.infinity,
              height: containerHeight,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                children: items.map((item) {
                  int index = items.indexOf(item);
                  return GestureDetector(
                    onTap: () => onItemSelected(index),
                    child: _ExpandedItemWidget(
                      item: item,
                      iconSize: iconSize,
                      isSelected: index == selectedIndex,
                      backgroundColor: bgColor,
                      itemCornerRadius: itemCornerRadius,
                      animationDuration: animationDuration,
                      curve: curve,
                      mainAxisAlignment: childMainAxisAlignment,
                      backgroundMode: backgroundMode,
                      minSize: itemWidth,
                      maxSize: itemWidth + itemWidthDiff,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExpandedItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  final MainAxisAlignment mainAxisAlignment;
  final bool backgroundMode;

  final double minSize;
  final double maxSize;

  const _ExpandedItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.animationDuration,
    required this.itemCornerRadius,
    required this.iconSize,
    this.curve = Curves.linear,
    required this.mainAxisAlignment,
    required this.backgroundMode,
    required this.minSize,
    required this.maxSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        width: isSelected ? maxSize : minSize,
        height: double.maxFinite,
        duration: animationDuration,
        curve: curve,
        decoration: BoxDecoration(
          color: backgroundMode
              ? (isSelected
                  ? item.activeColor.withOpacity(0.2)
                  : backgroundColor)
              : backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            width: isSelected ? maxSize : minSize,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: mainAxisAlignment,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                    size: iconSize,
                    color: isSelected
                        ? item.activeColor.withOpacity(1)
                        : item.inactiveColor ?? item.activeColor,
                  ),
                  child: item.icon,
                ),
                if (isSelected)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: item.activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: item.textAlign,
                        child: item.title,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

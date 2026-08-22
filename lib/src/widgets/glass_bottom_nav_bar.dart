import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// A single destination in a [GlassBottomNavBar].
@immutable
class GlassNavItem {
  const GlassNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  /// The icon shown when the item is not selected.
  final IconData icon;

  /// Optional icon shown when the item is selected. Falls back to [icon].
  final IconData? activeIcon;

  /// The text label under the icon.
  final String label;
}

/// A floating, capsule-shaped glass navigation bar — the signature iOS 26.4
/// bottom bar. The selected destination sits inside a soft highlight pill that
/// slides smoothly ("bubbles") between items, and both the pill and the
/// selected icon give a springy pop.
///
/// Animation is controlled by two independent flags, and both are disabled
/// automatically when the user has "Reduce Motion" enabled:
///
/// * [animateIndicator] — the highlight slides between items.
/// * [animateBounce] — the selected icon *and* the highlight pill pop.
///
/// Set [showLabels] to `false` for an icons-only bar. Corner rounding is tunable
/// via [borderRadius] (bar) and [indicatorBorderRadius] (pill); large values
/// simply clamp to a full capsule.
///
/// ```dart
/// GlassBottomNavBar(
///   currentIndex: _index,
///   onTap: (i) => setState(() => _index = i),
///   items: const [
///     GlassNavItem(icon: Icons.home_rounded, label: 'Home'),
///     GlassNavItem(icon: Icons.sports_esports_rounded, label: 'Arcade'),
///     GlassNavItem(icon: Icons.group_rounded, label: 'Friends'),
///     GlassNavItem(icon: Icons.inventory_2_rounded, label: 'Library'),
///     GlassNavItem(icon: Icons.search_rounded, label: 'Search'),
///   ],
/// )
/// ```
///
/// It sizes itself to its content; wrap it in [SafeArea] / [Align] or drop it in
/// a [Stack] above your content to float it over the page.
class GlassBottomNavBar extends StatefulWidget {
  const GlassBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 12),
    this.showLabels = true,
    this.animateIndicator = true,
    this.animateBounce = true,
    this.borderRadius = 40,
    this.indicatorBorderRadius,
  }) : assert(items.length >= 2, 'A nav bar needs at least two items.');

  /// The destinations, left to right.
  final List<GlassNavItem> items;

  /// The index of the currently selected destination.
  final int currentIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onTap;

  /// Outer margin used to float the bar above the screen edges.
  final EdgeInsetsGeometry margin;

  /// Whether to show the text labels under each icon. Set to `false` for an
  /// icons-only bar.
  final bool showLabels;

  /// Whether the selection highlight slides ("bubbles") between items. When
  /// false the highlight simply appears on the selected item.
  final bool animateIndicator;

  /// Whether the selected icon and highlight pill give a springy bounce.
  final bool animateBounce;

  /// The bar's corner radius. Values larger than half the bar height clamp to a
  /// full capsule.
  final double borderRadius;

  /// The selected pill's corner radius. Defaults to a value concentric with
  /// [borderRadius].
  final double? indicatorBorderRadius;

  @override
  State<GlassBottomNavBar> createState() => _GlassBottomNavBarState();
}

class _GlassBottomNavBarState extends State<GlassBottomNavBar>
    with SingleTickerProviderStateMixin {
  static const double _inset = 8;

  late final AnimationController _popController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
  );

  // A gentle pop that overshoots then springs back — matched to the icon
  // bounce but softer so the pill doesn't clip the bar.
  late final Animation<double> _pop = TweenSequence<double>([
    TweenSequenceItem(
      tween:
          Tween(begin: 1.0, end: 1.12).chain(CurveTween(curve: Curves.easeOut)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.12, end: 1.0)
          .chain(CurveTween(curve: Curves.elasticOut)),
      weight: 65,
    ),
  ]).animate(_popController);

  @override
  void didUpdateWidget(GlassBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex &&
        widget.animateBounce &&
        !MediaQuery.disableAnimationsOf(context)) {
      _popController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;

    final double barRadius = widget.borderRadius;
    final double indicatorRadius =
        widget.indicatorBorderRadius ?? (barRadius - _inset);

    final int n = widget.items.length;
    // Respect "Reduce Motion" — it wins over the per-animation flags.
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final bool slide = widget.animateIndicator && !reduceMotion;
    final bool bounce = widget.animateBounce && !reduceMotion;

    // Fractional horizontal alignment of the sliding bubble for the selected
    // slot: -1 (first) … +1 (last).
    final double xAlign = n == 1 ? 0 : (2 * widget.currentIndex / (n - 1)) - 1;

    final Color indicatorFill = colors.glassHighlight.withValues(
      alpha: colors.brightness == Brightness.dark ? 0.16 : 0.55,
    );

    Widget indicatorPill = DecoratedBox(
      decoration: BoxDecoration(
        color: indicatorFill,
        borderRadius: BorderRadius.circular(indicatorRadius),
        border: Border.all(color: colors.glassBorder, width: 0.5),
      ),
    );
    if (bounce) {
      indicatorPill = ScaleTransition(scale: _pop, child: indicatorPill);
    }

    return Padding(
      padding: widget.margin,
      child: SafeArea(
        top: false,
        child: GlassSurface(
          borderRadius: BorderRadius.circular(barRadius),
          padding: const EdgeInsets.all(_inset),
          child: Stack(
            children: [
              // The moving "bubble". Drawn behind the items; only used when the
              // sliding indicator is enabled.
              if (widget.animateIndicator)
                Positioned.fill(
                  child: AnimatedAlign(
                    duration: slide
                        ? const Duration(milliseconds: 340)
                        : Duration.zero,
                    curve: Curves.easeOutCubic,
                    alignment: Alignment(xAlign, 0),
                    child: FractionallySizedBox(
                      widthFactor: 1 / n,
                      // heightFactor is required — without it the childless
                      // pill collapses to zero height and disappears.
                      heightFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 3,
                        ),
                        child: indicatorPill,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  for (var i = 0; i < n; i++)
                    Expanded(
                      child: _NavCell(
                        item: widget.items[i],
                        selected: i == widget.currentIndex,
                        showLabel: widget.showLabels,
                        indicatorRadius: indicatorRadius,
                        // When the sliding bubble is on it draws the highlight;
                        // otherwise each cell paints its own static highlight.
                        drawOwnIndicator: !widget.animateIndicator,
                        bounce: bounce,
                        onTap: () => widget.onTap(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCell extends StatefulWidget {
  const _NavCell({
    required this.item,
    required this.selected,
    required this.showLabel,
    required this.indicatorRadius,
    required this.drawOwnIndicator,
    required this.bounce,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final bool showLabel;
  final double indicatorRadius;
  final bool drawOwnIndicator;
  final bool bounce;
  final VoidCallback onTap;

  @override
  State<_NavCell> createState() => _NavCellState();
}

class _NavCellState extends State<_NavCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
  );

  // A pop that overshoots then springs back to rest.
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween:
          Tween(begin: 1.0, end: 1.28).chain(CurveTween(curve: Curves.easeOut)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.28, end: 1.0)
          .chain(CurveTween(curve: Curves.elasticOut)),
      weight: 65,
    ),
  ]).animate(_controller);

  @override
  void didUpdateWidget(_NavCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pop whenever this cell becomes the selected one.
    if (widget.bounce && widget.selected && !oldWidget.selected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;

    final Color contentColor = widget.selected
        ? colors.label
        : colors.secondaryLabel.withValues(alpha: 0.75);

    Widget icon = Icon(
      widget.selected
          ? (widget.item.activeIcon ?? widget.item.icon)
          : widget.item.icon,
      color: contentColor,
      size: 26,
    );

    if (widget.bounce) {
      icon = ScaleTransition(scale: _scale, child: icon);
    }

    final Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.showLabel ? 14 : 18,
        vertical: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          if (widget.showLabel) ...[
            const SizedBox(height: 3),
            Text(
              widget.item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.typography.tabLabel.copyWith(color: contentColor),
            ),
          ],
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Center(
          // When the sliding bubble is disabled, each cell paints its own
          // (instant) highlight so the selected item is still marked.
          child: widget.drawOwnIndicator
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.indicatorRadius),
                    color: widget.selected
                        ? colors.glassHighlight.withValues(
                            alpha: colors.brightness == Brightness.dark
                                ? 0.16
                                : 0.55,
                          )
                        : const Color(0x00000000),
                    border: widget.selected
                        ? Border.all(color: colors.glassBorder, width: 0.5)
                        : null,
                  ),
                  child: content,
                )
              : content,
        ),
      ),
    );
  }
}

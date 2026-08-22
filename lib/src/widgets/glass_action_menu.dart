import 'package:flutter/material.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// One row in a [GlassActionMenu].
@immutable
class GlassMenuItem {
  const GlassMenuItem({
    required this.label,
    this.icon,
    this.onPressed,
    this.isDestructive = false,
  });

  /// The row label.
  final String label;

  /// An optional trailing icon (iOS places menu glyphs on the trailing edge).
  final IconData? icon;

  /// Called when the row is tapped. The menu pops itself first, then invokes
  /// this on the next frame.
  final VoidCallback? onPressed;

  /// Renders the row in the destructive (red) style.
  final bool isDestructive;
}

/// A Liquid-Glass action menu (iOS 26.4 context menu): a frosted rounded panel
/// with a vertical list of actions separated by hairlines.
///
/// Present it anchored to the widget that triggered it with
/// [showGlassActionMenu]. It can also be embedded directly (e.g. inside a
/// popover you position yourself).
class GlassActionMenu extends StatelessWidget {
  const GlassActionMenu({
    super.key,
    required this.items,
    this.width = 250,
  });

  /// The menu rows.
  final List<GlassMenuItem> items;

  /// The menu's fixed width.
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final separator = theme.colors.separator;

    return GlassSurface(
      width: width,
      borderRadius: BorderRadius.circular(theme.metrics.mediumRadius),
      blurSigma: theme.metrics.blurSigma + 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Container(height: 0.5, color: separator),
            _MenuRow(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final GlassMenuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;

    final Color color = item.isDestructive
        ? (colors.brightness == Brightness.dark
            ? const Color(0xFFFF453A)
            : const Color(0xFFFF3B30))
        : colors.label;

    return Semantics(
      button: true,
      enabled: item.onPressed != null,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.onPressed == null
            ? null
            : () {
                Navigator.of(context).pop();
                // Defer so the pop transition can start before the action runs.
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => item.onPressed!());
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: theme.typography.body.copyWith(color: color),
                ),
              ),
              if (item.icon != null) ...[
                const SizedBox(width: 12),
                Icon(item.icon, size: 20, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Presents a [GlassActionMenu] anchored to the widget owning [context], like
/// an iOS context menu. It flips above the anchor when there isn't room below
/// and stays within the screen.
///
/// ```dart
/// GlassButton(
///   icon: Icons.more_horiz,
///   onPressed: () => showGlassActionMenu(
///     context: context,
///     items: [
///       GlassMenuItem(label: 'Share', icon: Icons.ios_share),
///       GlassMenuItem(label: 'Delete', icon: Icons.delete, isDestructive: true),
///     ],
///   ),
/// )
/// ```
Future<T?> showGlassActionMenu<T>({
  required BuildContext context,
  required List<GlassMenuItem> items,
  double width = 250,
  Color? barrierColor,
}) {
  final RenderBox anchor = context.findRenderObject()! as RenderBox;
  final RenderBox overlay =
      Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
  final Offset topLeft = anchor.localToGlobal(Offset.zero, ancestor: overlay);
  final Rect anchorRect = topLeft & anchor.size;
  final Size overlaySize = overlay.size;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'menu',
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.08),
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180),
    pageBuilder: (context, _, __) {
      return CustomSingleChildLayout(
        delegate: _MenuLayout(anchorRect, overlaySize),
        child: GlassActionMenu(items: items, width: width),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final below = anchorRect.center.dy < overlaySize.height / 2;
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: animation,
        child: Align(
          // Grow from the anchor edge the menu opens toward.
          alignment: below ? Alignment.topCenter : Alignment.bottomCenter,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            alignment: below ? Alignment.topCenter : Alignment.bottomCenter,
            child: child,
          ),
        ),
      );
    },
  );
}

/// Positions the menu just below (or above) the anchor, clamped on-screen.
class _MenuLayout extends SingleChildLayoutDelegate {
  _MenuLayout(this.anchor, this.overlaySize);

  final Rect anchor;
  final Size overlaySize;
  static const double _margin = 8;
  static const double _gap = 6;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen().copyWith(
          maxHeight: overlaySize.height - 2 * _margin,
        );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Horizontal: align the menu's right edge with the anchor's, clamped.
    double x = anchor.right - childSize.width;
    x = x.clamp(_margin, overlaySize.width - childSize.width - _margin);

    // Vertical: prefer below the anchor; flip above if it would overflow.
    final double belowY = anchor.bottom + _gap;
    final double aboveY = anchor.top - _gap - childSize.height;
    double y;
    if (belowY + childSize.height <= overlaySize.height - _margin) {
      y = belowY;
    } else if (aboveY >= _margin) {
      y = aboveY;
    } else {
      y = (overlaySize.height - childSize.height) / 2;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_MenuLayout oldDelegate) =>
      anchor != oldDelegate.anchor || overlaySize != oldDelegate.overlaySize;
}

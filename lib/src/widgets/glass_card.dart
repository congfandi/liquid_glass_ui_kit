import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// A padded glass panel for grouping content — the frosted equivalent of a
/// material Card. Optionally tappable.
///
/// ```dart
/// GlassCard(
///   onTap: () {},
///   child: Text('Tap me'),
/// )
/// ```
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.onTap,
    this.width,
    this.height,
  });

  /// The card's content.
  final Widget child;

  /// Inner padding around [child].
  final EdgeInsetsGeometry padding;

  /// Outer margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Corner radius. Defaults to the theme's large radius.
  final BorderRadius? borderRadius;

  /// Called when the card is tapped. When null the card is not interactive.
  final VoidCallback? onTap;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final radius =
        borderRadius ?? BorderRadius.circular(theme.metrics.largeRadius);

    final surface = GlassSurface(
      borderRadius: radius,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      child: child,
    );

    if (onTap == null) return surface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: surface,
    );
  }
}

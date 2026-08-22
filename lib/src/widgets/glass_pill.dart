import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// A small capsule tag/chip for labels, filters and status badges.
///
/// ```dart
/// GlassPill(label: 'Now Available', icon: Icons.bolt_rounded)
/// ```
class GlassPill extends StatelessWidget {
  const GlassPill({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  /// The pill text.
  final String label;

  /// An optional leading icon.
  final IconData? icon;

  /// Whether the pill is in a selected state (accent-tinted).
  final bool selected;

  /// Called when tapped. When null the pill is purely decorative.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;
    final contentColor = selected ? colors.accent : colors.secondaryLabel;

    final surface = GlassSurface(
      borderRadius: BorderRadius.circular(theme.metrics.pillRadius),
      tint: selected ? colors.accent.withValues(alpha: 0.16) : null,
      borderColor: selected ? colors.accent.withValues(alpha: 0.4) : null,
      shadow: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: contentColor),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: theme.typography.footnote.copyWith(
              color: contentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return surface;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: surface,
    );
  }
}

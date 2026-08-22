import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// An iOS-style toggle with a frosted-glass track.
///
/// ```dart
/// GlassSwitch(
///   value: _on,
///   onChanged: (v) => setState(() => _on = v),
/// )
/// ```
class GlassSwitch extends StatelessWidget {
  const GlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 52,
    this.height = 32,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value when toggled. When null the switch is disabled.
  final ValueChanged<bool>? onChanged;

  /// Track width.
  final double width;

  /// Track height.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;
    final enabled = onChanged != null;
    final knobSize = height - 6;

    return Semantics(
      toggled: value,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedOpacity(
          duration: _motion(context, 150),
          opacity: enabled ? 1 : 0.4,
          child: AnimatedContainer(
            duration: _motion(context, 200),
            curve: Curves.easeInOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              color: value
                  ? colors.accent
                  : (colors.brightness == Brightness.dark
                      ? const Color(0x33FFFFFF)
                      : const Color(0x1F000000)),
            ),
            child: _knob(
              knobSize,
              value ? Alignment.centerRight : Alignment.centerLeft,
              // When "on", the track is the accent; keep the knob contrasting
              // so it stays visible even with a near-white (monochrome) accent.
              value && colors.accent.computeLuminance() > 0.5
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xF2FFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns [Duration.zero] when the user has enabled "Reduce Motion".
  static Duration _motion(BuildContext context, int milliseconds) {
    return MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : Duration(milliseconds: milliseconds);
  }

  Widget _knob(double size, Alignment alignment, Color color) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Align(
        alignment: alignment,
        child: GlassSurface(
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(size),
          tint: color,
          shadow: true,
        ),
      ),
    );
  }
}

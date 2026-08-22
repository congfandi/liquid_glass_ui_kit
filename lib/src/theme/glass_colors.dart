import 'package:flutter/widgets.dart';

/// The color palettes used across the Liquid Glass design system, modelled on
/// iOS 26.4.
///
/// Two ready-made palettes are provided: [GlassColors.light] and
/// [GlassColors.dark]. Grab the palette for the current context with
/// [GlassColors.of].
///
/// ```dart
/// final colors = GlassColors.of(context);
/// Container(color: colors.background);
/// ```
@immutable
class GlassColors {
  /// Creates a custom palette. Prefer [GlassColors.light] / [GlassColors.dark]
  /// unless you are theming the system yourself.
  const GlassColors({
    required this.brightness,
    required this.background,
    required this.secondaryBackground,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.accent,
    required this.glassTint,
    required this.glassHighlight,
    required this.glassBorder,
    required this.glassShadow,
    required this.separator,
  });

  /// Whether this palette is meant for light or dark surfaces.
  final Brightness brightness;

  /// The primary app background (`#FFFFFF` light / `#000000` dark).
  final Color background;

  /// A grouped/secondary background (`#F2F2F7` light / `#1C1C1E` dark).
  final Color secondaryBackground;

  /// Primary text and icon color (`#000000` light / `#FFFFFF` dark).
  final Color label;

  /// Secondary text color (`#3A3A3C` light / `#EBEBF5` dark).
  final Color secondaryLabel;

  /// Muted text for captions and disabled states.
  final Color tertiaryLabel;

  /// The system accent used for interactive elements.
  final Color accent;

  /// The translucent fill painted behind blurred glass surfaces.
  final Color glassTint;

  /// The near-white (light) / colored (dark) rim highlight along a glass edge.
  final Color glassHighlight;

  /// The hairline border color for glass surfaces.
  final Color glassBorder;

  /// The ambient shadow cast by floating glass surfaces.
  final Color glassShadow;

  /// Hairline separator color for lists and dividers.
  final Color separator;

  /// The light palette (bright whites, high-contrast dark text).
  static const GlassColors light = GlassColors(
    brightness: Brightness.light,
    background: Color(0xFFFFFFFF),
    secondaryBackground: Color(0xFFF2F2F7),
    label: Color(0xFF000000),
    secondaryLabel: Color(0xFF3A3A3C),
    tertiaryLabel: Color(0x993A3A3C),
    // Monochrome accent — pure glass + graphite, no color tint.
    accent: Color(0xFF1C1C1E),
    glassTint: Color(0x66FFFFFF),
    glassHighlight: Color(0xF2FFFFFF),
    glassBorder: Color(0x33FFFFFF),
    glassShadow: Color(0x1F000000),
    separator: Color(0x3C3C3C43),
  );

  /// The dark palette (deep grays, softened light text, colored rim glow).
  static const GlassColors dark = GlassColors(
    brightness: Brightness.dark,
    background: Color(0xFF000000),
    secondaryBackground: Color(0xFF1C1C1E),
    label: Color(0xFFFFFFFF),
    secondaryLabel: Color(0xFFEBEBF5),
    tertiaryLabel: Color(0x99EBEBF5),
    // Monochrome accent — near-white so primary actions read as bright glass.
    accent: Color(0xFFF2F2F7),
    glassTint: Color(0x40FFFFFF),
    glassHighlight: Color(0x66A0B4FF),
    glassBorder: Color(0x33FFFFFF),
    glassShadow: Color(0x66000000),
    separator: Color(0x99545458),
  );

  /// Returns the palette that matches the current [MediaQuery] brightness.
  ///
  /// Falls back to [light] when there is no ambient media query.
  static GlassColors of(BuildContext context) {
    final brightness = MediaQuery.maybePlatformBrightnessOf(context) ??
        Brightness.light;
    return brightness == Brightness.dark ? dark : light;
  }

  /// A copy of this palette with the given fields replaced.
  GlassColors copyWith({
    Brightness? brightness,
    Color? background,
    Color? secondaryBackground,
    Color? label,
    Color? secondaryLabel,
    Color? tertiaryLabel,
    Color? accent,
    Color? glassTint,
    Color? glassHighlight,
    Color? glassBorder,
    Color? glassShadow,
    Color? separator,
  }) {
    return GlassColors(
      brightness: brightness ?? this.brightness,
      background: background ?? this.background,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      label: label ?? this.label,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      tertiaryLabel: tertiaryLabel ?? this.tertiaryLabel,
      accent: accent ?? this.accent,
      glassTint: glassTint ?? this.glassTint,
      glassHighlight: glassHighlight ?? this.glassHighlight,
      glassBorder: glassBorder ?? this.glassBorder,
      glassShadow: glassShadow ?? this.glassShadow,
      separator: separator ?? this.separator,
    );
  }
}

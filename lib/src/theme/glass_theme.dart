import 'package:flutter/widgets.dart';

import 'glass_colors.dart';
import 'glass_typography.dart';

/// The tunable metrics shared by every glass surface: blur strength, corner
/// radii and border width. Keeping these in one place lets a whole app feel
/// consistent, and lets you dial the effect up or down globally.
@immutable
class GlassMetrics {
  const GlassMetrics({
    this.blurSigma = 24,
    this.borderWidth = 1,
    this.smallRadius = 12,
    this.mediumRadius = 20,
    this.largeRadius = 28,
    this.pillRadius = 999,
  });

  /// Gaussian blur sigma applied behind glass surfaces.
  final double blurSigma;

  /// Hairline border width for the rim highlight.
  final double borderWidth;

  /// Corner radius for compact elements (chips, small buttons).
  final double smallRadius;

  /// Corner radius for cards and standard surfaces.
  final double mediumRadius;

  /// Corner radius for large floating panels (nav bars, sheets).
  final double largeRadius;

  /// Effectively-capsule radius for pills and toggles.
  final double pillRadius;

  GlassMetrics copyWith({
    double? blurSigma,
    double? borderWidth,
    double? smallRadius,
    double? mediumRadius,
    double? largeRadius,
    double? pillRadius,
  }) {
    return GlassMetrics(
      blurSigma: blurSigma ?? this.blurSigma,
      borderWidth: borderWidth ?? this.borderWidth,
      smallRadius: smallRadius ?? this.smallRadius,
      mediumRadius: mediumRadius ?? this.mediumRadius,
      largeRadius: largeRadius ?? this.largeRadius,
      pillRadius: pillRadius ?? this.pillRadius,
    );
  }
}

/// The full theme bundle: palette, type scale, and metrics.
@immutable
class GlassThemeData {
  GlassThemeData({
    required this.colors,
    GlassTypography? typography,
    this.metrics = const GlassMetrics(),
  }) : typography = typography ?? GlassTypography.forColors(colors);

  /// The active color palette.
  final GlassColors colors;

  /// The active type scale.
  final GlassTypography typography;

  /// The active glass metrics.
  final GlassMetrics metrics;

  /// The default light theme.
  factory GlassThemeData.light({GlassMetrics metrics = const GlassMetrics()}) =>
      GlassThemeData(colors: GlassColors.light, metrics: metrics);

  /// The default dark theme.
  factory GlassThemeData.dark({GlassMetrics metrics = const GlassMetrics()}) =>
      GlassThemeData(colors: GlassColors.dark, metrics: metrics);

  GlassThemeData copyWith({
    GlassColors? colors,
    GlassTypography? typography,
    GlassMetrics? metrics,
  }) {
    return GlassThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      metrics: metrics ?? this.metrics,
    );
  }
}

/// Provides a [GlassThemeData] to the widget subtree.
///
/// Wrap your app (or any subtree) so glass widgets can resolve the shared
/// palette, typography and metrics with [GlassTheme.of].
///
/// ```dart
/// GlassTheme(
///   data: GlassThemeData.dark(),
///   child: MyApp(),
/// )
/// ```
class GlassTheme extends InheritedWidget {
  const GlassTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme carried down the tree.
  final GlassThemeData data;

  /// Returns the nearest [GlassThemeData].
  ///
  /// If no [GlassTheme] is found, a theme is synthesized from the ambient
  /// platform brightness so widgets still render sensibly.
  static GlassThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<GlassTheme>();
    if (widget != null) return widget.data;
    return GlassThemeData(colors: GlassColors.of(context));
  }

  /// Like [of] but returns null when no [GlassTheme] is present.
  static GlassThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlassTheme>()?.data;
  }

  @override
  bool updateShouldNotify(GlassTheme oldWidget) => data != oldWidget.data;
}

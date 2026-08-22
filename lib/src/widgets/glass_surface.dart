import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';

/// The foundational Liquid Glass primitive: a blurred, tinted panel with a
/// bright rim highlight and a soft ambient shadow. Every other component in the
/// package is built on top of it.
///
/// It reads defaults (tint, highlight, blur, shadow) from the nearest
/// [GlassTheme], and any of them can be overridden per instance.
///
/// ```dart
/// GlassSurface(
///   borderRadius: BorderRadius.circular(24),
///   padding: const EdgeInsets.all(16),
///   child: Text('Frosted'),
/// )
/// ```
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.blurSigma,
    this.tint,
    this.highlight,
    this.borderColor,
    this.borderWidth,
    this.shadow = true,
    this.shadowColor,
    this.clipBehavior = Clip.antiAlias,
    this.alignment,
  });

  /// The content painted on top of the glass.
  final Widget? child;

  /// Corner radius. Defaults to the theme's medium radius.
  final BorderRadius? borderRadius;

  /// Inner padding around [child].
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the surface.
  final EdgeInsetsGeometry? margin;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Gaussian blur sigma. Defaults to the theme's [GlassMetrics.blurSigma].
  final double? blurSigma;

  /// The translucent fill color. Defaults to the palette's glass tint.
  final Color? tint;

  /// The rim highlight color. Defaults to the palette's glass highlight.
  final Color? highlight;

  /// The border color. Defaults to the palette's glass border.
  final Color? borderColor;

  /// The border width. Defaults to the theme's border width.
  final double? borderWidth;

  /// Whether to cast an ambient shadow.
  final bool shadow;

  /// Custom shadow color. Defaults to the palette's glass shadow.
  final Color? shadowColor;

  /// How to clip the blurred content.
  final Clip clipBehavior;

  /// Alignment of the [child] within the surface.
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics;

    final radius = borderRadius ??
        BorderRadius.circular(metrics.mediumRadius);
    final effectiveTint = tint ?? colors.glassTint;
    final effectiveHighlight = highlight ?? colors.glassHighlight;
    final effectiveBorder = borderColor ?? colors.glassBorder;
    final effectiveBorderWidth = borderWidth ?? metrics.borderWidth;
    final sigma = blurSigma ?? metrics.blurSigma;

    // Accessibility: when the user has asked for reduced transparency / higher
    // contrast, drop the blur and translucency for an opaque, clearly-bordered
    // surface. This follows Apple's Liquid Glass guidance and keeps text legible
    // over busy backgrounds (WCAG contrast).
    final bool reduceTransparency = MediaQuery.highContrastOf(context);

    Widget content;
    if (reduceTransparency) {
      final Color base = colors.brightness == Brightness.dark
          ? colors.secondaryBackground
          : colors.background;
      content = ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Color.alphaBlend(effectiveTint, base),
            border: Border.all(
              color: colors.label.withValues(alpha: 0.35),
              width: effectiveBorderWidth < 1 ? 1 : effectiveBorderWidth,
            ),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              // Diagonal wash makes the tint read as curved glass rather than a
              // flat color fill.
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  effectiveTint,
                  effectiveTint.withValues(
                    alpha: (effectiveTint.a * 0.7).clamp(0.0, 1.0),
                  ),
                ],
              ),
              border: Border.all(
                color: effectiveBorder,
                width: effectiveBorderWidth,
              ),
            ),
            child: _RimHighlight(
              radius: radius,
              highlight: effectiveHighlight,
              width: effectiveBorderWidth,
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    if (alignment != null) {
      content = Align(alignment: alignment!, child: content);
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: shadow
          ? BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: shadowColor ?? colors.glassShadow,
                  blurRadius: 30,
                  spreadRadius: -6,
                  offset: const Offset(0, 12),
                ),
              ],
            )
          : null,
      child: content,
    );
  }
}

/// Paints a soft highlight along the top edge to fake a specular rim.
class _RimHighlight extends StatelessWidget {
  const _RimHighlight({
    required this.child,
    required this.radius,
    required this.highlight,
    required this.width,
  });

  final Widget child;
  final BorderRadius radius;
  final Color highlight;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    highlight.withValues(
                      alpha: (highlight.a * 0.9).clamp(0.0, 1.0),
                    ),
                    highlight.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.35],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

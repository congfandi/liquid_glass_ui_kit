import 'package:flutter/widgets.dart';

import 'glass_colors.dart';

/// A type scale mirroring Apple's SF Pro text styles used throughout iOS 26.4.
///
/// The package does not bundle the SF Pro font (Apple's license does not allow
/// redistribution). On Apple platforms Flutter already renders with the system
/// font when [TextStyle.fontFamily] is left null, so these styles look native
/// out of the box. On Android/web, supply your own font via
/// [GlassTypography.apply] or by setting a default font in your app theme.
@immutable
class GlassTypography {
  const GlassTypography({
    required this.largeTitle,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.headline,
    required this.body,
    required this.callout,
    required this.subheadline,
    required this.footnote,
    required this.caption,
    required this.button,
    required this.tabLabel,
  });

  /// 34pt bold — screen titles.
  final TextStyle largeTitle;

  /// 28pt — primary section titles.
  final TextStyle title1;

  /// 22pt — secondary titles.
  final TextStyle title2;

  /// 20pt — tertiary titles.
  final TextStyle title3;

  /// 17pt semibold — emphasized body / row headlines.
  final TextStyle headline;

  /// 17pt — default body copy.
  final TextStyle body;

  /// 16pt — callouts.
  final TextStyle callout;

  /// 15pt — subheadlines.
  final TextStyle subheadline;

  /// 13pt — footnotes.
  final TextStyle footnote;

  /// 12pt — captions and metadata.
  final TextStyle caption;

  /// 17pt semibold — button labels.
  final TextStyle button;

  /// 10pt medium — bottom nav / tab bar labels.
  final TextStyle tabLabel;

  /// Builds the default type scale for a [palette].
  factory GlassTypography.forColors(GlassColors palette) {
    final Color label = palette.label;
    // Every style opts out of decorations so text renders cleanly even when
    // there is no Material ancestor (which otherwise leaks Flutter's yellow
    // "missing style" underline).
    final scale = GlassTypography(
      largeTitle: TextStyle(
        fontSize: 34,
        height: 41 / 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: label,
      ),
      title1: TextStyle(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.36,
        color: label,
      ),
      title2: TextStyle(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.35,
        color: label,
      ),
      title3: TextStyle(
        fontSize: 20,
        height: 25 / 20,
        fontWeight: FontWeight.w600,
        color: label,
      ),
      headline: TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: label,
      ),
      body: TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        color: label,
      ),
      callout: TextStyle(
        fontSize: 16,
        height: 21 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
        color: label,
      ),
      subheadline: TextStyle(
        fontSize: 15,
        height: 20 / 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
        color: palette.secondaryLabel,
      ),
      footnote: TextStyle(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w400,
        color: palette.secondaryLabel,
      ),
      caption: TextStyle(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: palette.tertiaryLabel,
      ),
      button: TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: label,
      ),
      tabLabel: TextStyle(
        fontSize: 10,
        height: 12 / 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: label,
      ),
    );
    return scale._map((s) => s.copyWith(decoration: TextDecoration.none));
  }

  /// Applies [transform] to every style and returns the result.
  GlassTypography _map(TextStyle Function(TextStyle) transform) {
    return GlassTypography(
      largeTitle: transform(largeTitle),
      title1: transform(title1),
      title2: transform(title2),
      title3: transform(title3),
      headline: transform(headline),
      body: transform(body),
      callout: transform(callout),
      subheadline: transform(subheadline),
      footnote: transform(footnote),
      caption: transform(caption),
      button: transform(button),
      tabLabel: transform(tabLabel),
    );
  }

  /// Returns a copy with [fontFamily] applied to every style. Use this to plug
  /// in a bundled font (for example an SF-Pro-alike) on Android and web.
  GlassTypography apply({String? fontFamily, List<String>? fontFamilyFallback}) {
    return _map(
      (s) => s.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }
}

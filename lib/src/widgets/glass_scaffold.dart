import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';

/// A lightweight page scaffold that paints a themed background and floats a
/// [GlassAppBar] and/or a [GlassBottomNavBar] over the scrollable [body].
///
/// Unlike Material's `Scaffold`, both bars are drawn *over* the body so content
/// blurs through them as it scrolls — the whole point of the glass look. Add
/// top/bottom padding to your scroll view (or use [bodyPadding]) so content
/// isn't hidden behind the bars.
///
/// ```dart
/// GlassScaffold(
///   appBar: GlassAppBar(title: Text('Home')),
///   bottomNavigationBar: GlassBottomNavBar(...),
///   body: ListView(...),
/// )
/// ```
class GlassScaffold extends StatelessWidget {
  const GlassScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.background,
    this.bodyPadding,
  });

  /// The main page content, drawn full-bleed behind the bars.
  final Widget body;

  /// An optional floating top bar (typically a [GlassAppBar]).
  final PreferredSizeWidget? appBar;

  /// An optional floating bottom bar (typically a [GlassBottomNavBar]).
  final Widget? bottomNavigationBar;

  /// A custom background painted behind everything. Defaults to a subtle
  /// vertical gradient built from the palette so the glass has something to
  /// refract. Pass an [Image], gradient container, or any widget.
  final Widget? background;

  /// Padding applied around [body]. Handy for keeping content clear of the
  /// floating bars.
  final EdgeInsetsGeometry? bodyPadding;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;

    return DefaultTextStyle.merge(
      style: theme.typography.body,
      child: Stack(
        children: [
          Positioned.fill(
            child: background ??
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.background,
                        colors.secondaryBackground,
                      ],
                    ),
                  ),
                ),
          ),
          Positioned.fill(
            child: Padding(
              padding: bodyPadding ?? EdgeInsets.zero,
              child: body,
            ),
          ),
          if (appBar != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: appBar!,
            ),
          if (bottomNavigationBar != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: bottomNavigationBar!,
            ),
        ],
      ),
    );
  }
}

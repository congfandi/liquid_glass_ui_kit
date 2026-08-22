import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// A translucent top bar that blurs content scrolling beneath it.
///
/// It implements [PreferredSizeWidget] so it can be handed straight to a
/// [GlassScaffold] (or a Material `Scaffold.appBar`, given a `Material`
/// ancestor for the ripple-free glass content).
///
/// ```dart
/// GlassScaffold(
///   appBar: GlassAppBar(
///     title: Text('Home'),
///     actions: [Icon(Icons.more_horiz)],
///   ),
///   body: ...,
/// )
/// ```
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions = const [],
    this.centerTitle = true,
    this.height = 52,
    this.floating = true,
  });

  /// The centered (or leading) title widget.
  final Widget? title;

  /// A leading widget, typically a back button.
  final Widget? leading;

  /// Trailing action widgets.
  final List<Widget> actions;

  /// Whether the title is centered. When false it is left-aligned.
  final bool centerTitle;

  /// The height of the bar content, excluding the top safe-area inset.
  final double height;

  /// When true the bar floats with rounded corners and side margins; when false
  /// it spans edge to edge like a classic nav bar.
  final bool floating;

  @override
  Size get preferredSize => Size.fromHeight(height + 8);

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;

    final titleWidget = title == null
        ? null
        : DefaultTextStyle.merge(
            style: theme.typography.headline,
            child: title!,
          );

    final bar = SizedBox(
      height: height,
      child: IconTheme.merge(
        data: IconThemeData(color: theme.colors.label, size: 24),
        child: NavigationToolbar(
          leading: leading,
          middle: titleWidget,
          trailing: actions.isEmpty
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final a in actions) ...[
                      a,
                      const SizedBox(width: 16),
                    ]
                  ],
                ),
          centerMiddle: centerTitle,
          middleSpacing: 8,
        ),
      ),
    );

    if (floating) {
      return Padding(
        padding: EdgeInsets.fromLTRB(12, topInset + 6, 12, 0),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(theme.metrics.largeRadius),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: bar,
        ),
      );
    }

    return GlassSurface(
      borderRadius: BorderRadius.zero,
      shadow: false,
      padding: EdgeInsets.only(top: topInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: bar,
      ),
    );
  }
}

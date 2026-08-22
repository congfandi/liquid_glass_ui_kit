import 'package:flutter/material.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// A Liquid-Glass bottom sheet panel — rounded top corners, a translucent
/// blurred body and an optional grab handle, matching the iOS 26.4 sheet style.
///
/// Use it directly for a pinned/persistent sheet, or present it modally with
/// [showGlassBottomSheet].
///
/// ```dart
/// GlassSheet(
///   title: 'Options',
///   child: Column(children: [...]),
/// )
/// ```
class GlassSheet extends StatelessWidget {
  const GlassSheet({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 20),
    this.heightFactor,
  });

  /// The sheet's content.
  final Widget child;

  /// An optional title shown under the grab handle.
  final String? title;

  /// Whether to show the grab handle at the top.
  final bool showDragHandle;

  /// Padding around [child] (below the handle/title).
  final EdgeInsetsGeometry padding;

  /// When set (0–1), the sheet takes this fraction of the screen height. Leave
  /// null to size to content. Give scrollable content a factor near 0.9.
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;
    final radius = Radius.circular(theme.metrics.largeRadius + 8);

    Widget column = Column(
      mainAxisSize: heightFactor == null ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDragHandle)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.secondaryLabel.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: theme.typography.headline,
            ),
          ),
        if (heightFactor == null)
          Padding(padding: padding, child: child)
        else
          Expanded(child: Padding(padding: padding, child: child)),
      ],
    );

    Widget sheet = GlassSurface(
      borderRadius: BorderRadius.vertical(top: radius),
      // A slightly heavier blur reads as the thick material iOS uses for sheets.
      blurSigma: theme.metrics.blurSigma + 6,
      child: SafeArea(
        top: false,
        child: DefaultTextStyle.merge(
          style: theme.typography.body,
          child: column,
        ),
      ),
    );

    if (heightFactor != null) {
      sheet = FractionallySizedBox(
        heightFactor: heightFactor!.clamp(0.2, 1.0),
        alignment: Alignment.bottomCenter,
        child: sheet,
      );
    }

    return sheet;
  }
}

/// Presents a [GlassSheet] modally from the bottom, with a scrim, slide-up
/// animation and drag-to-dismiss (courtesy of Flutter's modal sheet machinery).
///
/// Requires a [Navigator]/`MaterialApp` ancestor, as with any modal route.
///
/// ```dart
/// showGlassBottomSheet(
///   context: context,
///   title: 'Share',
///   builder: (context) => Column(children: [...]),
/// );
/// ```
Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  double? heightFactor,
  Color? barrierColor,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    elevation: 0,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.32),
    builder: (context) => GlassSheet(
      title: title,
      showDragHandle: showDragHandle,
      heightFactor: heightFactor,
      child: Builder(builder: builder),
    ),
  );
}

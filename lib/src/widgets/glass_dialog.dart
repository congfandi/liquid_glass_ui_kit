import 'package:flutter/material.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// One button in a [GlassDialog].
@immutable
class GlassDialogAction {
  const GlassDialogAction({
    required this.label,
    this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });

  /// The button text.
  final String label;

  /// Called when tapped. The dialog does not pop itself — do that in the
  /// callback (e.g. `Navigator.pop(context)`), as with an iOS alert.
  final VoidCallback? onPressed;

  /// Emphasizes the action (bold) as the preferred choice.
  final bool isDefault;

  /// Renders the action in the destructive (red) style.
  final bool isDestructive;
}

/// A centered Liquid-Glass alert dialog, styled after the iOS 26.4 popup: a
/// frosted rounded card with a title, message and hairline-separated actions
/// (side-by-side for two, stacked otherwise).
///
/// Present it with [showGlassDialog].
class GlassDialog extends StatelessWidget {
  const GlassDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.actions = const [],
  });

  /// Bold title line.
  final String? title;

  /// Secondary message under the title.
  final String? message;

  /// Custom body used instead of [message] when provided.
  final Widget? content;

  /// The action buttons.
  final List<GlassDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;
    final separator = colors.separator;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(theme.metrics.largeRadius + 6),
          blurSigma: theme.metrics.blurSigma + 6,
          child: DefaultTextStyle.merge(
            style: theme.typography.body,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: theme.typography.headline,
                        ),
                      if (title != null && (message != null || content != null))
                        const SizedBox(height: 6),
                      if (content != null)
                        content!
                      else if (message != null)
                        Text(
                          message!,
                          textAlign: TextAlign.center,
                          style: theme.typography.subheadline,
                        ),
                    ],
                  ),
                ),
                if (actions.isNotEmpty) _buildActions(context, separator),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, Color separator) {
    final divider = Container(height: 0.5, color: separator);

    // Two actions sit side by side; anything else stacks vertically.
    if (actions.length == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          divider,
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _ActionButton(action: actions[0])),
                Container(width: 0.5, color: separator),
                Expanded(child: _ActionButton(action: actions[1])),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final action in actions) ...[
          divider,
          _ActionButton(action: action),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final GlassDialogAction action;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;

    final Color color = action.isDestructive
        ? (colors.brightness == Brightness.dark
            ? const Color(0xFFFF453A)
            : const Color(0xFFFF3B30))
        : colors.accent;

    return Semantics(
      button: true,
      enabled: action.onPressed != null,
      label: action.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Text(
            action.label,
            textAlign: TextAlign.center,
            style: theme.typography.button.copyWith(
              color:
                  color.withValues(alpha: action.onPressed == null ? 0.4 : 1),
              fontWeight: action.isDefault ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Presents a [GlassDialog] with a scrim and a scale-and-fade transition.
///
/// Requires a [Navigator]/`MaterialApp` ancestor.
///
/// ```dart
/// showGlassDialog(
///   context: context,
///   title: 'Delete item?',
///   message: 'This cannot be undone.',
///   actions: [
///     GlassDialogAction(label: 'Cancel', onPressed: () => Navigator.pop(context)),
///     GlassDialogAction(
///       label: 'Delete',
///       isDestructive: true,
///       onPressed: () => Navigator.pop(context),
///     ),
///   ],
/// );
/// ```
Future<T?> showGlassDialog<T>({
  required BuildContext context,
  String? title,
  String? message,
  Widget? content,
  List<GlassDialogAction> actions = const [],
  bool barrierDismissible = true,
  Color? barrierColor,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.32),
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 220),
    pageBuilder: (context, _, __) => GlassDialog(
      title: title,
      message: message,
      content: content,
      actions: actions,
    ),
    transitionBuilder: (context, animation, _, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

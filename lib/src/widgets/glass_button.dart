import 'package:flutter/widgets.dart';

import '../theme/glass_theme.dart';
import 'glass_surface.dart';

/// Visual variants for [GlassButton].
enum GlassButtonVariant {
  /// Translucent frosted glass with the label in the accent color.
  glass,

  /// Solid accent-filled capsule with a light label — the primary call to
  /// action.
  filled,

  /// No fill; just a tappable label in the accent color.
  plain,
}

/// A capsule button in the Liquid Glass style, with a press-in animation.
///
/// ```dart
/// GlassButton(
///   label: 'Continue',
///   icon: Icons.arrow_forward,
///   variant: GlassButtonVariant.filled,
///   onPressed: () {},
/// )
/// ```
class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    this.label,
    this.icon,
    this.child,
    this.onPressed,
    this.variant = GlassButtonVariant.glass,
    this.expand = false,
    this.padding,
  }) : assert(label != null || child != null || icon != null,
            'Provide a label, an icon, or a child.');

  /// The text label.
  final String? label;

  /// An optional leading icon.
  final IconData? icon;

  /// A fully custom child, used instead of [label]/[icon] when provided.
  final Widget? child;

  /// Called when the button is tapped. When null the button is disabled.
  final VoidCallback? onPressed;

  /// The visual style.
  final GlassButtonVariant variant;

  /// Whether the button should stretch to fill its parent's width.
  final bool expand;

  /// Custom inner padding.
  final EdgeInsetsGeometry? padding;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final colors = theme.colors;
    final radius = BorderRadius.circular(theme.metrics.pillRadius);
    final padding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

    final Color labelColor;
    switch (widget.variant) {
      case GlassButtonVariant.filled:
        // Pick black or white text based on how light the accent is, so the
        // label stays legible whatever accent the theme uses.
        labelColor = colors.accent.computeLuminance() > 0.5
            ? const Color(0xFF000000)
            : const Color(0xFFFFFFFF);
        break;
      case GlassButtonVariant.glass:
      case GlassButtonVariant.plain:
        labelColor = colors.accent;
        break;
    }

    Widget content = DefaultTextStyle.merge(
      style: theme.typography.button.copyWith(color: labelColor),
      child: IconTheme.merge(
        data: IconThemeData(color: labelColor, size: 20),
        child: widget.child ?? _buildDefaultContent(),
      ),
    );

    content = Padding(padding: padding, child: content);

    Widget button;
    switch (widget.variant) {
      case GlassButtonVariant.glass:
        button = GlassSurface(
          borderRadius: radius,
          child: content,
        );
        break;
      case GlassButtonVariant.filled:
        button = DecoratedBox(
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: colors.accent.withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: content,
        );
        break;
      case GlassButtonVariant.plain:
        button = content;
        break;
    }

    // Respect the "Reduce Motion" accessibility setting.
    final Duration motion = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 120);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedOpacity(
          opacity: _enabled ? 1 : 0.4,
          duration: motion,
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1,
            duration: motion,
            curve: Curves.easeOut,
            child: widget.expand
                ? SizedBox(width: double.infinity, child: button)
                : button,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    final children = <Widget>[
      if (widget.icon != null) Icon(widget.icon),
      if (widget.icon != null && widget.label != null) const SizedBox(width: 8),
      if (widget.label != null) Flexible(child: Text(widget.label!)),
    ];
    return Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

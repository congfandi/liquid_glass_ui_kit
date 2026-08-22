import 'package:flutter/material.dart';
import 'package:liquid_glass_ui_kit/liquid_glass_ui_kit.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool _dark = true;
  int _tab = 0;
  bool _switchOn = true;
  bool _animateIndicator = true;
  bool _animateBounce = true;
  bool _showLabels = true;

  void _openSheet(BuildContext context) {
    showGlassBottomSheet(
      context: context,
      title: 'Share',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Choose how you want to share this item.'),
          const SizedBox(height: 20),
          GlassButton(
            label: 'Copy link',
            icon: Icons.link_rounded,
            variant: GlassButtonVariant.glass,
            expand: true,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
          GlassButton(
            label: 'Done',
            variant: GlassButtonVariant.filled,
            expand: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _openDialog(BuildContext context) {
    showGlassDialog(
      context: context,
      title: 'Delete item?',
      message: 'This action cannot be undone.',
      actions: [
        GlassDialogAction(
          label: 'Cancel',
          isDefault: true,
          onPressed: () => Navigator.pop(context),
        ),
        GlassDialogAction(
          label: 'Delete',
          isDestructive: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _openMenu(BuildContext context) {
    showGlassActionMenu(
      context: context,
      items: [
        const GlassMenuItem(label: 'Edit', icon: Icons.edit_outlined),
        const GlassMenuItem(label: 'Duplicate', icon: Icons.copy_rounded),
        const GlassMenuItem(label: 'Share', icon: Icons.ios_share_rounded),
        const GlassMenuItem(
          label: 'Delete',
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
        ),
      ],
    );
  }

  static const _items = [
    GlassNavItem(icon: Icons.home_rounded, label: 'Home'),
    GlassNavItem(icon: Icons.sports_esports_rounded, label: 'Arcade'),
    GlassNavItem(icon: Icons.group_rounded, label: 'Friends'),
    GlassNavItem(icon: Icons.inventory_2_rounded, label: 'Library'),
    GlassNavItem(icon: Icons.search_rounded, label: 'Search'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liquid Glass UI',
      home: GlassTheme(
        data: _dark ? GlassThemeData.dark() : GlassThemeData.light(),
        child: Builder(
          builder: (context) {
            final theme = GlassTheme.of(context);
            return GlassScaffold(
              // A colorful backdrop so the glass has something to refract.
              background: const _Backdrop(),
              appBar: GlassAppBar(
                title: const Text('Liquid Glass'),
                leading: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                actions: [
                  GlassSwitch(
                    value: _dark,
                    onChanged: (v) => setState(() => _dark = v),
                  ),
                ],
              ),
              bottomNavigationBar: GlassBottomNavBar(
                currentIndex: _tab,
                onTap: (i) => setState(() => _tab = i),
                items: _items,
                animateIndicator: _animateIndicator,
                animateBounce: _animateBounce,
                showLabels: _showLabels,
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 120, 16, 150),
                children: [
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      GlassPill(
                        label: 'Now Available',
                        icon: Icons.bolt_rounded,
                      ),
                      GlassPill(label: 'iOS 26.4', selected: true),
                      GlassPill(label: 'Glassmorphism'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frosted card', style: theme.typography.title3),
                        const SizedBox(height: 8),
                        Text(
                          'Everything reads its blur, tint and rim highlight '
                          'from a single GlassTheme.',
                          style: theme.typography.subheadline,
                        ),
                        const SizedBox(height: 16),
                        _ToggleRow(
                          label: 'Notifications',
                          value: _switchOn,
                          onChanged: (v) => setState(() => _switchOn = v),
                        ),
                        const SizedBox(height: 12),
                        _ToggleRow(
                          label: 'Nav: slide indicator',
                          value: _animateIndicator,
                          onChanged: (v) =>
                              setState(() => _animateIndicator = v),
                        ),
                        const SizedBox(height: 12),
                        _ToggleRow(
                          label: 'Nav: bounce icon',
                          value: _animateBounce,
                          onChanged: (v) => setState(() => _animateBounce = v),
                        ),
                        const SizedBox(height: 12),
                        _ToggleRow(
                          label: 'Nav: show labels',
                          value: _showLabels,
                          onChanged: (v) => setState(() => _showLabels = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlassButton(
                    label: 'Filled action',
                    icon: Icons.arrow_forward_rounded,
                    variant: GlassButtonVariant.filled,
                    expand: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  GlassButton(
                    label: 'Glass action',
                    variant: GlassButtonVariant.glass,
                    expand: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: GlassButton(
                      label: 'Plain action',
                      variant: GlassButtonVariant.plain,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassButton(
                    label: 'Bottom sheet',
                    icon: Icons.vertical_align_bottom_rounded,
                    variant: GlassButtonVariant.glass,
                    expand: true,
                    onPressed: () => _openSheet(context),
                  ),
                  const SizedBox(height: 12),
                  GlassButton(
                    label: 'Popup dialog',
                    icon: Icons.chat_bubble_outline_rounded,
                    variant: GlassButtonVariant.glass,
                    expand: true,
                    onPressed: () => _openDialog(context),
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (buttonContext) => GlassButton(
                      label: 'Action menu',
                      icon: Icons.more_horiz_rounded,
                      variant: GlassButtonVariant.glass,
                      expand: true,
                      onPressed: () => _openMenu(buttonContext),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A label + [GlassSwitch] row used in the demo card.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.typography.body)),
        GlassSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// A simple colorful gradient so the glass blur is visible.
class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3A1C71),
            Color(0xFFD76D77),
            Color(0xFF2E8B8B),
          ],
        ),
      ),
    );
  }
}

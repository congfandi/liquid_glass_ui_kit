/// Liquid Glass UI — an iOS 26.4 "Liquid Glass" theme and component kit for
/// Flutter.
///
/// Wrap your app in a [GlassTheme], then drop in the components:
///
/// ```dart
/// import 'package:liquid_glass_ui/liquid_glass_ui.dart';
///
/// GlassTheme(
///   data: GlassThemeData.dark(),
///   child: GlassScaffold(
///     appBar: GlassAppBar(title: Text('Home')),
///     bottomNavigationBar: GlassBottomNavBar(...),
///     body: ...,
///   ),
/// );
/// ```
library liquid_glass_ui;

// Theme
export 'src/theme/glass_colors.dart';
export 'src/theme/glass_typography.dart';
export 'src/theme/glass_theme.dart';

// Widgets
export 'src/widgets/glass_surface.dart';
export 'src/widgets/glass_button.dart';
export 'src/widgets/glass_bottom_nav_bar.dart';
export 'src/widgets/glass_card.dart';
export 'src/widgets/glass_app_bar.dart';
export 'src/widgets/glass_pill.dart';
export 'src/widgets/glass_switch.dart';
export 'src/widgets/glass_scaffold.dart';
export 'src/widgets/glass_bottom_sheet.dart';
export 'src/widgets/glass_dialog.dart';
export 'src/widgets/glass_action_menu.dart';

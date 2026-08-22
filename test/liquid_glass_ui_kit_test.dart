import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_ui_kit/liquid_glass_ui_kit.dart';

Widget _wrap(Widget child, {GlassThemeData? theme}) {
  return MaterialApp(
    home: GlassTheme(
      data: theme ?? GlassThemeData.dark(),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('GlassTheme', () {
    testWidgets('provides data via of()', (tester) async {
      late GlassThemeData resolved;
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              resolved = GlassTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved.colors.brightness, Brightness.dark);
      expect(resolved.colors, GlassColors.dark);
    });

    testWidgets('synthesizes a theme when none is provided', (tester) async {
      late GlassThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              resolved = GlassTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved.colors, isNotNull);
    });
  });

  testWidgets('GlassButton fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(GlassButton(label: 'Tap', onPressed: () => taps++)),
    );
    await tester.tap(find.text('Tap'));
    expect(taps, 1);
  });

  testWidgets('GlassButton is disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(_wrap(const GlassButton(label: 'Off')));
    expect(find.text('Off'), findsOneWidget);
    // No throw when tapping a disabled button.
    await tester.tap(find.text('Off'));
  });

  testWidgets('GlassBottomNavBar reports tapped index', (tester) async {
    var tapped = -1;
    await tester.pumpWidget(
      _wrap(
        GlassBottomNavBar(
          currentIndex: 0,
          onTap: (i) => tapped = i,
          items: const [
            GlassNavItem(icon: Icons.home, label: 'Home'),
            GlassNavItem(icon: Icons.search, label: 'Search'),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Search'));
    expect(tapped, 1);
  });

  testWidgets('GlassSwitch toggles', (tester) async {
    bool? value;
    await tester.pumpWidget(
      _wrap(GlassSwitch(value: false, onChanged: (v) => value = v)),
    );
    await tester.tap(find.byType(GlassSwitch));
    expect(value, true);
  });

  testWidgets('GlassCard onTap fires', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(GlassCard(onTap: () => taps++, child: const Text('card'))),
    );
    await tester.tap(find.text('card'));
    expect(taps, 1);
  });

  testWidgets('showGlassDialog shows title and message', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      _wrap(Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      })),
    );
    showGlassDialog(
      context: ctx,
      title: 'Delete?',
      message: 'Cannot undo.',
      actions: [GlassDialogAction(label: 'OK', onPressed: () {})],
    );
    await tester.pumpAndSettle();
    expect(find.text('Delete?'), findsOneWidget);
    expect(find.text('Cannot undo.'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('showGlassBottomSheet shows content', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      _wrap(Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      })),
    );
    showGlassBottomSheet(
      context: ctx,
      title: 'Share',
      builder: (_) => const Text('sheet body'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('sheet body'), findsOneWidget);
  });

  test('copyWith overrides only given fields', () {
    final custom = GlassColors.light.copyWith(accent: const Color(0xFF112233));
    expect(custom.accent, const Color(0xFF112233));
    expect(custom.background, GlassColors.light.background);
  });
}

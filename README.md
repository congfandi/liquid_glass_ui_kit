# Liquid Glass UI

An **iOS 26.4 "Liquid Glass"** theme and component kit for Flutter. Drop in a
frosted, translucent design system — colors, typography and ready-made widgets —
and get the native-feeling glassmorphism look on any platform.

Everything is themeable through a single `GlassTheme`, and every component reads
its blur, tint, rim-highlight and radii from that one place, so your whole app
stays consistent.

![Liquid Glass UI example showing cards, controls, overlays, and navigation](https://raw.githubusercontent.com/congfandi/liquid_glass_ui_kit/main/example.gif?v=0.1.1)

[Live documentation](https://congfandi.github.io/liquid_glass_ui_kit/) ·
[Source code](https://github.com/congfandi/liquid_glass_ui_kit) ·
[Report an issue](https://github.com/congfandi/liquid_glass_ui_kit/issues)

- 🧊 Real `BackdropFilter` glass with a rim highlight and soft shadow
- 🌗 Light & dark, **monochrome by default** (glass + white, no blue)
- 🎞️ Smooth nav-bar animations (sliding bubble + springy pop), each toggleable
- ♿ Honors **Reduce Transparency / Increase Contrast** and **Reduce Motion**
- 📦 Tiny, dependency-free (only the Flutter SDK)

---

## Install

```yaml
dependencies:
  liquid_glass_ui_kit: ^0.1.0
```

```dart
import 'package:liquid_glass_ui_kit/liquid_glass_ui_kit.dart';
```

## Quick start

Wrap your app (or a subtree) in a `GlassTheme`, then use the components:

```dart
import 'package:flutter/material.dart';
import 'package:liquid_glass_ui_kit/liquid_glass_ui_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return GlassTheme(
      data: GlassThemeData.dark(),
      child: GlassScaffold(
        appBar: const GlassAppBar(title: Text('Home')),
        bottomNavigationBar: GlassBottomNavBar(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          items: const [
            GlassNavItem(icon: Icons.home_rounded, label: 'Home'),
            GlassNavItem(icon: Icons.sports_esports_rounded, label: 'Arcade'),
            GlassNavItem(icon: Icons.group_rounded, label: 'Friends'),
            GlassNavItem(icon: Icons.inventory_2_rounded, label: 'Library'),
            GlassNavItem(icon: Icons.search_rounded, label: 'Search'),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 120, 16, 150),
          children: [
            GlassCard(child: Text('Frosted content')),
            const SizedBox(height: 16),
            GlassButton(
              label: 'Continue',
              variant: GlassButtonVariant.filled,
              expand: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Components at a glance

| Component | What it is | Key params |
|---|---|---|
| `GlassSurface` | The core blurred/tinted/rim-lit panel everything is built on | `blurSigma`, `tint`, `highlight`, `borderRadius`, `shadow` |
| `GlassScaffold` | Page shell that floats bars over a scrollable body | `appBar`, `bottomNavigationBar`, `background`, `body` |
| `GlassAppBar` | Translucent top bar (`PreferredSizeWidget`) | `title`, `leading`, `actions`, `floating` |
| `GlassBottomNavBar` | Floating capsule tab bar with animated indicator | `items`, `currentIndex`, `onTap`, `animateIndicator`, `animateBounce`, `showLabels`, `borderRadius` |
| `GlassButton` | Capsule button — glass / filled / plain | `label`, `icon`, `variant`, `expand`, `onPressed` |
| `GlassCard` | Padded glass panel, optionally tappable | `child`, `padding`, `onTap` |
| `GlassPill` | Small tag / chip / filter | `label`, `icon`, `selected`, `onTap` |
| `GlassSwitch` | iOS-style toggle with a glass track | `value`, `onChanged` |
| `GlassSheet` / `showGlassBottomSheet` | Bottom sheet | `title`, `builder`, `heightFactor`, `showDragHandle` |
| `GlassDialog` / `showGlassDialog` | Alert popup | `title`, `message`, `actions` |
| `GlassActionMenu` / `showGlassActionMenu` | Anchored context menu | `items` |

---

## The bottom nav bar & its animations

`GlassBottomNavBar` is the signature piece. Two animations, **each independently
toggleable**, and both auto-disabled under Reduce Motion:

| Flag | Default | Effect |
|---|---|---|
| `animateIndicator` | `true` | The highlight **slides ("bubbles")** between items. Off → it just appears on the selected item. |
| `animateBounce` | `true` | The selected **icon and pill pop** with a spring. Off → no pop. |

```dart
GlassBottomNavBar(
  currentIndex: _tab,
  onTap: (i) => setState(() => _tab = i),
  items: _items,

  // Animations — turn either off on its own:
  animateIndicator: true,   // sliding bubble
  animateBounce: true,      // springy pop (icon + pill)

  // Icons-only mode:
  showLabels: false,

  // Rounding — big values clamp to a full capsule:
  borderRadius: 40,             // the bar
  indicatorBorderRadius: 32,    // the pill (defaults to concentric with the bar)
)
```

You supply `currentIndex` and rebuild on `onTap` — it's a controlled widget, so
the selection is your state.

---

## Overlays: sheet, dialog & menu

All three need a `Navigator` / `MaterialApp` ancestor (as any modal route does).

```dart
// Bottom sheet
showGlassBottomSheet(
  context: context,
  title: 'Share',
  builder: (context) => Column(mainAxisSize: MainAxisSize.min, children: [...]),
);

// Popup dialog
showGlassDialog(
  context: context,
  title: 'Delete item?',
  message: 'This action cannot be undone.',
  actions: [
    GlassDialogAction(label: 'Cancel', isDefault: true, onPressed: () => Navigator.pop(context)),
    GlassDialogAction(label: 'Delete', isDestructive: true, onPressed: () => Navigator.pop(context)),
  ],
);

// Action menu — anchored to the widget owning `context`
showGlassActionMenu(
  context: context,
  items: [
    GlassMenuItem(label: 'Edit', icon: Icons.edit_outlined),
    GlassMenuItem(label: 'Delete', icon: Icons.delete_outline, isDestructive: true),
  ],
);
```

> For the action menu, pass the **trigger widget's own context** (wrap it in a
> `Builder`) so the menu anchors to it and flips above when there's no room below.

---

## Buttons

```dart
GlassButton(label: 'Glass',  variant: GlassButtonVariant.glass,  onPressed: () {}),
GlassButton(label: 'Filled', variant: GlassButtonVariant.filled, onPressed: () {}),
GlassButton(label: 'Plain',  variant: GlassButtonVariant.plain,  onPressed: () {}),

// With an icon, full width, disabled:
GlassButton(
  label: 'Continue',
  icon: Icons.arrow_forward_rounded,
  variant: GlassButtonVariant.filled,
  expand: true,
  onPressed: null, // null disables it
);
```

- `glass` — frosted capsule, accent-colored label
- `filled` — solid accent capsule; label auto-picks black/white for contrast
- `plain` — text-only, no fill

## The building block: `GlassSurface`

Compose your own frosted widgets with the same material:

```dart
GlassSurface(
  borderRadius: BorderRadius.circular(24),
  padding: const EdgeInsets.all(16),
  blurSigma: 30,           // override the theme blur
  tint: Colors.white24,    // override the tint
  child: const Text('Custom glass'),
)
```

---

## Theming

Grab the active theme anywhere with `GlassTheme.of(context)`:

```dart
final theme = GlassTheme.of(context);
theme.colors.accent;      // monochrome accent
theme.colors.label;       // primary text/icon color
theme.typography.title1;  // type scale
theme.metrics.blurSigma;  // shared blur strength
```

Customize globally by passing your own `GlassThemeData`:

```dart
GlassTheme(
  data: GlassThemeData.light(
    metrics: const GlassMetrics(blurSigma: 32, largeRadius: 32),
  ).copyWith(
    // Opt into a color accent if you want one:
    colors: GlassColors.light.copyWith(accent: const Color(0xFFAF52DE)),
  ),
  child: ...,
)
```

### Palettes

The default accent is **monochrome** (graphite in light, near-white in dark), so
out of the box it's pure glass + white with no color tint. `GlassColors` exposes:
`background`, `secondaryBackground`, `label`, `secondaryLabel`, `tertiaryLabel`,
`accent`, `glassTint`, `glassHighlight`, `glassBorder`, `glassShadow`, `separator`.

### Follow the system light/dark mode

```dart
GlassTheme(
  data: GlassThemeData(colors: GlassColors.of(context)),
  child: ...,
)
```

### Metrics

`GlassMetrics` centralizes `blurSigma`, `borderWidth` and the radii
(`smallRadius`, `mediumRadius`, `largeRadius`, `pillRadius`) so you can dial the
whole system up or down at once.

## Fonts

The package doesn't bundle SF Pro (Apple's license forbids redistribution). On
Apple platforms Flutter renders with the system font automatically, so it looks
native. To match it on Android/web, bundle your own font and apply it:

```dart
final typography = GlassTypography.forColors(GlassColors.dark)
    .apply(fontFamily: 'YourSFAlike');

GlassTheme(
  data: GlassThemeData(colors: GlassColors.dark, typography: typography),
  child: ...,
)
```

---

## Accessibility

Translucent UIs can fail WCAG contrast over busy backgrounds, so the kit honors
the system settings automatically:

- **Reduce Transparency / Increase Contrast** → glass surfaces drop the blur and
  render as opaque, clearly-bordered panels.
- **Reduce Motion** → the press, toggle, nav, dialog and menu animations are
  disabled.

The default palette is monochrome and high-contrast (black/white text). Still,
follow Apple's guidance: keep to roughly one glass layer per view, avoid stacking
glass on glass, and verify text contrast over your real backgrounds.

## The glass effect & performance

`GlassSurface` uses a real `BackdropFilter` blur, so it needs content *behind* it
to refract — float the bars over your body (as `GlassScaffold` does) rather than
stacking them in a plain `Column`. Backdrop blurs are GPU work; a handful per
screen is fine, but avoid dozens of overlapping ones in long lists.

## Example

The animation at the top of this page is captured from the full demo in
[`example/`](example/lib/main.dart). It includes every component in light and
dark mode, plus live toggles for the nav-bar animations and icons-only mode.

Run it locally:

```sh
cd example
flutter run
```

## License

MIT © 2026

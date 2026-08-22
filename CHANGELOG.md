## 0.1.0

Initial release.

- `GlassColors` light & dark palettes modelled on iOS 26.4 (monochrome accent —
  pure glass + white, no color tint by default).
- `GlassTypography` SF-Pro-style type scale.
- `GlassTheme` / `GlassThemeData` / `GlassMetrics` theming.
- Components: `GlassSurface`, `GlassButton`, `GlassBottomNavBar`, `GlassCard`,
  `GlassAppBar`, `GlassPill`, `GlassSwitch`, `GlassScaffold`.
- `GlassBottomNavBar`: sliding "bubble" indicator + springy icon/pill pop,
  each toggleable (`animateIndicator`, `animateBounce`); capsule rounding
  (`borderRadius`, `indicatorBorderRadius`); icons-only via `showLabels: false`.
- Overlays: `GlassSheet` / `showGlassBottomSheet`, `GlassDialog` /
  `showGlassDialog`, `GlassActionMenu` / `showGlassActionMenu` (anchored).
- Accessibility: honors **Reduce Transparency / Increase Contrast** (opaque,
  bordered fallback) and **Reduce Motion** (disables the animations).
- Example app demonstrating every component in light and dark mode.

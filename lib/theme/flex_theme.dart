import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/signals/themecolor_signal.dart';
import 'package:trdltool/signals/themefont_signal.dart';
import 'package:trdltool/signals/thememode_signal.dart';

// Signal to hold the AppTheme.
final Computed<ThemeData> cThemeData = Computed<ThemeData>(() {
  if (sThemeMode.value == ThemeMode.light) {
    return FlexThemeData.light(
      // Using FlexColorScheme built-in FlexScheme enum based colors
      scheme: sThemeColor.value,
      // Input color modifiers.
      swapLegacyOnMaterial3: true,
      // Surface color adjustments.
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 20,
      // Convenience direct styling properties.
      appBarStyle: FlexAppBarStyle.background,
      bottomAppBarElevation: 1,
      // Component theme configurations for light mode.
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnLevel: 20,
        blendOnColors: true,
        thinBorderWidth: 1.5,
        thickBorderWidth: 3.5,
        splashType: FlexSplashType.inkSparkle,
        defaultRadius: 24,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonOutlineSchemeColor: SchemeColor.primary,
        toggleButtonsBorderSchemeColor: SchemeColor.primary,
        segmentedButtonSchemeColor: SchemeColor.primary,
        segmentedButtonBorderSchemeColor: SchemeColor.primary,
        unselectedToggleIsColored: true,
        sliderThumbSchemeColor: SchemeColor.onPrimary,
        sliderValueTinted: true,
        sliderTrackHeight: 24,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorIsFilled: true,
        inputDecoratorIsDense: true,
        inputDecoratorBackgroundAlpha: 15,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 10,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        fabUseShape: true,
        chipBlendColors: true,
        chipRadius: 24,
        popupMenuRadius: 6,
        popupMenuElevation: 6,
        alignedDropdown: true,
        snackBarRadius: 24,
        appBarScrolledUnderElevation: 8,
        drawerWidth: 280,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuRadius: 6,
        menuElevation: 6,
        menuBarRadius: 0,
        menuBarElevation: 1,
        searchBarElevation: 1,
        searchViewElevation: 1,
        searchUseGlobalShape: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarElevation: 2,
        navigationBarHeight: 70,
        navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
        navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationRailUseIndicator: true,
        navigationRailIndicatorSchemeColor: SchemeColor.primary,
        navigationRailIndicatorOpacity: 1,
      ),
      // ColorScheme seed generation configuration for light mode.
      keyColors: const FlexKeyColors(
        useTertiary: true,
        keepPrimary: true,
        keepTertiary: true,
      ),
      tones: FlexSchemeVariant.chroma.tones(Brightness.light),
      // Direct ThemeData properties.
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      // Use the computed theme font family (cThemeFont) so ThemeData
      // responds to the computed canonical fontFamily string.
      fontFamily: cThemeFont.value,
    );
  } else {
    return FlexThemeData.dark(
      // Using FlexColorScheme built-in FlexScheme enum based colors.
      scheme: sThemeColor.value,
      // Input color modifiers.
      swapLegacyOnMaterial3: true,
      // Surface color adjustments.
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 30,
      // Convenience direct styling properties.
      appBarStyle: FlexAppBarStyle.background,
      bottomAppBarElevation: 2,
      // Component theme configurations for dark mode.
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnLevel: 40,
        blendOnColors: true,
        splashType: FlexSplashType.inkSparkle,
        defaultRadius: 24,
        thinBorderWidth: 1.5,
        thickBorderWidth: 3.5,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonOutlineSchemeColor: SchemeColor.primary,
        toggleButtonsBorderSchemeColor: SchemeColor.primary,
        segmentedButtonSchemeColor: SchemeColor.primary,
        segmentedButtonBorderSchemeColor: SchemeColor.primary,
        unselectedToggleIsColored: true,
        sliderThumbSchemeColor: SchemeColor.onPrimary,
        sliderValueTinted: true,
        sliderTrackHeight: 24,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorIsFilled: true,
        inputDecoratorIsDense: true,
        inputDecoratorBackgroundAlpha: 22,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 10,
        fabUseShape: true,
        chipBlendColors: true,
        chipRadius: 24,
        popupMenuRadius: 6,
        popupMenuElevation: 6,
        alignedDropdown: true,
        snackBarRadius: 24,
        drawerWidth: 280,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuRadius: 6,
        menuElevation: 6,
        menuBarRadius: 0,
        menuBarElevation: 1,
        searchBarElevation: 1,
        searchViewElevation: 1,
        searchUseGlobalShape: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarElevation: 2,
        navigationBarHeight: 70,
        navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
        navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationRailUseIndicator: true,
        navigationRailIndicatorSchemeColor: SchemeColor.primary,
        navigationRailIndicatorOpacity: 1,
      ),
      // ColorScheme seed configuration setup for dark mode.
      keyColors: const FlexKeyColors(useTertiary: true, keepPrimary: true),
      tones: FlexSchemeVariant.chroma.tones(Brightness.dark),
      // Direct ThemeData properties.
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      fontFamily: cThemeFont.value,
    );
  }
});

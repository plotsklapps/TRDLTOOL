import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/signals/themefont_signal.dart';
import 'package:trdltool/theme/flex_theme.dart';

class ThemeFontCarousel extends SignalWidget {
  const ThemeFontCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> fontNames = sThemeFontList.value;
    final String selectedFont = sThemeFont.value;

    return SizedBox(
      height: 140,
      child: CarouselView(
        itemExtent: 100,
        shrinkExtent: 100,
        onTap: (int index) {
          // Update the sThemeFont Signal.
          sThemeFont.value = fontNames[index];
        },
        children: <Widget>[
          for (final String fontKey in fontNames)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: cThemeData.value.colorScheme.surfaceDim,
                border: Border.all(
                  color: fontKey == selectedFont
                      ? cThemeData.value.colorScheme.primary
                      : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Builder(
                        builder: (BuildContext context) {
                          final Color color =
                              cThemeData.value.colorScheme.onSurface;
                          TextStyle previewStyle;
                          switch (fontKey) {
                            case 'openSans':
                              previewStyle = GoogleFonts.openSans(
                                fontSize: 32,
                                color: color,
                              );
                            case 'roboto':
                              previewStyle = GoogleFonts.roboto(
                                fontSize: 32,
                                color: color,
                              );
                            case 'lato':
                              previewStyle = GoogleFonts.lato(
                                fontSize: 32,
                                color: color,
                              );
                            case 'montserrat':
                              previewStyle = GoogleFonts.montserrat(
                                fontSize: 32,
                                color: color,
                              );
                            case 'poppins':
                              previewStyle = GoogleFonts.poppins(
                                fontSize: 32,
                                color: color,
                              );
                            case 'raleway':
                              previewStyle = GoogleFonts.raleway(
                                fontSize: 32,
                                color: color,
                              );
                            case 'merriweather':
                              previewStyle = GoogleFonts.merriweather(
                                fontSize: 32,
                                color: color,
                              );
                            case 'nunito':
                              previewStyle = GoogleFonts.nunito(
                                fontSize: 32,
                                color: color,
                              );
                            case 'oswald':
                              previewStyle = GoogleFonts.oswald(
                                fontSize: 32,
                                color: color,
                              );
                            case 'playfairDisplay':
                              previewStyle = GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                color: color,
                              );
                            case 'robotoSlab':
                              previewStyle = GoogleFonts.robotoSlab(
                                fontSize: 32,
                                color: color,
                              );
                            case 'bebasNeue':
                              previewStyle = GoogleFonts.bebasNeue(
                                fontSize: 32,
                                color: color,
                              );
                            case 'teko':
                              previewStyle = GoogleFonts.teko(
                                fontSize: 32,
                                color: color,
                              );
                            case 'dancingScript':
                              previewStyle = GoogleFonts.dancingScript(
                                fontSize: 32,
                                color: color,
                              );
                            case 'quicksand':
                              previewStyle = GoogleFonts.quicksand(
                                fontSize: 32,
                                color: color,
                              );
                            case 'rubik':
                              previewStyle = GoogleFonts.rubik(
                                fontSize: 32,
                                color: color,
                              );
                            case 'firaSans':
                              previewStyle = GoogleFonts.firaSans(
                                fontSize: 32,
                                color: color,
                              );
                            case 'karla':
                              previewStyle = GoogleFonts.karla(
                                fontSize: 32,
                                color: color,
                              );
                            case 'inconsolata':
                              previewStyle = GoogleFonts.inconsolata(
                                fontSize: 32,
                                color: color,
                              );
                            case 'cinzel':
                              previewStyle = GoogleFonts.cinzel(
                                fontSize: 32,
                                color: color,
                              );
                            case 'comfortaa':
                              previewStyle = GoogleFonts.comfortaa(
                                fontSize: 32,
                                color: color,
                              );
                            case 'orbitron':
                              previewStyle = GoogleFonts.orbitron(
                                fontSize: 32,
                                color: color,
                              );
                            case 'ptSerif':
                              previewStyle = GoogleFonts.ptSerif(
                                fontSize: 32,
                                color: color,
                              );
                            case 'ubuntu':
                              previewStyle = GoogleFonts.ubuntu(
                                fontSize: 32,
                                color: color,
                              );
                            case 'heebo':
                              previewStyle = GoogleFonts.heebo(
                                fontSize: 32,
                                color: color,
                              );
                            case 'hind':
                              previewStyle = GoogleFonts.hind(
                                fontSize: 32,
                                color: color,
                              );
                            case 'josefinSans':
                              previewStyle = GoogleFonts.josefinSans(
                                fontSize: 32,
                                color: color,
                              );
                            case 'zillaSlab':
                              previewStyle = GoogleFonts.zillaSlab(
                                fontSize: 32,
                                color: color,
                              );
                            case 'spectral':
                              previewStyle = GoogleFonts.spectral(
                                fontSize: 32,
                                color: color,
                              );
                            case 'kanit':
                              previewStyle = GoogleFonts.kanit(
                                fontSize: 32,
                                color: color,
                              );
                            case 'assistant':
                              previewStyle = GoogleFonts.assistant(
                                fontSize: 32,
                                color: color,
                              );
                            case 'blackOpsOne':
                              previewStyle = GoogleFonts.blackOpsOne(
                                fontSize: 32,
                                color: color,
                              );
                            case 'baloo2':
                              previewStyle = GoogleFonts.baloo2(
                                fontSize: 32,
                                color: color,
                              );
                            case 'cormorantGaramond':
                              previewStyle = GoogleFonts.cormorantGaramond(
                                fontSize: 32,
                                color: color,
                              );
                            default:
                              previewStyle = GoogleFonts.openSans(
                                fontSize: 32,
                                color: color,
                              );
                          }
                          return Text('Abc', style: previewStyle);
                        },
                      ),
                    ),
                  ),
                  Text(
                    fontKey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: fontKey == selectedFont
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: cThemeData.value.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';

// List of available font keys (GoogleFonts method names as strings)
final Signal<List<String>> sThemeFontList = Signal<List<String>>(
  <String>[
    'openSans',
    'roboto',
    'lato',
    'montserrat',
    'poppins',
    'raleway',
    'merriweather',
    'nunito',
    'oswald',
    'playfairDisplay',
    'robotoSlab',
    'bebasNeue',
    'teko',
    'dancingScript',
    'quicksand',
    'rubik',
    'firaSans',
    'karla',
    'inconsolata',
    'cinzel',
    'comfortaa',
    'orbitron',
    'ptSerif',
    'ubuntu',
    'heebo',
    'hind',
    'josefinSans',
    'zillaSlab',
    'spectral',
    'kanit',
    'assistant',
    'blackOpsOne',
    'baloo2',
    'cormorantGaramond',
  ],
  options: const SignalOptions<List<String>>(name: 'sThemeColor'),
);

// The currently selected font key (e.g. 'teko')
final Signal<String> sThemeFont = Signal<String>(
  sThemeFontList.value.first,
  options: const SignalOptions<String>(name: 'sThemeFont'),
);

// Computed signal that returns the GoogleFonts.<font>().fontFamily! string
final Computed<String> cThemeFont = Computed<String>(
  () {
    final String fontKey = sThemeFont.value;
    // Use a switch or map to call the correct GoogleFonts method
    switch (fontKey) {
      case 'openSans':
        return GoogleFonts.openSans().fontFamily!;
      case 'roboto':
        return GoogleFonts.roboto().fontFamily!;
      case 'lato':
        return GoogleFonts.lato().fontFamily!;
      case 'montserrat':
        return GoogleFonts.montserrat().fontFamily!;
      case 'poppins':
        return GoogleFonts.poppins().fontFamily!;
      case 'raleway':
        return GoogleFonts.raleway().fontFamily!;
      case 'merriweather':
        return GoogleFonts.merriweather().fontFamily!;
      case 'nunito':
        return GoogleFonts.nunito().fontFamily!;
      case 'oswald':
        return GoogleFonts.oswald().fontFamily!;
      case 'playfairDisplay':
        return GoogleFonts.playfairDisplay().fontFamily!;
      case 'robotoSlab':
        return GoogleFonts.robotoSlab().fontFamily!;
      case 'bebasNeue':
        return GoogleFonts.bebasNeue().fontFamily!;
      case 'teko':
        return GoogleFonts.teko().fontFamily!;
      case 'dancingScript':
        return GoogleFonts.dancingScript().fontFamily!;
      case 'quicksand':
        return GoogleFonts.quicksand().fontFamily!;
      case 'rubik':
        return GoogleFonts.rubik().fontFamily!;
      case 'firaSans':
        return GoogleFonts.firaSans().fontFamily!;
      case 'karla':
        return GoogleFonts.karla().fontFamily!;
      case 'inconsolata':
        return GoogleFonts.inconsolata().fontFamily!;
      case 'cinzel':
        return GoogleFonts.cinzel().fontFamily!;
      case 'comfortaa':
        return GoogleFonts.comfortaa().fontFamily!;
      case 'orbitron':
        return GoogleFonts.orbitron().fontFamily!;
      case 'ptSerif':
        return GoogleFonts.ptSerif().fontFamily!;
      case 'ubuntu':
        return GoogleFonts.ubuntu().fontFamily!;
      case 'heebo':
        return GoogleFonts.heebo().fontFamily!;
      case 'hind':
        return GoogleFonts.hind().fontFamily!;
      case 'josefinSans':
        return GoogleFonts.josefinSans().fontFamily!;
      case 'zillaSlab':
        return GoogleFonts.zillaSlab().fontFamily!;
      case 'spectral':
        return GoogleFonts.spectral().fontFamily!;
      case 'kanit':
        return GoogleFonts.kanit().fontFamily!;
      case 'assistant':
        return GoogleFonts.assistant().fontFamily!;
      case 'blackOpsOne':
        return GoogleFonts.blackOpsOne().fontFamily!;
      case 'baloo2':
        return GoogleFonts.baloo2().fontFamily!;
      case 'cormorantGaramond':
        return GoogleFonts.cormorantGaramond().fontFamily!;
      default:
        return GoogleFonts.openSans().fontFamily!;
    }
  },
  options: const ComputedOptions<String>(name: 'cThemeFont'),
);

import 'dart:ui';

import 'package:material_ui/material_ui.dart';

class CustomScrollConfiguration extends StatelessWidget {
  const CustomScrollConfiguration({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
      child: child,
    );
  }
}

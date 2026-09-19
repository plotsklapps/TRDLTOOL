import 'package:material_ui/material_ui.dart';

Future<void> showModal({required BuildContext context, required Widget child}) {
  return showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return child;
    },
  );
}

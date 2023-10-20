import 'package:flutter/widgets.dart';

extension ContextExt on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();

  void focus(FocusNode? node) => FocusScope.of(this).requestFocus(node);
}

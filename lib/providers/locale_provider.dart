import 'package:flutter/cupertino.dart';

import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale("en");

  Locale getLocale() {
    return _locale;
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) {
      return;
    }
    _locale = locale;

    notifyListeners();
  }
}

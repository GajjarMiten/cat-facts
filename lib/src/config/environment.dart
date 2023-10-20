import 'package:flutter/foundation.dart';

// ! development base url
const _kBaseUrlDev = "https://catfact.ninja/";

// ! local base url
const _kBaseUrlLocal = "https://catfact.ninja/";

// ! prod base url
const _kBaseUrlProd = "https://catfact.ninja/";

enum _Environment { dev, prod, local }

const kAppEnvMode = _Environment.dev;
const bool kDevMode = kAppEnvMode == _Environment.dev;

// appUrls according to the enviroment
final appUrl = AppUrl.init();

class AppUrl {
  final String catService;

  const AppUrl._({
    required this.catService,
  });

  factory AppUrl.init() {
    return switch (kAppEnvMode) {
      _Environment.prod when kReleaseMode => AppUrl.prod(),
      _Environment.dev => AppUrl.dev(),
      _Environment.local => AppUrl.local(),
      _ => AppUrl.dev(),
    };
  }

  factory AppUrl.dev() {
    return const AppUrl._(catService: _kBaseUrlDev);
  }
  factory AppUrl.local() {
    return const AppUrl._(catService: _kBaseUrlLocal);
  }
  factory AppUrl.prod() {
    return const AppUrl._(catService: _kBaseUrlProd);
  }
}

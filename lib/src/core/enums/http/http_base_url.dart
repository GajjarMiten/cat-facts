import 'package:catfact/src/config/environment.dart';

enum BaseUrl {
  catService,
  noBaseUrl;

  String get url => _getBaseUrl(this);
}

String _getBaseUrl(BaseUrl base) {
  return switch (base) {
    BaseUrl.catService => appUrl.catService,
    BaseUrl.noBaseUrl => '',
  };
}

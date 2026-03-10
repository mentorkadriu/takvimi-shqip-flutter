// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

bool canInstall() {
  try {
    return js.context['pwaCanInstall'] == true;
  } catch (_) {
    return false;
  }
}

bool triggerInstall() {
  try {
    final result = js.context.callMethod('triggerPwaInstall', []);
    return result == true;
  } catch (_) {
    return false;
  }
}

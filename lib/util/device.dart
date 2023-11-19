import 'dart:io';

class Device {
  static bool isDesktop() {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }
}

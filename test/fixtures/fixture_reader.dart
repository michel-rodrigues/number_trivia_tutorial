import 'dart:io';

String fixture(String name) {
  File file = File('${Directory.current.path}/fixtures/$name');
  return file.readAsStringSync();
}

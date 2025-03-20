import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureHelper {
  FlutterSecureHelper._internal();

  static final FlutterSecureHelper _instance = FlutterSecureHelper._internal();
  static FlutterSecureHelper get instance => _instance;

  factory FlutterSecureHelper() => _instance;

  late FlutterSecureStorage _flutterSecureStorage;
  Future<void> init() async {
    _flutterSecureStorage = const FlutterSecureStorage();
  }

  //! Set
  Future<dynamic> setObject(String key, String value) async {
    return await _flutterSecureStorage.write(key: key, value: value);
  }

  //! Get
  Future<dynamic> getObject(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  //! Remove
  Future<dynamic> removeObject(String key) async {
    return await _flutterSecureStorage.delete(key: key);
  }

  //! Remove All
  Future<dynamic> removeAllObject() async {
    return await _flutterSecureStorage.deleteAll();
  }
}

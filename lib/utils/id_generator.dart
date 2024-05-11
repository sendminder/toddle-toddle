import 'package:hive/hive.dart';

class IdGenerator {
  IdGenerator() {
    init();
  }
  void init() async {
    _idBox = await Hive.openBox('id');
  }

  late Box<int> _idBox;

  Future<int> generateUniqueId() async {
    final id = _idBox.get('id', defaultValue: 1000) as int;
    await _idBox.put('id', id + 1000);
    return id;
  }
}

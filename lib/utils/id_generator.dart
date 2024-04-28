import 'package:uuid/uuid.dart';

String generateUniqueId() {
  var uuid = const Uuid();
  // 현재 시간을 밀리초 단위로 가져옵니다.
  var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  // timestamp를 기반으로 UUID를 생성합니다.
  var timeBasedUuid = uuid.v5(Uuid.NAMESPACE_URL, timestamp);
  return timeBasedUuid;
}

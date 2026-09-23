import 'dart:js_interop';

@JS('window.playSkeuoSound')
external void _playSkeuoSound(JSString type);

void playWebSound(String type) {
  try {
    _playSkeuoSound(type.toJS);
  } catch (_) {}
}

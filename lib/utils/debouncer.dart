// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

class Debouncer {
  final int miliseconds;
  Timer? _timer;
  Debouncer({
    required this.miliseconds,
  });
  
  run(VoidCallback action){
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1000), action);
  }
}

import 'package:fpdart/fpdart.dart';

extension NonNullMap<K, V> on Map<K, V> {
  Map<K, V> toNonNull() {
    return filter((value) {
      return value != null;
    });
  }
}

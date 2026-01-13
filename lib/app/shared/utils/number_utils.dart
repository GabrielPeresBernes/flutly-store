import 'dart:math';

class NumberUtils {
  static int getRandomInt(int nDigits) {
    final random = Random();
    final min = pow(10, nDigits - 1).toInt();
    final max = pow(10, nDigits).toInt() - 1;
    return min + random.nextInt(max - min + 1);
  }
}

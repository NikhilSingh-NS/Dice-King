import 'dart:math';

import 'package:dice_app/service/dice_service.dart';

class Dice implements DiceService {
  @override
  int rollDice() {
    return 1 + Random().nextInt(6);
  }
}

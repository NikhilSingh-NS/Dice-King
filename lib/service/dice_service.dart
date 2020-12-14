import 'package:dice_app/service/dice.dart';

abstract class DiceService {
    factory DiceService(){
        return Dice();
    }

    int rollDice();
}
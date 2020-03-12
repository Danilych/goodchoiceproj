import "dart:math" show pow;


String fibonacci(String sn) {
   int n = 0;
   if (sn.isEmpty) {return "";}
   try {
      n = int.parse(sn);
   } on FormatException {
      return "Чушь какая-то";
   }
   if (n.abs() > 93) {return "Давай поменьше, окей?";}
   double gold = (1 + pow(5, 0.5)) / 2;
   return ((pow(gold, n) - pow(-gold, -n) ) / (2 * gold - 1)).round().toString();
}

class AppData {

}
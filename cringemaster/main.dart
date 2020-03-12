import "package:flutter/material.dart";
import "components.dart" show Main;

void main() {
   Map authData = auth();
   runApp(Main(authData: authData));
}

Map auth() {
   Map data = new Map<String, String>();
   return data;
}

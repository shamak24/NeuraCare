import 'package:hive_flutter/hive_flutter.dart';
import 'package:neura_care/models/user.dart';




Future <void> setupHive() async {
  await Hive.initFlutter();
  // Register adapters here
  Hive.registerAdapter(UserAdapter());
}
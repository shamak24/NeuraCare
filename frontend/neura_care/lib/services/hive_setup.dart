import 'package:hive_flutter/hive_flutter.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/models/meals.dart';
import 'package:neura_care/models/prev_history.dart';
import 'package:neura_care/models/user.dart';
import 'package:neura_care/models/vitals.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DietAdapter());
  Hive.registerAdapter(PreviousHistoryAdapter());
  Hive.registerAdapter(VitalsAdapter());
  Hive.registerAdapter(MealsAdapter());
  await Hive.openBox<User>('userBox');
  await Hive.openBox<Diet>('dietBox');
  await Hive.openBox<PreviousHistory>('prevHistoryBox');
  await Hive.openBox<Vitals>('vitalsBox');
}

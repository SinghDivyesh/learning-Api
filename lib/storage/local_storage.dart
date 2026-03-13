import 'package:hive/hive.dart';
//import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:rest_api/models/user_model.dart';

class LocalStorage{
  static const String _boxName  = "favorites";
  static Future<void> saveUser(UserModel user)async{
    final box = Hive.box(_boxName);
    await box.put(user.id .toString(),user.toMap());
  }
  static Future<void>removeUser(int id)async{
    final box= Hive.box(_boxName);
    await box.delete(id.toString());
  }
  static bool isFavorite(int id){
    final box = Hive.box(_boxName);
    return box.containsKey(id.toString());
  }
  static List<UserModel>getFavorites(){
    final box= Hive.box(_boxName);
    return box.values.map((item)=>UserModel.fromMap(item,item)).toList();
  }
}

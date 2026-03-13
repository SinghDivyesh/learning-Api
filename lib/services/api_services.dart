import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rest_api/models/user_model.dart';


class ApiServices {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
   static Future<List<UserModel>>fetchUsers() async{
     try{
       final response = await http.get(Uri.parse("$baseUrl/users"));
       if (response.statusCode==200){
         List jsonList = jsonDecode(response.body);
         List <UserModel>users = jsonList.map((json)=>UserModel.fromJson(json)).toList();
         return users;
       }
       else {
         throw Exception("Failed to load user: ${response.statusCode}");

       }

     }
     catch(e){
       throw Exception("Exception:$e");
     }
   }
}
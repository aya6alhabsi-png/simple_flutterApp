import 'package:firebase_database/firebase_database.dart';

class DatabaseServer {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> addFlower(Map<String, dynamic>flowerData) async {
    await _db.child('flowers').push().set(flowerData);
  }
  Stream<List<Map<String,dynamic>>> getFlower(){
    return _db.child('flowers').onValue.map((event){
      Map<dynamic,dynamic> flowerData = event.snapshot.value as Map<dynamic,dynamic> ?? {};
      List<Map<String,dynamic>> flowerList = [];
      flowerData.forEach((key,value){
        Map<String,dynamic> flower = Map<String,dynamic>.from(value as Map);
        flower['id'] = key;
        flowerList.add(flower);
      });
      return flowerList;
    });
  }
  Future<void> updateFlower(String id,Map<String,dynamic> flowerData)async{
    await _db.child('flowers').child(id).update(flowerData);
  }
  Future<void> deleteFlower(String id) async{
    await _db.child('flowers').child(id).remove();
  }
}

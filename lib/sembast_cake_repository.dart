import 'dart:math';
//import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:sembast_websample/model/cake.dart';
import 'package:sembast_websample/cake_repository.dart';
import 'Webdatabase.dart';

//import 'package:test/test.dart';

class SembastCakeRepository extends CakeRepository {
  //final Database _database = GetIt.I.get();
  final WebDatabase _database = WebDatabase();
  final StoreRef _store = intMapStoreFactory.store("cake_store2");

  @override
  Future<int> insertCake(Cakes cakes) async {
    return await _store.add(_database, cakes.toMap());
  }

  @override
  Future updateCake(Cakes cakes) async {
    await _store.record(cakes.id).update(_database, cakes.toMap());
  }

  @override
  Future deleteCake(int cakeId) async {
    await _store.record(cakeId).delete(_database);
  }

  @override
  Future<List<Cakes>> getAllCakes() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => Cakes.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }

  Future<List<Cakes>> sort() async {
    List<Cakes> idmap = [];

    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('yummyness')]);
    var record = await _store.find(_database, finder: finder);

    for (int i = 0; i < record.length; ++i) {
      var map = cloneMap(record[i].value);
      var key = record[i].key;
      Cakes sortcake = Cakes.fromMap(key, map);
      idmap.add(sortcake);
    }

    return idmap;
  }

  Future<List<Cakes>> search(String firstkey) async {
    List<Cakes> idmap = [];
    // Read by key
    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('yummyness')]);

    var finder1 = Finder(sortOrders: [SortOrder(Field.value, false)]);
    var record = await _store.find(_database, finder: finder);

    for (int i = 0; i < record.length; ++i) {
      var map = cloneMap(record[i].value);
      var key = record[i].key;
      Cakes sortcake = Cakes.fromMap(key, map);
      idmap.add(sortcake);
    }
    return idmap;
  }
}

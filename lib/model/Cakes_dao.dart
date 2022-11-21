import 'package:sembast/sembast.dart';
//import 'package:sembast_websample/db/data_base.txt';
import 'package:sembast_websample/model/cake.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast.dart';

class CakesDao {
  //static const String folderName = "Cakes";
  final _cakesFolder = intMapStoreFactory.store();
  var factory = databaseFactoryWeb;

  //final Database _database = GetIt.I.get();
  //final WebDatabase _database = WebDatabase();
  //final StoreRef _store = intMapStoreFactory.store("cake_store2");

  //static const String folderName = "Books";
  //final _store = intMapStoreFactory.store("cake_store2");

  Future<Database> get _db async => await factory
      .openDatabase('test1'); //await WebDatabase.instance.database;

  Future initCakes() async {
    // Declare our store (records are mapd, ids are ints)
    //var store = intMapStoreFactory.store();
    //var factory = databaseFactoryWeb;

    // Open the database
    //var db = await factory.openDatabase('test');

    // Add a new record
    var key = await _cakesFolder
        .add(await _db, <String, Object?>{'name': 'Table', 'price': '15'});

    // Read the record
    var value = await _cakesFolder.record(key).get(await _db);

    //void main() => runApp(MyApp());

    // Print the value
    print(value);
    // Close the database
    //await db.close();*/
  }

  //Future<Database> get _db async =>
  //    await factory.openDatabase('test'); //await AppDatabase.instance.database;

  Future insertCakes(Cakes cakes) async {
    await _cakesFolder.add(await _db, cakes.toMap());
  }

  Future updateCakes(Cakes cakes) async {
    final finder = Finder(filter: Filter.byKey(cakes.name));
    await _cakesFolder.update(await _db, cakes.toMap(), finder: finder);
  }

  Future delete(Cakes cakes) async {
    final finder = Finder(filter: Filter.byKey(cakes.name));
    await _cakesFolder.delete(await _db, finder: finder);
  }

  Future<List<Cakes>> getAllCakes() async {
    final recordSnapshot = await _cakesFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      final cakes = Cakes.fromMap(snapshot.key, snapshot.value);
      return cakes;
    }).toList();
  }

  Future sortCake() async {
    // Look for any animal "greater than" (alphabetically) 'cat'
    // ordered by name
    var finder = Finder(
        //filter: Filter.greaterThan('name', 'cat'),
        sortOrders: [SortOrder('name')]);
    var records = await _cakesFolder.find(await _db, finder: finder);

    print(finder);
    //Finder(filter: Filter.greaterThan('name', 'cat'), sortOrders: [SortOrder('name')]);
  }

  Future<List<Cakes>> search(String firstkey) async {
    List<Cakes> idmap = [];
    // Read by key
    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('yummyness')]);

    var finder1 = Finder(sortOrders: [SortOrder(Field.value, false)]);
    var record = await _cakesFolder.find(await _db, finder: finder);

    for (int i = 0; i < record.length; ++i) {
      var map = cloneMap(record[i].value);
      var key = record[i].key;
      Cakes sortcake = Cakes.fromMap(key, map);
      idmap.add(sortcake);
    }
    return idmap;
  }
}


/*
int lampKey;
int chairKey;

// Import the data
var map = jsonDecode(saved) as Map;
var importedDb = await importDatabase(map, databaseFactory, 'imported.db');

// Check the lamp price
expect((await store.record(lampKey).get(importedDb))['price'], 12);
*/
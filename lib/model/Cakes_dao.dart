//import 'package:sembast_websample/db/data_base.txt';
import 'package:sembast_websample/mainORG.dart';
import 'package:sembast_websample/model/cake.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

class CakesDao {
  // DBのインスタンスはDatabaseで定義します
  //Database db;

  // Pathの取得およびDBを開く処理は非同期のため初期化処理をasyncで囲みます。
  // Pathはsqflite の getDatbasePath()でも取得することができます。
  void init() async {
    // get the application documents directory
    var dir = await getApplicationDocumentsDirectory();
    // make sure it exists
    await dir.create(recursive: true);
    // build the database path
    var dbPath = join(dir.path, 'my_database.db');
    // open the database
    var db = await databaseFactoryIo.openDatabase(dbPath);



    


  //static const String folderName = "Cakes";
  final store = intMapStoreFactory.store();
  var factory = /*databaseFactoryWeb;*/ databaseFactoryMemoryFs;
  //var _db; // open the database
  //final Database _database = GetIt.I.get();
  //final WebDatabase _database = WebDatabase();
  //final StoreRef _store = intMapStoreFactory.store("cake_store2");

  //static const String folderName = "Books";
  //final _store = intMapStoreFactory.store("cake_store2");

  //Future<Database> get _db async => await factory
  //    .openDatabase('test1'); //await WebDatabase.instance.database;
  Future<Database> get _db async =>
      await databaseFactoryMemoryFs.openDatabase('test1');
  //var store = intMapStoreFactory.store('my_store');

  Future initCakes() async {
    //////////////////////////////
    // Declare our store (records are mapd, ids are ints)
    //var store = intMapStoreFactory.store();
    //var factory = databaseFactoryWeb;

    // Open the database
    //var db = await factory.openDatabase('test');

    // Add a new record
    var key = await store
        .add(await _db, <String, Object?>{'name': 'Table', 'price': '15'});

    var value = await store.record(key).get(await _db);

    key = await store
        .add(await _db, <String, Object?>{'name': 'Table', 'price': '20'});

    // Read the record
    var value2 = await store.record(key).get(await _db);

    //void main() => runApp(MyApp());

    // Print the value
    print(value);
    print(value2);
    // Close the database
    //await db.close();*/
  }

  //Future<Database> get _db async =>
  //    await factory.openDatabase('test'); //await AppDatabase.instance.database;

  Future insertCakes(Cakes cakes) async {
    await store.add(await _db, cakes.toMap());
  }

  Future updateCakes(Cakes cakes) async {
    final finder = Finder(filter: Filter.byKey(cakes.name));
    await store.update(await _db, cakes.toMap(), finder: finder);
  }

  Future delete(Cakes cakes) async {
    final finder = Finder(filter: Filter.byKey(cakes.name));
    await store.delete(await _db, finder: finder);
  }

  Future<List<Cakes>> getAllCakes() async {
    List<Cakes> idmap = [];
    // Read by key
    var finder = Finder(
        //filter: Filter.greaterThan('name', 'cat'),
        sortOrders: [SortOrder('name')]);
    var record = await store.find(await _db, finder: finder);
    print(record);
    return idmap;
  }

  Future sortCake() async {
    // Look for any animal "greater than" (alphabetically) 'cat'
    // ordered by name
    var finder = Finder(
        //filter: Filter.greaterThan('name', 'cat'),
        sortOrders: [SortOrder('name')]);
    var records = await store.find(await _db, finder: finder);

    print(finder);
    //print((record.length).toString());
    //Finder(filter: Filter.greaterThan('name', 'cat'), sortOrders: [SortOrder('name')]);
  }

  Future<List<Cakes>> search(String firstkey) async {
    List<Cakes> idmap = [];
    // Read by key
    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('yummyness')]);

    var finder1 = Finder(sortOrders: [SortOrder(Field.value, false)]);
    var record = await store.find(await _db, finder: finder);

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
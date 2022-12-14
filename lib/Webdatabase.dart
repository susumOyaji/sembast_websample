import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';

class WebDatabase {
  // Singleton instance
  static final WebDatabase _singleton = WebDatabase._();

  // Singleton accessor
  static WebDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  WebDatabase._();
  //AppDatabase(this name);

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    // Declare our store (records are mapd, ids are ints)
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryWeb;

    // Open the database
    var db = await factory.openDatabase('test');

    // Add a new record
    var key =
        await store.add(db, <String, Object?>{'name': 'Table', 'price': 15});

    // Read the record
    var value = await store.record(key).get(db);

    // Print the value
    print(value);
    // Close the database
    await db.close();
  }
}

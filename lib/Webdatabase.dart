import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';




class WebDatabase{
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
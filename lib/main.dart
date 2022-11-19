import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'home_page.dart';
import 'init.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';



/*
Future main() async {
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
*/


Future main() async {
   WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  var packageName = 'com.tekartik.demosembast';

  var databaseFactory = getDatabaseFactory(packageName: packageName);

  var bloc = MyAppBloc(databaseFactory);
  runApp(MyApp(
    bloc: bloc,
  ));
}

var valueKey = 'value';
var store = StoreRef<String, int>.main();
var record = store.record(valueKey);



//) => runApp(const CakeApp());

class MyAppBloc {
  final DatabaseFactory databaseFactory;
  MyAppBloc(this.databaseFactory) {
    database = () async {
      var db = await databaseFactory.openDatabase('counter.db');
      return db;
    }();
    // Load counter on start
    () async {
      var db = await database!;
      _streamSubscription = record.onSnapshot(db).listen((snapshot) {
        _counterController.add(snapshot?.value ?? 0);
      });
    }();
  }

  late StreamSubscription _streamSubscription;

  Future<Database>? database;

  final _counterController = StreamController<int>.broadcast();

  Stream<int> get counter => _counterController.stream;

  Future increment() async {
    var db = await database!;
    await db.transaction((txn) async {
      var value = await record.get(txn) ?? 0;
      await record.put(txn, ++value);
    });
  }

  void dispose() {
    _streamSubscription.cancel();
  }
}



class MyApp extends StatelessWidget {
  final MyAppBloc bloc;

  const MyApp({Key? key, required this.bloc}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sembast Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or simply save your changes to 'hot reload' in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        //title: 'Sembast Demo',
        //bloc: bloc,
      ),
    );
  }
}


class CakeApp extends StatefulWidget {
  const CakeApp({super.key});
  @override
  _CakeAppState createState() => _CakeAppState();
}

class _CakeAppState extends State<CakeApp> {
  final Future _init =  Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Favorite Cakes',
       theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or simply save your changes to 'hot reload' in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      
      /*
      FutureBuilder(
        future: _init,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return HomePage();
          } else {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      */
    );
  }
}


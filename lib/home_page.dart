import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_websample/Webdatabase.dart';
import 'package:sembast_websample/model/Cakes_dao.dart';
import 'package:sembast_websample/model/cake.dart';
import 'package:sembast_websample/cake_repository.dart';
//import 'sembast_cake_repository.txt';
import 'Webdatabase.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final CakeRepository _cakeRepository = GetIt.I.get();
  List<Cakes> _cakes = [];
  int Anything = 0; //dumy
  var controller = TextEditingController();
  bool isCaseSensitive = false;
  String firstkey = '';
  String secondkey = '';
  final focusNode = FocusNode();
  CakesDao web = CakesDao();

  @override
  void initState() {
    super.initState();
    _initCakes();
    //_loadCakes();
    //_sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //キーボードによって画面サイズを変更させないため
      //appBar: AppBar(
      //  title: const Text("My Favorite Cakes"),
      //),
      body: Container(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //12crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FirstString:$firstkey  \nSecondString:$secondkey'),
                  ],
                )),
            Focus(
              child: TextFormField(
                //focusNode: focusNode,
                autofocus: true,
                textInputAction: TextInputAction.search,
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'hintText',
                  /*
                enabledBorder: OutlineInputBorder(
                    //何もしていない時の挙動、見た目
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.greenAccent,
                    )),
                */
                  border: OutlineInputBorder(
                    //フォーカスされた時の挙動、見た目
                    borderRadius: BorderRadius.circular(15),
                    //borderSide: const BorderSide(
                    //  color: Colors.amber,
                    //)
                  ),
                ),
                onChanged: (String val) {
                  //ユーザーがデバイス上でTextFieldの値を変更した場合のみ発動される.
                },
                onFieldSubmitted: (String val) {
                  print(val);
                  String location = val.substring(0, 1);
                  if (firstkey.isEmpty) {
                    setState(() => firstkey = val);
                    controller.clear(); //リセット処理
                    focusNode.requestFocus;
                    if (location == 'p') {
                      _search(firstkey, "");
                    }
                    return;
                  }
                  if (firstkey.isNotEmpty && secondkey.isEmpty) {
                    setState(() => secondkey = val);
                    controller.clear(); //リセット処理
                  }
                  if (firstkey.isNotEmpty && secondkey.isNotEmpty) {
                    _search(firstkey, secondkey);
                    firstkey = '';
                    secondkey = '';
                  }
                },
              ),
            ),
            ListView.builder(
              //reverse: true, // この行を追加
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cakes.length,
              itemBuilder: (BuildContext context, int index) {
                final cake = _cakes[index];
                return ListTile(
                  title: Text(cake.name),
                  subtitle: Text("Yummyness: ${cake.yummyness}  ID:${cake.id}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteCake(cake),
                    //style: TextStyle(fontSize: 10)
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () => _editCake(cake),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: const Icon(
              Icons.add,
            ),
            onPressed: () => _addCake(firstkey, secondkey),
          ),
          FloatingActionButton(
            child: const Icon(
              Icons.sort,
            ),
            onPressed: _sort,
          ),
        ],
      ),
    );
  }

  _initCakes() async {
    await web.initCakes();
  }

  _loadCakes() async {
    final cakes = await web.getAllCakes();
    setState(() => _cakes = cakes);
  }

  _addCake(String farstkey, String secondkey) async {
    final name;
    final yummyness;
    if (firstkey.isEmpty) {
      final list = ["A001", "R001", "B001", "C001", "P001"]..shuffle();
      name = "Location ${list.first}";

      final sublist = ["R001", "B001", "C001", "P001"]..shuffle();
      yummyness = "Sub ${sublist.first}";
    } else {
      name = farstkey;
      yummyness = secondkey; //Random().nextInt(10);
    }

    final newCake = Cakes(id: Anything, name: name, yummyness: yummyness);
    await web.insertCakes(newCake);
    _loadCakes();
  }

  _deleteCake(Cakes cakes) async {
    await web.delete(cakes);
    _loadCakes();
  }

  _editCake(Cakes cakes) async {
    final list = ["apple", "orange", "chocolate"]..shuffle();
    final name = "My yummy ${list.first} cake";
    final updatedCake = cakes.copyWith(
        id: cakes.id, name: cakes.name, yummyness: cakes.yummyness + '1');
    await web.updateCakes(updatedCake);
    _loadCakes();
  }

  _sort() async {
    List<Cakes> sortresult = await web.sortCake();
    setState(() => _cakes = sortresult);
    //_loadCakes();
  }

  _search(String firstkey, String secondkey) async {
    // 指定した文字列(パターン)で始まるか否かを調べる。
    var name = '';
    String location = firstkey.substring(0, 1);
    if (location == 'a') {
      name =
          "Area to $firstkey  by  Rack $secondkey "; //"My yummy ${list.first} cake";
    }
    if (location == 'r') {
      name =
          "Rack to $firstkey  by $secondkey Board"; //"My yummy ${list.first} cake";
    }
    if (location == 'b') {
      name =
          "Board to $firstkey  by $secondkey Contaner"; //"My yummy ${list.first} cake";
    }
    if (location == 'p') {
      List<Cakes> sortresult = await web.search(firstkey);

      setState(() => _cakes = sortresult);
      print(_cakes.length);
      return;
    }

    //final id = 1;
    final yummyness = secondkey; // Random().nextInt(10);
    final newCake = Cakes(id: Anything, name: name, yummyness: yummyness);
    await web.insertCakes(newCake);
    _loadCakes();
  }
}

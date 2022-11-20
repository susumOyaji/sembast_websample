import 'package:flutter/rendering.dart';

class Cakes {
  final int id;
  final String name;
  final String yummyness;

  Cakes({required this.id, required this.name, required this.yummyness});

  Map<String, dynamic> toMap() {
    return {'name': this.name, 'yummyness': this.yummyness};
  }

  factory Cakes.fromMap(int id, Map<String, dynamic> map) {
    return Cakes(
      id: id,
      name: map['name'],
      yummyness: map['yummyness'],
    );
  }

  Cakes copyWith(
      {required int id, required String name, required String yummyness}) {
    return Cakes(
      id: id ?? this.id,
      name: name ?? this.name,
      yummyness: yummyness ?? this.yummyness,
    );
  }
}

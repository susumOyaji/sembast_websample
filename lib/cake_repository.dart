import 'model/cake.dart';

abstract class CakeRepository {
  Future initCakes();

  Future<int> insertCake(Cakes cake);

  Future updateCake(Cakes cake);

  Future deleteCake(int cakeId);

  Future<List<Cakes>> getAllCakes();

  Future sort();

  Future search(String firstkey);
}

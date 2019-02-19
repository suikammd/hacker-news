import 'news_api_provider.dart';
import 'news_db_provider.dart';
import 'dart:async';
import '../models/item_model.dart';

class Repository {
  NewsApiProvider apiProvider = NewsApiProvider();
  NewsDbProvider dbProvider = NewsDbProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    item = await apiProvider.fetchItems(id);
    dbProvider.addItem(item);
    return item;
  }
}
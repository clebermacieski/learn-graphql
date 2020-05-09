import 'package:app_boilerplate/model/feed_item.dart';

class FeedList {
  List<FeedItem> list = [
    FeedItem.fromElements('0', "lista vazia", "nada por aqui"),
  ];

  addFeed(String id, String username, String feed) {
    list.add(
      FeedItem.fromElements(id, username, feed),
    );
  }

  addfirstFeed(String id, String username, String feed) {
    list.insert(
      0,
      FeedItem.fromElements(id, username, feed),
    );
  }
}

FeedList feedList = new FeedList();

class PagedCollection<T> {
  final List<T> data;
  int page;
  int pageSize;
  int rowCount;
  int pageCount;

  PagedCollection({this.data, this.page, this.pageSize, this.rowCount, this.pageCount});

  factory PagedCollection.fromJson(Map<String, dynamic> json, Function fromJson) {
    final items = json['data'].cast<Map<String, dynamic>>();

    return PagedCollection<T>(
      data: List<T>.from(items.map((itemsJson) => fromJson(itemsJson))),
      page: json['meta']['page'],
      pageSize: json['meta']['pageSize'],
      rowCount: json['meta']['rowCount'],
      pageCount: json['meta']['pageCount']
    );
  }
}

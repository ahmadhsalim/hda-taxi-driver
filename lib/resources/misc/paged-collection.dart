class PagedCollection<T> {
  final List<T> data;
  int page;
  int pageSize;
  int rowCount;

  PagedCollection({this.data, this.page, this.pageSize, this.rowCount});

  factory PagedCollection.fromJson(
      Map<String, dynamic> json, Function fromJson) {
    final items = json['rows'].cast<Map<String, dynamic>>();

    return PagedCollection<T>(
        data: List<T>.from(items.map((itemsJson) => fromJson(itemsJson))),
        page: json['page']['number'],
        pageSize: json['page']['number'],
        rowCount: json['count']);
  }
}

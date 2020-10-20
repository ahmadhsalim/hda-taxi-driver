class ResourceCollection<T> {
  final List<T> data;

  ResourceCollection({this.data});

  factory ResourceCollection.fromJson(
      Map<String, dynamic> json, Function fromJson) {
    final items = json['data'].cast<Map<String, dynamic>>();

    return ResourceCollection<T>(
      data: List<T>.from(items.map((itemsJson) => fromJson(itemsJson))),
    );
  }
}

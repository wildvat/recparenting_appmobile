class FileRec {
  final String id;
  final String url;
  final String name;
  FileRec({
    required this.id,
    required this.url,
    required this.name,
  });

  FileRec.fromJson(Map<String, dynamic> json)
      : id = json['uuid'],
        url = json['url'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'name': name,
      };
}

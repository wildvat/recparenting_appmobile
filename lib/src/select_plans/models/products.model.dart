class Products {
  late List<Product?> list;

  Products({required this.list});

  Products.fromJson(Map<String, dynamic> json) {
    List<Product?> _list = [];
    for (var item in json.values) {
      _list.add(Product.fromJson(item));
    }
    list = _list;
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final String amount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print(json);
    try {
      String _price = '';
      String _amount = '0';
      if (json['prices'] != null && (json['prices'] as List).length > 0) {
        _price = json['prices'][0]['id'];
        _amount = json['prices'][0]['currency']['eur']['amount'];
      }

      return Product(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          price: _price,
          amount: _amount);
    } catch (e) {
      print(e.toString());
      return Product(
        id: '',
        name: '',
        description: '',
        price: '',
        amount: '0',
      );
    }
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  bool _isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    bool isAvailable = true,
  }) : _isAvailable = isAvailable;

  bool get isAvailable => _isAvailable;

  void markUnavailable() => _isAvailable = false;
  void markAvailable() => _isAvailable = true;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
    'isAvailable': _isAvailable ? 1 : 0,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    price: map['price'],
    imageUrl: map['imageUrl'],
    category: map['category'],
    isAvailable: map['isAvailable'] == 1,
  );
}

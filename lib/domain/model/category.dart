class Category {
  final int id;
  final String name;
  bool _isActive;

  Category({
    required this.id,
    required this.name,
    bool isActive = true,
  }) : _isActive = isActive;

  bool get isActive => _isActive;

  void deactivate() => _isActive = false;
  void activate() => _isActive = true;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isActive': _isActive ? 1 : 0,
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'],
        name: map['name'],
        isActive: map['isActive'] == 1,
      );
}

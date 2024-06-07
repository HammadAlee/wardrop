class Outfit {
  int id;
  String name;
  String category;
  List<int> itemsInOutfit;
  int dateAdded;
  List<bool> seasons;
  List<String> seasonNames = [];

  Outfit({
    required this.id,
    required this.name,
    required this.category,
    required this.itemsInOutfit,
    required this.dateAdded,
    required this.seasons,
  }) {
    if (seasons[0]) seasonNames.add('Summer');
    if (seasons[1]) seasonNames.add('Spring');
    if (seasons[2]) seasonNames.add('Fall');
    if (seasons[3]) seasonNames.add('Winter');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'dateAdded': dateAdded,
      'summer': boolToInt(seasons[0]),
      'spring': boolToInt(seasons[1]),
      'fall': boolToInt(seasons[2]),
      'winter': boolToInt(seasons[3]),
    };
  }

  Outfit.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        category = map['category'],
        dateAdded = map['dateAdded'],
        seasons = [
          intToBool(map['summer']),
          intToBool(map['spring']),
          intToBool(map['fall']),
          intToBool(map['winter']),
        ],
        itemsInOutfit = [] {
    if (seasons[0]) seasonNames.add('Summer');
    if (seasons[1]) seasonNames.add('Spring');
    if (seasons[2]) seasonNames.add('Fall');
    if (seasons[3]) seasonNames.add('Winter');
  }

  static int boolToInt(bool b) {
    return b ? 1 : 0;
  }

  static bool intToBool(int x) {
    return x == 1;
  }

  bool contains(String str) {
    return name.toLowerCase().contains(str.toLowerCase()) ||
        category.toLowerCase().contains(str.toLowerCase());
  }

  @override
  String toString() {
    return '$id $name $category ${itemsInOutfit.toString()}';
  }
}

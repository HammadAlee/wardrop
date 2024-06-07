import 'package:flutter/material.dart';

class Item {
  int id;
  String image;
  String name;
  String color;
  String category;
  int dateAdded;
  late Image imageWidget;

  Item({
    required this.id,
    required this.image,
    required this.name,
    required this.color,
    required this.category,
    required this.dateAdded,
  }) {
    imageWidget = Image.network(
        image); // Initialize the imageWidget based on the image URL
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'color': color,
      'category': category,
      'dateAdded': dateAdded,
    };
  }

  Item.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        image = map['image'],
        name = map['name'],
        color = map['color'],
        category = map['category'],
        dateAdded = map['dateAdded'] {
    imageWidget = Image.network(
        image); // Initialize the imageWidget based on the image URL
  }

  bool contains(String str) {
    return name.toLowerCase().contains(str.toLowerCase()) ||
        color.toLowerCase().contains(str.toLowerCase()) ||
        category.toLowerCase().contains(str.toLowerCase());
  }
}

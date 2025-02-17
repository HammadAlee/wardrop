import 'package:flutter/material.dart';
import 'package:wardrobe/models/item_model.dart';

class FullImageScreen extends StatelessWidget {
  final Image itemImage;
  final Item item;

  const FullImageScreen({
    Key? key,
    required this.itemImage,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: item.id,
            child: item.imageWidget,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

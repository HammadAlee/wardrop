import 'package:flutter/material.dart';
import 'package:wardrobe/models/item_model.dart';
import 'package:wardrobe/widgets/filter_tabs.dart';
import 'package:wardrobe/widgets/item_card.dart';
import 'package:wardrobe/widgets/search_bar.dart';

class ItemScreen extends StatefulWidget {
  final List<Item> items;
  final void Function(Item) onItemCardTap;
  final List<Item> selectedItems;
  ItemScreen({Key? key, required this.items, required this.onItemCardTap, required this.selectedItems})
      : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> with TickerProviderStateMixin {
  late List<Item> _items;

  final TextEditingController _searchController = TextEditingController();
  late List<int> _searchItems;

  final List<String> _filterTabNames = [
    'All',
    'Tops',
    'Bottoms',
    'Accessories'
  ];
  late int _numFilterTabs;
  late List<List<int>> _filterItems;
  late TabController _tabController;

  late List<List<int>> _searchFilterItems;

  late void Function(Item) _onItemCardTap;
  late List<Item> _selectedItems;

  @override
  initState() {
    super.initState();
    _items = widget.items ?? [];
    _searchItems = [];
    _numFilterTabs = _filterTabNames.length;
    _filterItems = List.filled(_numFilterTabs, []);
    _searchFilterItems = List.filled(_numFilterTabs, []);
    _tabController = TabController(length: _numFilterTabs, vsync: this);

    _onItemCardTap = widget.onItemCardTap ?? (_) {};
    _selectedItems = widget.selectedItems ?? [];
  }

  @override
  void dispose() {
    //_itemDbHelper.close();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _updateSearchItems(List<int> searchedList) {
    _searchItems = searchedList;
    _combineSearchFilterItems();
    _reload();
  }

  // void _updateFilterItems(List<List<int>> filteredList) {
  //   _filterItems = filteredList;
  //   _combineSearchFilterItems();
  //   //_reload();
  // }

  void _combineSearchFilterItems() {
    List<int> tempList = [];
    _searchFilterItems = List.filled(_numFilterTabs, []);

    for (int i = 0; i < _numFilterTabs; i++) {
      tempList = [];
      for (int j = 0; j < _items.length; j++) {
        if (_filterItems[i].contains(j) && _searchItems.contains(j)) {
          tempList.add(j);
          _searchFilterItems[i] = tempList;
        }
      }
    }
  }

  void _reload() {
    setState(() {});
  }

  void updateLists() {
    // initializes filterItems, searchItems, and searchFilterItems to have all items
    // also, rebuilds the lists if a new item is added (2nd part of OR statement)
    if (_filterItems[0].isEmpty || _filterItems[0].length != _items.length) {
      List<int> tempList = [];
      _filterItems = List.filled(_numFilterTabs, []);
      _filterItems[0] = List.generate(_items.length, (index) => index);
      for (int i = 1; i < _numFilterTabs; i++) {
        tempList = [];
        for (int j = 0; j < _items.length; j++) {
          if (_items[j].contains(_filterTabNames[i])) {
            tempList.add(j);
            _filterItems[i] = tempList;
          }
        }
      }

      _searchItems = List.generate(_items.length, (index) => index);
      _combineSearchFilterItems();
      //_searchFilterItems[0] = List.generate(_items.length, (index) => index);
    }
  }

  GridView _buildGridView(int index) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 8.0 / 10.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: _searchFilterItems[index].length,
      itemBuilder: (BuildContext context, int index2) {
        Item item = _items[_searchFilterItems[index][index2]];
        Image itemImage = item.imageWidget;
        bool selected = _selectedItems.contains(item);

        return Stack(
          children: [
            Hero(
              tag: item.id,
              child: ItemCard(
                itemImage: itemImage,
                selected: selected,
              ),
            ),
            //transparent overlay for inkwell effect
            Positioned.fill(
              bottom: 2.5,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.all(6.0), //same as ItemCard/OutfitCard
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                        12.0), //same as ItemCard/OutfitCard
                    onTap: () => _onItemCardTap(item),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    updateLists();

    return Column(
      children: <Widget>[
        SearchBar(
          searchController: _searchController,
          listToSearch: _items,
          updateParent: _updateSearchItems,
        ),
        FilterTabs(
          tabController: _tabController,
          //listToFilter: _items,
          tabNames: _filterTabNames,
          //updateParent: _updateFilterItems,
          //reloadParent: _reload,
        ),
        Flexible(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(
              _numFilterTabs,
              (index) => _buildGridView(index),
            ),
          ),
        ),
      ],
    );
  }
}

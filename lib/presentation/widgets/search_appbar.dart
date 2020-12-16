import 'package:flutter/material.dart';

// appBar с поисковой строкой для страницы с flickr
class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => _SearchAppBarState();
  final Color color;
  final Function onSearch;

  SearchAppBar({
    this.color,
    this.onSearch,
  });
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isActiveSearch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isActiveSearch
        ? AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: widget.color,
            title: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 14),
              onSubmitted: (String _value) {
                if (_value != '') {
                  widget.onSearch(_value);
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Waterfall',
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    FocusScope.of(context).canRequestFocus = false;
                    setState(() => _isActiveSearch = false);
                    Future.delayed(Duration(milliseconds: 1), () {
                      FocusScope.of(context).canRequestFocus = true;
                    });
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.text = '';
                  },
                ),
              ),
            ),
          )
        : AppBar(
            backgroundColor: widget.color,
            title: Text(
              'Flickr',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isActiveSearch = true;
                    });
                  }),
            ],
          );
  }
}

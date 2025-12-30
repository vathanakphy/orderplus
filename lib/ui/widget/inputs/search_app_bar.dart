import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  final String? title;
  final Widget? titleWidget; // Accept a custom widget (e.g., logo)
  final IconButton? backButton;
  final ValueChanged<String>? onSearchChanged;

  const SearchAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onSearchChanged,
    this.backButton,
  }) : assert(
         title != null || titleWidget != null,
         'Either title or titleWidget must be provided',
       );

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    widget.onSearchChanged;
                  });
                },
              )
            : Row(
                children: [
                  if (widget.backButton != null) widget.backButton!,
                  widget.titleWidget ??
                      Text(
                        widget.title!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                ],
              ),
        _isSearching
            ? Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, // no outer line
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                  onChanged: (value) {
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!(value);
                    }
                  },
                ),
              )
            : IconButton(
                icon: const Icon(Icons.search, size: 28),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
      ],
    );
  }
}

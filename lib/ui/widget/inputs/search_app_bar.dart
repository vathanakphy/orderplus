import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final IconButton? backButton;
  final ValueChanged<String>? onSearchChanged;

  const SearchAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.backButton,
    this.onSearchChanged,
  });

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _controller.clear();
    });
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(""); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isSearching && widget.backButton != null) widget.backButton!,
        const SizedBox(width: 8),
        // Title or nothing when searching
        if (!_isSearching)
          Expanded(
            child:
                widget.titleWidget ??
                (widget.title != null
                    ? Text(
                        widget.title!,
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : const SizedBox.shrink()),
          ),
        if (_isSearching)
          Expanded(
            child: TextField(
              controller: _controller,
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
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: widget.onSearchChanged,
            ),
          ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search, size: 28),
          onPressed: _isSearching ? _stopSearch : _startSearch,
        ),
      ],
    );
  }
}

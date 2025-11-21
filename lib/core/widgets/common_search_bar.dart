import 'package:flutter/material.dart';

class CommonSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const CommonSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (value) {
        setState(() {});
        widget.onChanged(value);
      },
    );
  }
}

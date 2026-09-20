import 'package:material_ui/material_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;
  final String hint;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.hint = "Select",
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(covariant MultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      _selectedItems = List.from(widget.selectedItems);
    }
  }

  void _onItemTapped(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });

    widget.onChanged(_selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        key: ValueKey(_selectedItems.length), // 🔥 force rebuild

        isExpanded: true,

        // 👇 important fix for text update
        onChanged: (value) {
          _selectedItems.add(value!);
        },

        hint: Text(widget.hint),

        items: widget.items.map((item) {
          return DropdownItem<String>(
            value: item,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                final isSelected = _selectedItems.contains(item);

                return InkWell(
                  onTap: () {
                    _onItemTapped(item);
                    menuSetState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),

        selectedItemBuilder: (context) {
          return widget.items.map((_) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedItems.isEmpty
                    ? widget.hint
                    : _selectedItems.join(", "),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList();
        },

        buttonStyleData: ButtonStyleData(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),

        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../core/static/theme/theme.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String? hint;
  final String? label;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String Function(T)? itemAsString;

  const AppDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.label,
    this.validator,
    this.itemAsString,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  late final ValueNotifier<T?> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = ValueNotifier<T?>(widget.value);
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _valueNotifier.value = widget.value;
    }
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.text.primary,
            ),
          ),
          SizedBox(height: dimensions.spacing.s8),
        ],
        FormField<T>(
          initialValue: widget.value,
          validator: widget.validator,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<T>(
                    isExpanded: true,
                    valueListenable: _valueNotifier,
                    hint: widget.hint != null
                        ? Text(
                            widget.hint!,
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.text.secondary,
                            ),
                          )
                        : null,
                    items: widget.items.map((item) {
                      return DropdownItem<T>(
                        value: item,
                        child: Text(
                          widget.itemAsString?.call(item) ?? item.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.text.primary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      _valueNotifier.value = val;
                      field.didChange(val);
                      widget.onChanged(val);
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(
                        horizontal: dimensions.padding.p4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          dimensions.radius.r10,
                        ),
                        border: Border.all(
                          color: field.hasError ? colors.error : colors.border,
                        ),
                        color: colors.onPrimary,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          dimensions.radius.r10,
                        ),
                        color: colors.onPrimary,
                      ),
                      elevation: 2,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      padding: EdgeInsets.symmetric(
                        horizontal: dimensions.padding.p16,
                      ),
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(color: colors.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

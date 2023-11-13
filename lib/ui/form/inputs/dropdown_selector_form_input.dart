import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/inputs/form_input.dart';

class DropdownSelectorFormInput<T> extends StatefulWidget {
  final GlobalKey<CustomFormState> formKey;
  final String id;
  final String label;
  final String iconName;
  final Map<T, String> options;
  final T? initial;
  final bool required;

  const DropdownSelectorFormInput({
    super.key,
    required this.formKey,
    required this.id,
    required this.label,
    required this.iconName,
    required this.options,
    this.initial,
    this.required = false,
  });

  @override
  State<DropdownSelectorFormInput<T>> createState() => _DropdownSelectorFormInputState<T>();
}

class _DropdownSelectorFormInputState<T> extends State<DropdownSelectorFormInput<T>>
    implements FormInput {
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
    widget.formKey.currentState!.addFormInput(widget.id, this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownMenu(
        label: Text(widget.label),
        leadingIcon: CustomIcon(name: widget.iconName, style: Style.regular),
        initialSelection: widget.initial,
        dropdownMenuEntries: widget.options.entries
            .map((e) => DropdownMenuEntry(value: e.key, label: e.value))
            .toList(),
        width: constraints.maxWidth,
        onSelected: (value) => {_value = value},
      );
    });
  }

  @override
  get value => _value;
}

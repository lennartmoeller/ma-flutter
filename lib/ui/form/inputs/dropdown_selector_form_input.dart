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
  final void Function(T?)? onSaved;

  const DropdownSelectorFormInput({
    super.key,
    required this.formKey,
    required this.id,
    required this.label,
    required this.iconName,
    required this.options,
    this.initial,
    this.required = false,
    this.onSaved,
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
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: widget.label,
        icon: CustomIcon(name: widget.iconName, style: Style.regular),
      ),
      value: widget.initial,
      items: widget.options.entries
          .map((e) => DropdownMenuItem<T>(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: (value) {
        _value = value;
      },
      onSaved: widget.onSaved,
      validator: (value) =>
          widget.required && value == null ? "Dieses Feld ist erforderlich" : null,
    );
  }

  @override
  get value => _value;
}

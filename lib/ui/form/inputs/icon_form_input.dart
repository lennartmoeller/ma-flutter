import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/form/inputs/form_input.dart';

class IconFormInput extends FormInput {
  IconFormInput({
    required super.formKey,
    required super.id,
    required super.label,
    String? initial = "",
    super.iconName = "icons",
    String? Function(String?)? validator,
    super.onSaved,
    super.required = true,
  }) : super(
            controller: TextEditingController(text: initial),
            validator: (String? value) {
              var output = validator?.call(value);
              if (output != null) {
                return output;
              }
              if (value != null && value.isNotEmpty && !RegExp(r'^[0-9a-z-]+$').hasMatch(value)) {
                return "Bitte gib einen validen Namen für ein Icon an.";
              }
              return null;
            });

  @override
  String get value => controller?.text ?? "";
}
